import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/utils/check_internet_connection.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class ProductApiProvider {
  Future<ApiResponse<List<Category>>> getCategories() async {
    String url = "http://zarinshop.site:49354/api/v1/categories";

    IOClient client = new IOClient();

    try {
      Response response = await client.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<Category> categories = [];
        final responseDecode = json.decode(utf8.decode(response.bodyBytes));
        for (dynamic category in responseDecode)
          categories.add(Category.fromJson(category));
        return ApiResponse.completed(categories);
      }
      throw SocketException;
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

  Future<ApiResponse<List<Product>>> getProducts(String id) async {
    await Future.delayed(Duration(seconds: 1));
    return ApiResponse.completed([]);
  }
}
