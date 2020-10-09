import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/utils/check_internet_connection.dart';
import 'package:http/io_client.dart';

import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

class UserApiProvider {
  Future<ApiResponse<bool>> authenticateUser(
      String email, String password) async {
    bool internet = await checkInternetConnection();
    if (!internet)
      return Future.delayed(Duration(seconds: 1),
          () => ApiResponse.internalError("Нет соединения"));

    String url = "http://zarinshop.site:49354/api/v1/categories";

    final IOClient httpClient = new IOClient();
    final response = await httpClient.get(
      url,
    );
    final responseDecode = json.decode(utf8.decode(response.bodyBytes));
    print(responseDecode);
  }
}
