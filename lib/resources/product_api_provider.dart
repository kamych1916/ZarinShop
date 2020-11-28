import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/models/cart_entity.dart';
import 'package:Zarin/utils/check_internet_connection.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:requests/requests.dart' as package;

class ProductApiProvider {
  Future<ApiResponse<List<Category>>> getCategories() async {
    String url = "http://zarinshop.site:49354/api/v1/categories";

    IOClient client = new IOClient();
    await Future.delayed(Duration(seconds: 5));

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

  Future<ApiResponse<List<Product>>> getProductsByCategoryId(String id) async {
    String url = "http://zarinshop.site:49354/api/v1/items_cat/$id";

    IOClient client = new IOClient();

    await Future.delayed(Duration(seconds: 1));

    try {
      Response response = await client.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<Product> products = [];
        final responseDecode = json.decode(utf8.decode(response.bodyBytes));
        for (dynamic product in responseDecode)
          products.add(Product.fromJson(product));
        return ApiResponse.completed(products);
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

  Future<ApiResponse<List<Product>>> getProductsByID(List<String> ids) async {
    String url = "http://zarinshop.site:49354/api/v1/items_ind";

    IOClient client = new IOClient();
    String body = ids.toString();

    try {
      Response response =
          await client.post(url, body: body).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<Product> products = [];
        final responseDecode = json.decode(utf8.decode(response.bodyBytes));
        for (dynamic product in responseDecode)
          products.add(Product.fromJson(product));
        return ApiResponse.completed(products);
      }
      throw SocketException;
    } catch (exception) {
      print(exception);
      bool internetStatus = await checkInternetConnection();

      return internetStatus
          ? exception.runtimeType == SocketException ||
                  exception.runtimeType == TimeoutException
              ? ApiResponse.error('Сервис недоступен')
              : ApiResponse.error('Возникла внутренняя ошибка')
          : ApiResponse.error('Отсутствует интернет-соединение');
    }
  }

  Future<ApiResponse<List<CartEntity>>> getUserCart() async {
    String url = "http://zarinshop.site:49354/api/v1/cart/shopping_cart";

    try {
      var response = await package.Requests.get(url, timeoutSeconds: 10);

      if (response.statusCode == 200) {
        List<CartEntity> products = [];
        final responseDecode = json.decode(utf8.decode(response.bytes()));
        for (dynamic product in responseDecode["items"])
          products.add(CartEntity.fromJson(product));
        return ApiResponse.completed(products);
      }

      response.raiseForStatus();
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

  addProductToCart(CartEntity cartEntity) async {
    String url = "http://zarinshop.site:49354/api/v1/cart/addProduct";

    String productID = cartEntity.id;
    String size = cartEntity.size;
    int count = cartEntity.count;
    String body = '{"id": "$productID", "size": "$size", "kol": $count}';

    await package.Requests.post(url,
        body: body,
        timeoutSeconds: 10,
        bodyEncoding: package.RequestBodyEncoding.PlainText);
  }

  removeProductFromCart(CartEntity cartEntity) async {
    String url = "http://zarinshop.site:49354/api/v1/cart/delproduct";

    String productID = cartEntity.id;
    String productSize = cartEntity.size;
    String body = '{"id": "$productID", "size": "$productSize"}';

    await package.Requests.delete(url,
        body: body,
        timeoutSeconds: 10,
        bodyEncoding: package.RequestBodyEncoding.PlainText);
  }

  Future<ApiResponse<List<Product>>> search(String search) async {
    String url = "http://zarinshop.site:49354/api/v1/search";

    IOClient client = new IOClient();
    String parameters = "?poisk=$search";

    try {
      Response response =
          await client.get(url + parameters).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<Product> products = [];
        final responseDecode = json.decode(utf8.decode(response.bodyBytes));
        for (dynamic product in responseDecode)
          products.add(Product.fromJson(product));
        return ApiResponse.completed(products);
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
}
