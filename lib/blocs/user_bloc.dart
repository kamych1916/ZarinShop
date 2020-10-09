import 'dart:async';
import 'package:Zarin/models/api_response_model.dart';

import '../utils/strings.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _repository = Repository();
  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  bool auth = false;

  Stream<String> get emailStream => _emailSubject.stream;

  Stream<String> get passwordStream => _passwordSubject.stream;

  Stream<bool> get signInStream => _isSignedIn.stream;

  String get email => _emailSubject.value;
  String get password => _passwordSubject.value;

  Function(String) get changeEmail => _emailSubject.sink.add;

  Function(String) get changePassword => _passwordSubject.sink.add;

  Function(bool) get isSignedIn => _isSignedIn.sink.add;
  Function(String) get signedError => _isSignedIn.sink.addError;

  bool validateEmail() {
    if (email == null || email.isEmpty) {
      _emailSubject.sink.addError(StringConstant.emailValidateMessage);
      return false;
    } else
      return true;
  }

  bool validatePassword() {
    if (password == null || password.isEmpty) {
      _passwordSubject.sink.addError(StringConstant.passwordValidateMessage);
      return false;
    } else
      return true;
  }

  bool validateFields() => validateEmail() && validatePassword();

  Future<ApiResponse<bool>> submit() async {
    ApiResponse<bool> authResponse =
        await _repository.authenticateUser(email, password);

    auth = authResponse.status == Status.COMPLETED && authResponse.data;

    return authResponse;
  }

  void dispose() async {
    await _emailSubject.drain();
    _emailSubject.close();
    await _passwordSubject.drain();
    _passwordSubject.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
  }
}

final UserBloc userBloc = UserBloc();
