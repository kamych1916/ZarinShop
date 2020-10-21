import 'dart:async';

import 'package:Zarin/blocs/app_bloc.dart';
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
  final _favoritesSubject = BehaviorSubject<List<String>>();
  final _productsSubject = BehaviorSubject<ApiResponse<List<Product>>>();

  Stream<ApiResponse<List<Category>>> get categoriesStream =>
      _categoriesSubject.stream;

  Stream<ApiResponse<List<Product>>> get cartStream => _cartSubject.stream;

  Stream<List<String>> get favoritesStream => _favoritesSubject.stream;

  Stream<ApiResponse<List<Product>>> get productsStream =>
      _productsSubject.stream;

  List<Category> get categories => _categoriesSubject.value?.data;
  List<Product> get cart => _cartSubject.value?.data;
  List<String> get favorites => _favoritesSubject.value;
  List<Product> get products => _productsSubject.value?.data;

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
    await _favoritesSubject.drain();
    _favoritesSubject.close();
  }

  final Map<SortType, String> sort = {
    SortType.NameAsc: "По алфавиту ↓",
    SortType.NameDesc: "По алфавиту ↑",
    SortType.PriceAsc: "По возрастанию цены",
    SortType.PriceDesc: "По уменьшению цены"
  };

  SortType currentSort = SortType.PriceAsc;

  sortProducts() {
    List<Product> products = this.products;
    _productsSubject.sink.add(ApiResponse.loading("Сортировка товара"));

    switch (currentSort) {
      case SortType.PriceAsc:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.PriceDesc:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.NameAsc:
        break;
      case SortType.NameDesc:
        // TODO: Handle this case.
        break;
    }

    _productsSubject.sink.add(ApiResponse.completed(products));
  }

  getCart() {
    ///Делаю гет на сервер за корзиной
  }

  getLocalCart() {
    // List<String> favorites = prefs.getStringList("favorites");
    // if (favorites != null) {
    //   _favoritesSubject.sink.add(favorites);
    // } else
    //   _favoritesSubject.sink.add([]);
  }

  getFavorites() {
    List<String> favorites = appBloc.prefs.getStringList("favorites");
    if (favorites != null) {
      _favoritesSubject.sink.add(favorites);
    } else
      _favoritesSubject.sink.add([]);
  }

  saveFavorites() => appBloc.prefs.setStringList("favorites", favorites);

  addProductToFavorite(Product product) {
    if (favorites != null && !favorites.contains(product.id)) {
      favorites.add(product.id);
      _favoritesSubject.sink.add(favorites);
      saveFavorites();
    }
  }

  removeProductFromFavorite(Product product) {
    if (favorites != null && favorites.contains(product.id)) {
      favorites.remove(product.id);
      _favoritesSubject.sink.add(favorites);
      saveFavorites();
    }
  }
}

final ProductBloc productBloc = ProductBloc();

enum SortType { PriceAsc, PriceDesc, NameAsc, NameDesc }
