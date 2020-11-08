import 'dart:async';
import 'dart:convert';

import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/cart_entity.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/resources/product_api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _productApiProvider = ProductApiProvider();

  final _categoriesSubject = BehaviorSubject<ApiResponse<List<Category>>>();

  final _cartEntitiesSubject = BehaviorSubject<List<CartEntity>>();
  final _cartProductsSubject = BehaviorSubject<ApiResponse<List<Product>>>();

  final _favoritesEntitiesSubject = BehaviorSubject<List<String>>();
  final _favoritesProductsSubject =
      BehaviorSubject<ApiResponse<List<Product>>>();

  final _productsSubject = BehaviorSubject<ApiResponse<List<Product>>>();

  final _cartTotalSubject = BehaviorSubject<double>()..sink.add(0);

  Stream<ApiResponse<List<Category>>> get categoriesStream =>
      _categoriesSubject.stream;
  Stream<List<CartEntity>> get cartEntitiesStream =>
      _cartEntitiesSubject.stream;
  Stream<ApiResponse<List<Product>>> get cartProductsStream =>
      _cartProductsSubject.stream;
  Stream<ApiResponse<List<Product>>> get favoritesProductsStream =>
      _favoritesProductsSubject.stream;
  Stream<List<String>> get favoritesEntitiesStream =>
      _favoritesEntitiesSubject.stream;
  Stream<ApiResponse<List<Product>>> get productsStream =>
      _productsSubject.stream;

  Stream<double> get cartTotalStream => _cartTotalSubject.stream;

  List<Category> get categories => _categoriesSubject.value?.data;
  List<CartEntity> get cartEntities => _cartEntitiesSubject.value;
  List<Product> get cartProducts => _cartProductsSubject.value?.data;
  List<Product> get favoritesProducts => _favoritesProductsSubject.value?.data;
  List<String> get favoritesEntities => _favoritesEntitiesSubject.value;
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
    print("Получение продуктов категории $id");
    _productsSubject.sink.add(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> products =
        await _productApiProvider.getProductsByCategoryId(id);

    if (products.status == Status.COMPLETED) {
      for (Product product in products.data) {
        try {
          await precacheImage(product.firstImage, context);
        } catch (ex) {
          print(ex);
        }
      }
    }

    _productsSubject.sink.add(products);
    sortProducts();
  }

  List<Product> productsSearch;

  searchInit() {
    productsSearch = products;
  }

  unSearch() {
    sortProducts(list: productsSearch);
  }

  search(String text) {
    List<Product> result = productsSearch
        .where((e) => e.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
    sortProducts(list: result);
  }

  final Map<SortType, String> sort = {
    SortType.NameAsc: "По алфавиту ↑",
    SortType.NameDesc: "По алфавиту ↓",
    SortType.PriceAsc: "По возрастанию цены",
    SortType.PriceDesc: "По уменьшению цены"
  };

  SortType currentSort = SortType.NameAsc;

  sortProducts({List<Product> list}) {
    List<Product> products = list ?? this.products;
    if (products == null || products.isEmpty) return;

    switch (currentSort) {
      case SortType.PriceAsc:
        products.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
        break;
      case SortType.PriceDesc:
        products.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
        break;
      case SortType.NameAsc:
        products.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.NameDesc:
        products.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    _productsSubject.sink.add(ApiResponse.completed(products));
  }

  /// Корзина

  getCartProducts() async {
    _cartProductsSubject.sink.add(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> cart = await _productApiProvider
        .getProductsByID(cartEntities.map((e) => e.id).toList());

    _cartProductsSubject.sink.add(cart);
  }

  getCartEntities() async {
    ApiResponse<List<CartEntity>> response =
        await _productApiProvider.getUserCart();

    if (response.status == Status.COMPLETED && response.data.isNotEmpty)
      _cartEntitiesSubject.sink.add(response.data);
    else
      _cartEntitiesSubject.sink.add([]);
  }

  getLocalCartEntities() {
    String cartEncode = appBloc.prefs.getString("cart");

    if (cartEncode != null && cartEncode.isNotEmpty) {
      List<CartEntity> cart = [];
      List<dynamic> cartEncode = json.decode(appBloc.prefs.getString("cart"));

      for (dynamic cartEntity in cartEncode)
        cart.add(CartEntity.fromJson(cartEntity));

      if (cart != null) {
        _cartEntitiesSubject.sink.add(cart);
        return;
      }
    }

    _cartEntitiesSubject.sink.add([]);
  }

  saveCartEntitiesToLocal() =>
      appBloc.prefs.setString("cart", json.encode(cartEntities));

  addProductToCart(Product product, count, sizeIndex) {
    CartEntity cartEntity =
        CartEntity(product.id, count, product.sizes[sizeIndex]);

    if (cartEntities != null) {
      if (!cartEntities.contains(cartEntity)) {
        cartEntities.add(cartEntity);
        _cartEntitiesSubject.sink.add(cartEntities);

        if (userBloc.auth) _productApiProvider.addProductToCart(cartEntity);
      } else {
        CartEntity cartEntityinCart =
            // ignore: unrelated_type_equality_checks
            cartEntities.firstWhere((element) => element == cartEntity);
        cartEntityinCart.count += count;

        if (userBloc.auth) {
          _productApiProvider.addProductToCart(cartEntity);
        }
      }

      if (!userBloc.auth) saveCartEntitiesToLocal();
    }
  }

  removeProductFromCart(CartEntity cartEntity) {
    if (cartEntities.contains(cartEntity)) {
      cartEntities.remove(cartEntity);
      _cartEntitiesSubject.sink.add(cartEntities);

      if (userBloc.auth)
        _productApiProvider.removeProductFromCart(cartEntity);
      else
        saveCartEntitiesToLocal();
    }
  }

  calculateCartTotal() async {
    if (cartEntities.isNotEmpty && cartProducts.isNotEmpty) {
      double total = 0;

      for (CartEntity cartEntity in cartEntities) {
        Product product =
            // ignore: unrelated_type_equality_checks
            cartProducts.firstWhere((element) => cartEntity == element);

        total += cartEntity.count * product.totalPrice;
      }

      _cartTotalSubject.sink.add(total);
    } else
      _cartTotalSubject.sink.add(0);
  }

  clearCart() {
    cartEntities.clear();
    _cartEntitiesSubject.sink.add(cartEntities);
  }

  /// Избранное

  getFavoritesProducts() async {
    _favoritesProductsSubject.sink.add(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> favorites =
        await _productApiProvider.getProductsByID(favoritesEntities);

    _favoritesProductsSubject.sink.add(favorites);
  }

  getFavoritesEntitiesFromLocal() {
    List<String> favorites = appBloc.prefs.getStringList("favorites");
    if (favorites != null) {
      _favoritesEntitiesSubject.sink.add(favorites);
    } else
      _favoritesEntitiesSubject.sink.add([]);
  }

  saveFavoritesEntitiesToLocal() =>
      appBloc.prefs.setStringList("favorites", favoritesEntities);

  addProductToFavorite(Product product) {
    if (favoritesEntities != null && !favoritesEntities.contains(product.id)) {
      favoritesEntities.add(product.id);
      _favoritesEntitiesSubject.sink.add(favoritesEntities);
      saveFavoritesEntitiesToLocal();
    }
  }

  removeProductFromFavorite(Product product) {
    if (favoritesEntities != null && favoritesEntities.contains(product.id)) {
      favoritesEntities.remove(product.id);
      _favoritesEntitiesSubject.sink.add(favoritesEntities);
      saveFavoritesEntitiesToLocal();
    }
  }

  void dispose() async {
    await _categoriesSubject.drain();
    _categoriesSubject.close();
    await _cartEntitiesSubject.drain();
    _cartEntitiesSubject.close();
    await _productsSubject.drain();
    _productsSubject.close();
    await _favoritesEntitiesSubject.drain();
    _favoritesEntitiesSubject.close();
    await _favoritesProductsSubject.drain();
    _favoritesProductsSubject.close();
    await _cartProductsSubject.drain();
    _cartProductsSubject.close();
    await _cartTotalSubject.drain();
    _cartTotalSubject.close();
  }
}

final ProductBloc productBloc = ProductBloc();

enum SortType { PriceAsc, PriceDesc, NameAsc, NameDesc }
