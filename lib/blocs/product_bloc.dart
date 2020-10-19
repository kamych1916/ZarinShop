import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/resources/product_api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _productApiProvider = ProductApiProvider();
  final _categoriesSubject = BehaviorSubject<ApiResponse<List<Category>>>();
  final _cartSubject = BehaviorSubject<ApiResponse<List<Product>>>();
  final _productsSubject = BehaviorSubject<ApiResponse<List<Product>>>();

  Stream<ApiResponse<List<Category>>> get categoriesStream =>
      _categoriesSubject.stream;

  Stream<ApiResponse<List<Product>>> get cartStream => _cartSubject.stream;

  Stream<ApiResponse<List<Product>>> get productsStream =>
      _productsSubject.stream;

  List<Category> get categories => _categoriesSubject.value.data;
  List<Product> get cart => _cartSubject.value.data;
  List<Product> get products => _productsSubject.value.data;

  init(context) async {
    await getCategories(context);
  }

  getCategories(context) async {
    ApiResponse<List<Category>> categoriesResponse =
        await _productApiProvider.getCategories();

    if (categoriesResponse.status == Status.COMPLETED) {
      for (Category mainCategory in categoriesResponse.data) {
        await precacheImage(mainCategory.img, context);
      }
    }

    _categoriesSubject.sink.add(categoriesResponse);
  }

  getProducts(String id) async {
    _productsSubject.sink.add(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> products =
        await _productApiProvider.getProducts(id);

    _productsSubject.sink.add(products);
  }

  void dispose() async {
    await _categoriesSubject.drain();
    _categoriesSubject.close();
    await _cartSubject.drain();
    _cartSubject.close();
    await _productsSubject.drain();
    _productsSubject.close();
  }

  final Map<SortType, String> sort = {
    SortType.PriceAsc: "По уменьшению цены",
    SortType.PriceDesc: "По возрастанию цены"
  };

  SortType currentSort = SortType.PriceAsc;

  sortProducts() async {
    _productsSubject.sink.add(ApiResponse.loading("Сортировка товара"));

    await Future.delayed(Duration(seconds: 1));

    ApiResponse<List<Product>> products =
        await _productApiProvider.getProducts("1"); // лишнее

    _productsSubject.sink.add(products);
  }
}

final ProductBloc productBloc = ProductBloc();

enum SortType { PriceAsc, PriceDesc }
