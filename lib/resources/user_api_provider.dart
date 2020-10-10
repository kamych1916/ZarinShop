import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/utils/check_internet_connection.dart';
import 'package:http/io_client.dart';

import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

class UserApiProvider {
  Future<ApiResponse<bool>> signIn(String email, String password) async {
    print("Пользователь входит в личный кабинет");
    print(email);
    print(password);
    return ApiResponse.completed(false);
  }

  Future<ApiResponse<bool>> resetPassword(String email) async {
    await Future.delayed(Duration(seconds: 5));
    print("Пользователь восстанавливает пароль");
    print(email);
    return ApiResponse.error("Error");
  }

  Future<ApiResponse<bool>> signUp(
      String email, String password, firstName, lastName) async {
    print("Пользователь регистрируется");
    print(email);
    print(password);
    print(firstName);
    print(lastName);
    return ApiResponse.completed(true);
  }
}
