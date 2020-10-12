import 'dart:async';
import 'package:Zarin/models/api_response_model.dart';
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

  List<String> signUpInputStrings = new List(2);

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

  Future<ApiResponse<bool>> signIn() async {
    this.responseAwait;
    ApiResponse<bool> response = await _userApiProvider.signIn(email, password);
    auth = response.status == Status.COMPLETED && response.data;
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

    ApiResponse<bool> response =
        await _userApiProvider.signUp(email, password, firstName, lastName);

    this.responseDone;
    return response;
  }

  final int mainLoginPage = 3;
  int currentPage = 3;
  final PageController pageController = new PageController(initialPage: 3);
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
    this.responseDone;
    return response;
  }
}

final UserBloc userBloc = UserBloc();
