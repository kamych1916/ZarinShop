import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/utils/check_internet_connection.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

class UserApiProvider {
  Future<ApiResponse<bool>> signIn(String email, String password) async {
    String url = "http://zarinshop.site:49354/api/v1/signin";

    IOClient client = new IOClient();
    String body = '{"email": "$email", "password": "$password"}';

    try {
      Response response =
          await client.post(url, body: body).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) return ApiResponse.completed(true);
      if (response.statusCode == 401) return ApiResponse.completed(false);

      return ApiResponse.error("При входе возникла ошибка");
    } catch (exception) {
      bool internetStatus = await checkInternetConnection();

      return internetStatus
          ? exception.runtimeType == SocketException ||
                  exception.runtimeType == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }

  Future<ApiResponse<bool>> resetPassword(String email) async {
    String url = "http://zarinshop.site:49354/api/v1/reset_password";

    IOClient client = new IOClient();
    String parameters = "?email=$email";

    try {
      Response response =
          await client.get(url + parameters).timeout(Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201)
        return ApiResponse.completed(true);
      if (response.statusCode == 403) return ApiResponse.completed(false);

      return ApiResponse.error("При востановлении пароля возника ошибка");
    } catch (exception) {
      bool internetStatus = await checkInternetConnection();

      return internetStatus
          ? exception == SocketException || exception == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }

  Future<ApiResponse<bool>> signUp(
      String email, String password, firstName, lastName) async {
    String url = "http://zarinshop.site:49354/api/v1/signup";

    IOClient client = new IOClient();
    String body =
        '{"email": "$email", "password": "$password", "first_name": "$firstName","last_name": "$lastName"}';

    try {
      Response response =
          await client.post(url, body: body).timeout(Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201)
        return ApiResponse.completed(true);
      if (response.statusCode == 403) return ApiResponse.completed(false);

      return ApiResponse.error("При регистрации произошла ошибка");
    } catch (exception) {
      bool internetStatus = await checkInternetConnection();

      return internetStatus
          ? exception.runtimeType == SocketException ||
                  exception.runtimeType == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }

  Future<ApiResponse<bool>> checkSignUpCode(String code, String email) async {
    String url = "http://zarinshop.site:49354/api/v1/checkcode_activ";

    IOClient client = new IOClient();
    String parameters = "/$code?email=$email";

    try {
      Response response =
          await client.get(url + parameters).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) return ApiResponse.completed(true);
      if (response.statusCode == 401) return ApiResponse.completed(false);

      return ApiResponse.error("При проверке кода возникла ошибка");
    } catch (exception) {
      bool internetStatus = await checkInternetConnection();

      return internetStatus
          ? exception == SocketException || exception == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }

  Future<ApiResponse<bool>> checkPasswordResetCode(
      String code, String email, String password) async {
    String url = "http://zarinshop.site:49354/api/v1/change_password";

    IOClient client = new IOClient();
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
      bool internetStatus = await checkInternetConnection();

      return internetStatus
          ? exception == SocketException || exception == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }
}
