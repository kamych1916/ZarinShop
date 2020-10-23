import 'dart:async';
import 'dart:convert';

import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/cart_product.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/resources/product_api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _productApiProvider = ProductApiProvider();
  final _categoriesSubject = BehaviorSubject<ApiResponse<List<Category>>>();
  final _cartProductsSubject = BehaviorSubject<List<CartProduct>>();
  final _cartSubject = BehaviorSubject<ApiResponse<List<Product>>>();
  final _favoritesIDSubject = BehaviorSubject<List<String>>();
  final _favoritesSubject = BehaviorSubject<ApiResponse<List<Product>>>();
  final _productsSubject = BehaviorSubject<ApiResponse<List<Product>>>();

  final _cartTotalSubject = BehaviorSubject<double>()..sink.add(0);

  Stream<ApiResponse<List<Category>>> get categoriesStream =>
      _categoriesSubject.stream;
  Stream<List<CartProduct>> get cartProductsStream =>
      _cartProductsSubject.stream;
  Stream<ApiResponse<List<Product>>> get cartStream => _cartSubject.stream
    ..listen((event) {
      if (event.status == Status.COMPLETED && event.data.isNotEmpty) {
        double total = 0;

        for (Product product in event.data) {
          CartProduct cartProduct =
              // ignore: unrelated_type_equality_checks
              cartProducts.firstWhere((element) => element == product);

          total += cartProduct.count * product.price;
        }

        _cartTotalSubject.sink.add(total);
      } else
        _cartTotalSubject.sink.add(0);
    });
  Stream<ApiResponse<List<Product>>> get favoritesStream =>
      _favoritesSubject.stream;
  Stream<List<String>> get favoritesIDStream => _favoritesIDSubject.stream;
  Stream<ApiResponse<List<Product>>> get productsStream =>
      _productsSubject.stream;

  Stream<double> get cartTotalStream => _cartTotalSubject.stream;

  List<Category> get categories => _categoriesSubject.value?.data;
  List<CartProduct> get cartProducts => _cartProductsSubject.value;
  List<Product> get cart => _cartSubject.value?.data;
  List<Product> get favorites => _favoritesSubject.value?.data;
  List<String> get favoritesID => _favoritesIDSubject.value;
  List<Product> get products => _productsSubject.value?.data;

  double get cartTotal => _cartTotalSubject.value;

  /// Категории

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

  /// Товары

  getProductsByCategoryId(String id, context) async {
    _productsSubject.sink.add(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> products =
        await _productApiProvider.getProductsByCategoryId(id);

    if (products.status == Status.COMPLETED) {
      for (Product product in products.data) {
        await precacheImage(product.image, context);
      }
    }

    _productsSubject.sink.add(products);
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

  /// Корзина

  getCart() async {
    _cartSubject.sink.add(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> cart = await _productApiProvider
        .getProductsByID(cartProducts.map((e) => e.id).toList());

    _cartSubject.sink.add(cart);
  }

  getLocalCartID() {
    String cartEncode = appBloc.prefs.getString("cart");

    if (cartEncode != null && cartEncode.isNotEmpty) {
      List<CartProduct> cart = [];
      List<dynamic> cartEncode = json.decode(appBloc.prefs.getString("cart"));

      for (dynamic cartEntity in cartEncode)
        cart.add(CartProduct.fromJson(cartEntity));

      if (cart != null) _cartProductsSubject.sink.add(cart);

      return;
    }

    _cartProductsSubject.sink.add([]);
  }

  saveCartToLocal() =>
      appBloc.prefs.setString("cart", json.encode(cartProducts));

  getUserCartID() {}

  addProductToCart(Product product, count) {
    if (cartProducts != null) {
      if (!cartProducts.contains(product)) {
        CartProduct cartProduct = CartProduct(product.id, count);

        cartProducts.add(cartProduct);
        _cartProductsSubject.sink.add(cartProducts);
      } else {
        CartProduct cartProduct =
            // ignore: unrelated_type_equality_checks
            cartProducts.firstWhere((element) => element == product);
        cartProduct.count += count;
      }

      saveCartToLocal();
    }
  }

  removeProductFromCart(Product product) {
    if (cartProducts != null && cartProducts.contains(product)) {
      cart.remove(product);
      _cartSubject.sink.add(ApiResponse.completed(cart));

      CartProduct cartProduct =
          // ignore: unrelated_type_equality_checks
          cartProducts.firstWhere((element) => element == product);
      cartProducts.remove(cartProduct);
      _cartProductsSubject.sink.add(cartProducts);
      saveCartToLocal();
    }
  }

  /// Избранное

  getFavorites() async {
    _favoritesSubject.sink.add(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> favorites =
        await _productApiProvider.getProductsByID(favoritesID);

    _favoritesSubject.sink.add(favorites);
  }

  getFavoritesIDFromLocal() {
    List<String> favorites = appBloc.prefs.getStringList("favorites");
    if (favorites != null) {
      _favoritesIDSubject.sink.add(favorites);
    } else
      _favoritesIDSubject.sink.add([]);
  }

  saveFavoritesToLocal() =>
      appBloc.prefs.setStringList("favorites", favoritesID);

  addProductToFavorite(Product product) {
    if (favoritesID != null && !favoritesID.contains(product.id)) {
      favoritesID.add(product.id);
      _favoritesIDSubject.sink.add(favoritesID);
      saveFavoritesToLocal();
    }
  }

  removeProductFromFavorite(Product product) {
    if (favoritesID != null && favoritesID.contains(product.id)) {
      favoritesID.remove(product.id);
      _favoritesIDSubject.sink.add(favoritesID);
      saveFavoritesToLocal();
    }
  }

  void dispose() async {
    await _categoriesSubject.drain();
    _categoriesSubject.close();
    await _cartSubject.drain();
    _cartSubject.close();
    await _productsSubject.drain();
    _productsSubject.close();
    await _favoritesIDSubject.drain();
    _favoritesIDSubject.close();
    await _favoritesSubject.drain();
    _favoritesSubject.close();
    await _cartProductsSubject.drain();
    _cartProductsSubject.close();
    await _cartTotalSubject.drain();
    _cartTotalSubject.close();
  }
}

final ProductBloc productBloc = ProductBloc();

enum SortType { PriceAsc, PriceDesc, NameAsc, NameDesc }
