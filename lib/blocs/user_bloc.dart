import 'dart:async';
import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/event.dart';
import 'package:Zarin/resources/user_api_provider.dart';
import 'product_bloc.dart';

import 'package:requests/requests.dart' as package;

class UserBloc {
  final _userApiProvider = UserApiProvider();

  final Event<bool> auth = Event(initValue: false);
  final Event<String> email = Event();
  final Event<String> password = Event();
  final Event<bool> clearVerificationCodeInput = Event();

  String firstName;
  String lastName;
  String userID;

  List<String> signUpInputStrings = new List(3);

  bool validateEmail() {
    if (email == null || email.value.isEmpty) {
      email.error("Введите ваш email");
      return false;
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(email.value)) {
      email.error("Email введен неверно");
      return false;
    }

    return true;
  }

  bool validatePassword() {
    if (password == null || password.value.isEmpty) {
      password.error("Введите пароль");
      return false;
    }

    if (password.value.length < 8) {
      password.error("Пароль должен быть длиннее 8 символов");
      return false;
    }
    return true;
  }

  bool validateFields() => validateEmail() && validatePassword();

  Future<ApiResponse<dynamic>> signIn() async {
    appBloc.apiResponse.publish(true);
    ApiResponse<dynamic> response =
        await _userApiProvider.signIn(email.value, password.value);

    if (response.data is bool &&
        response.status == Status.COMPLETED &&
        !response.data)
      auth.publish(false);
    else if (response.data is Map && response.status == Status.COMPLETED) {
      auth.publish(true);
      userID = response.data["id"];
      firstName = response.data["first_name"];
      lastName = response.data["last_name"];
      saveUser();
    }

    appBloc.apiResponse.publish(false);
    return response;
  }

  Future<ApiResponse<bool>> resetPassword() async {
    appBloc.apiResponse.publish(true);

    ApiResponse<bool> response =
        await _userApiProvider.resetPassword(email.value);
    appBloc.apiResponse.publish(false);
    return response;
  }

  Future<ApiResponse<bool>> signUp() async {
    appBloc.apiResponse.publish(true);
    String firstName = signUpInputStrings[0];
    String lastName = signUpInputStrings[1];
    String phone = signUpInputStrings[2];

    ApiResponse<bool> response = await _userApiProvider.signUp(
        email.value, password.value, firstName, lastName, phone);

    appBloc.apiResponse.publish(false);
    return response;
  }

  Future<ApiResponse<bool>> checkSignUpCode(String code) async {
    appBloc.apiResponse.publish(true);
    ApiResponse<bool> response =
        await _userApiProvider.checkSignUpCode(code, email.value);
    appBloc.apiResponse.publish(false);
    return response;
  }

  Future<ApiResponse<bool>> checkPasswordResetCode(
      String code, String password) async {
    appBloc.apiResponse.publish(true);
    ApiResponse<bool> response = await _userApiProvider.checkPasswordResetCode(
        code, email.value, password);

    if (response.data == true && response.status == Status.COMPLETED) {
      this.password.publish(password);
      saveUser();
    }

    appBloc.apiResponse.publish(false);
    return response;
  }

  logout() {
    auth.publish(false);
    appBloc.prefs.setBool("auth", auth.value);
    productBloc.clearCart();
    package.Requests.clearStoredCookies("zarinshop.site:49354");
  }

  saveUser() {
    appBloc.prefs.setBool("auth", auth.value);
    appBloc.storage.write(key: "email", value: email.value);
    appBloc.storage.write(key: "password", value: password.value);
  }

  Future<bool> getUser() async {
    bool auth = appBloc.prefs.getBool("auth");
    if (auth == null || !auth) return false;

    String email = await appBloc.storage.read(key: "email");
    String password = await appBloc.storage.read(key: "password");

    ApiResponse<dynamic> response =
        await _userApiProvider.signIn(email, password);

    if (response.data is Map && response.status == Status.COMPLETED) {
      this.auth.publish(true);
      userID = response.data["id"];
      firstName = response.data["first_name"];
      lastName = response.data["last_name"];

      this.email.publish(response.data["email"]);
      return true;
    }

    return false;
  }

  void dispose() async {
    await auth.dispose();
    await email.dispose();
    await password.dispose();
    await clearVerificationCodeInput.dispose();
  }
}

final UserBloc userBloc = UserBloc();
