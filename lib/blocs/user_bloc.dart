import 'dart:async';
import 'package:Zarin/models/api_response_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _repository = Repository();
  final _emailSubject = BehaviorSubject<String>()
    ..listen((value) => print(value));
  final _passwordSubject = BehaviorSubject<String>();

  bool auth = false;

  List<String> signUpInputStrings = new List(2);

  Stream<String> get emailStream => _emailSubject.stream;

  Stream<String> get passwordStream => _passwordSubject.stream;

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
    ApiResponse<bool> response = await _repository.signIn(email, password);

    auth = response.status == Status.COMPLETED && response.data;

    return response;
  }

  void dispose() async {
    await _emailSubject.drain();
    _emailSubject.close();
    await _passwordSubject.drain();
    _passwordSubject.close();
  }

  Future<ApiResponse<bool>> resetPassword() async {
    ApiResponse<bool> response = await _repository.resetPassword(email);
    return response;
  }

  Future<ApiResponse<bool>> signUp() async {
    String firstName = signUpInputStrings[0];
    String lastName = signUpInputStrings[1];

    ApiResponse<bool> response =
        await _repository.signUp(email, password, firstName, lastName);
    return response;
  }
}

final UserBloc userBloc = UserBloc();
