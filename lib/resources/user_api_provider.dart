import 'dart:io';

import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/utils/utils.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import 'dart:async';
import 'dart:convert' show json, utf8;

class UserApiProvider {
  static String token;
  IOClient client = new IOClient();

  void _setToken(String cookie) {
    token = cookie.substring(cookie.indexOf("session_token=") + 14,
        cookie.indexOf(";", cookie.indexOf("session_token=")));
  }

  Future<ApiResponse<dynamic>> signIn(String email, String password) async {
    String url = "https://mirllex.site/server/api/v1/signin";
    String body = '{"email": "$email", "password": "$password"}';

    try {
      var response =
          await client.post(url, body: body).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        _setToken(response.headers["set-cookie"]);
        return ApiResponse.completed(
            json.decode(utf8.decode(response.bodyBytes)));
      }
      if (response.statusCode == 401) return ApiResponse.completed(false);

      return ApiResponse.error("При входе возникла ошибка");
    } catch (exception) {
      bool internetStatus = await Utils.checkInternetConnection();

      return internetStatus
          ? exception.runtimeType == SocketException ||
                  exception.runtimeType == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }

  Future<ApiResponse<bool>> resetPassword(String email) async {
    String url = "https://mirllex.site/server/api/v1/reset_password";
    String parameters = "?email=$email";

    try {
      Response response =
          await client.get(url + parameters).timeout(Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201)
        return ApiResponse.completed(true);
      if (response.statusCode == 403) return ApiResponse.completed(false);

      return ApiResponse.error("При востановлении пароля возника ошибка");
    } catch (exception) {
      bool internetStatus = await Utils.checkInternetConnection();

      return internetStatus
          ? exception == SocketException || exception == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }

  Future<ApiResponse<bool>> signUp(
      String email, String password, firstName, lastName, phone) async {
    String url = "https://mirllex.site/server/api/v1/signup";
    String body =
        '{"email": "$email", "password": "$password", "first_name": "$firstName","last_name": "$lastName", "phone": $phone}';

    try {
      Response response =
          await client.post(url, body: body).timeout(Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201)
        return ApiResponse.completed(true);
      if (response.statusCode == 403) return ApiResponse.completed(false);

      return ApiResponse.error("При регистрации произошла ошибка");
    } catch (exception) {
      bool internetStatus = await Utils.checkInternetConnection();

      return internetStatus
          ? exception.runtimeType == SocketException ||
                  exception.runtimeType == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }

  Future<ApiResponse<bool>> checkSignUpCode(String code, String email) async {
    String url = "https://mirllex.site/server/api/v1/checkcode_activ";
    String parameters = "?code=$code&email=$email";

    try {
      Response response =
          await client.get(url + parameters).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) return ApiResponse.completed(true);
      if (response.statusCode == 401) return ApiResponse.completed(false);

      return ApiResponse.error("При проверке кода возникла ошибка");
    } catch (exception) {
      bool internetStatus = await Utils.checkInternetConnection();

      return internetStatus
          ? exception == SocketException || exception == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }

  Future<ApiResponse<bool>> checkPasswordResetCode(
      String code, String email, String password) async {
    String url = "https://mirllex.site/server/api/v1/change_password";
    String parameters = "?code=$code&new_password=$password&email=$email";

    try {
      Response response =
          await client.post(url + parameters).timeout(Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201)
        return ApiResponse.completed(true);
      if (response.statusCode == 401 || response.statusCode == 403)
        return ApiResponse.completed(false);

      return ApiResponse.error("При проверке кода возникла ошибка");
    } catch (exception) {
      bool internetStatus = await Utils.checkInternetConnection();

      return internetStatus
          ? exception == SocketException || exception == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }
}
