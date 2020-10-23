import 'dart:async';
import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/resources/user_api_provider.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _userApiProvider = UserApiProvider();
  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _responseAwaitSubject = PublishSubject<bool>();
  final _clearCodeVerifyInputsSubject = PublishSubject<bool>();

  bool auth = false;
  String firstName;
  String lastName;
  String userID;

  List<String> signUpInputStrings = new List(3);

  Stream<String> get emailStream => _emailSubject.stream;

  Stream<String> get passwordStream => _passwordSubject.stream;

  Stream<bool> get responseStream => _responseAwaitSubject.stream;

  Stream<bool> get clearCodeVerifyInputsStream =>
      _clearCodeVerifyInputsSubject.stream;

  get clearCodeVerifyInputs => _clearCodeVerifyInputsSubject.sink.add(true);
  get responseAwait => _responseAwaitSubject.sink.add(true);
  get responseDone => _responseAwaitSubject.sink.add(false);

  String get email => _emailSubject.value;
  String get password => _passwordSubject.value;

  Function(String) get changeEmail => _emailSubject.sink.add;

  Function(String) get changePassword => _passwordSubject.sink.add;

  bool validateEmail() {
    if (email == null || email.isEmpty) {
      _emailSubject.sink.addError("Введите ваш email");
      return false;
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(email)) {
      _emailSubject.sink.addError("Email введен неверно");
      return false;
    }

    return true;
  }

  bool validatePassword() {
    if (password == null || password.isEmpty) {
      _passwordSubject.sink.addError("Введите пароль");
      return false;
    }

    if (password.length < 8) {
      _passwordSubject.sink.addError("Пароль должен быть длиннее 8 символов");
      return false;
    }
    return true;
  }

  bool validateFields() => validateEmail() && validatePassword();

  Future<ApiResponse<dynamic>> signIn() async {
    this.responseAwait;
    ApiResponse<dynamic> response =
        await _userApiProvider.signIn(email, password);

    if (response.data is bool &&
        response.status == Status.COMPLETED &&
        !response.data)
      auth = false;
    else if (response.data is Map && response.status == Status.COMPLETED) {
      auth = true;
      userID = response.data["id"];
      firstName = response.data["first_name"];
      lastName = response.data["last_name"];
      saveUser();
    }

    this.responseDone;
    return response;
  }

  Future<ApiResponse<bool>> resetPassword() async {
    this.responseAwait;
    ApiResponse<bool> response = await _userApiProvider.resetPassword(email);
    this.responseDone;
    return response;
  }

  Future<ApiResponse<bool>> signUp() async {
    this.responseAwait;
    String firstName = signUpInputStrings[0];
    String lastName = signUpInputStrings[1];
    String phone = signUpInputStrings[1];

    /// TODO: Добавить номер телефона

    ApiResponse<bool> response =
        await _userApiProvider.signUp(email, password, firstName, lastName);

    this.responseDone;
    return response;
  }

  final int mainLoginPage = 2;
  int currentPage = 2;
  final PageController pageController = new PageController(initialPage: 2);
  bool canFieldsRequestFocus = true;

  Future animateLoginScreenLeft() async =>
      await pageController.animateToPage(--currentPage,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  Future animateLoginScreenRight() async =>
      await pageController.animateToPage(++currentPage,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  Future animateLoginScreenToMainPage() async {
    currentPage = mainLoginPage;
    await pageController.animateToPage(mainLoginPage,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void dispose() async {
    await _emailSubject.drain();
    _emailSubject.close();
    await _passwordSubject.drain();
    _passwordSubject.close();
    await _responseAwaitSubject.drain();
    _responseAwaitSubject.close();
    await _clearCodeVerifyInputsSubject.drain();
    _clearCodeVerifyInputsSubject.close();
  }

  Future<ApiResponse<bool>> checkSignUpCode(String code) async {
    this.responseAwait;
    ApiResponse<bool> response =
        await _userApiProvider.checkSignUpCode(code, email);
    this.responseDone;
    return response;
  }

  Future<ApiResponse<bool>> checkPasswordResetCode(
      String code, String password) async {
    this.responseAwait;
    ApiResponse<bool> response =
        await _userApiProvider.checkPasswordResetCode(code, email, password);

    if (response.data == true && response.status == Status.COMPLETED) {
      _passwordSubject.sink.add(password);
      saveUser();
    }

    this.responseDone;
    return response;
  }

  logout() {
    auth = false;
    appBloc.prefs.setBool("auth", auth);
  }

  saveUser() {
    appBloc.prefs.setBool("auth", auth);
    appBloc.storage.write(key: "email", value: email);
    appBloc.storage.write(key: "password", value: password);
  }

  Future<bool> getUser() async {
    bool auth = appBloc.prefs.getBool("auth");
    if (auth == null || !auth) return false;

    String email = await appBloc.storage.read(key: "email");
    String password = await appBloc.storage.read(key: "password");

    ApiResponse<dynamic> response =
        await _userApiProvider.signIn(email, password);

    if (response.data is Map && response.status == Status.COMPLETED) {
      this.auth = true;
      userID = response.data["id"];
      firstName = response.data["first_name"];
      lastName = response.data["last_name"];

      _emailSubject.sink.add(response.data["email"]);
      return true;
    }

    return false;
  }
}

final UserBloc userBloc = UserBloc();
