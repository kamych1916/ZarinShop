import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/cart_entity.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/event.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/resources/product_api_provider.dart';
import 'package:flutter/cupertino.dart';

class ProductBloc {
  ProductBloc() {
    cartProducts.listen((event) => calculateCartTotal());
    favoritesEntities.listen((event) {
      getFavoritesProducts();
      saveFavoritesEntitiesToLocal();
    });
  }

  final _productApiProvider = ProductApiProvider();

  SortType currentSort = SortType.NameAsc;

  final Map<SortType, String> sortNames = {
    SortType.NameAsc: "По алфавиту ↑",
    SortType.NameDesc: "По алфавиту ↓",
    SortType.PriceAsc: "По возрастанию цены",
    SortType.PriceDesc: "По уменьшению цены"
  };

  final Event<ApiResponse<List<Category>>> categories = Event();
  final Event<ApiResponse<List<Product>>> products = Event();
  final Event<ApiResponse<List<Product>>> cartProducts = Event();
  final Event<ApiResponse<List<Product>>> favoritesProducts = Event();

  final Event<List<CartEntity>> cartEntities = Event();
  final Event<List<String>> favoritesEntities = Event();

  final Event<double> cartTotalPrice = Event();

  /// Категории

  getCategories(context) async {
    ApiResponse<List<Category>> categoriesResponse =
        await _productApiProvider.getCategories();

    if (categoriesResponse.status == Status.COMPLETED) {
      for (Category mainCategory in categoriesResponse.data) {
        await precacheImage(NetworkImage(mainCategory.imgUrl), context);
      }
    }

    categories.publish(categoriesResponse);
  }

  /// Товары

  Future getProductsByCategoryId(String id, context) async {
    products.publish(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> productsResponse =
        await _productApiProvider.getProductsByCategoryId(id);

    products.publish(productsResponse);
    sortProducts();
  }

  double getProductsMaxPrice() =>
      products.value.data.map((e) => e.totalPrice).reduce(max);
  double getProductsMinPrice() =>
      products.value.data.map((e) => e.totalPrice).reduce(min);

  sortProducts() {
    List<Product> sortProducts = products.value.data;
    if (sortProducts == null || sortProducts.isEmpty) return;

    switch (currentSort) {
      case SortType.PriceAsc:
        sortProducts.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
        break;
      case SortType.PriceDesc:
        sortProducts.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
        break;
      case SortType.NameAsc:
        sortProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.NameDesc:
        sortProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    products.publish(ApiResponse.completed(sortProducts));
  }

  /// Корзина

  getCartProducts() async {
    cartProducts.publish(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> cart = await _productApiProvider
        .getProductsByID(cartEntities.value.map((e) => e.id).toList());

    cartProducts.publish(cart);
  }

  getCartEntities() async {
    ApiResponse<List<CartEntity>> response =
        await _productApiProvider.getUserCart();

    if (response.status == Status.COMPLETED && response.data.isNotEmpty)
      cartEntities.publish(response.data);
    else
      cartEntities.publish([]);
  }

  getLocalCartEntities() {
    String cartEncode = appBloc.prefs.getString("cart");

    if (cartEncode != null && cartEncode.isNotEmpty) {
      List<CartEntity> cart = [];
      List<dynamic> cartEncode = json.decode(appBloc.prefs.getString("cart"));

      for (dynamic cartEntity in cartEncode)
        cart.add(CartEntity.fromJson(cartEntity));

      if (cart != null) {
        cartEntities.publish(cart);
        return;
      }
    }

    cartEntities.publish([]);
  }

  saveCartEntitiesToLocal() =>
      appBloc.prefs.setString("cart", json.encode(cartEntities));

  addProductToCart(Product product, count, sizeIndex) {
    CartEntity cartEntity =
        CartEntity(product.id, count, product.sizes[sizeIndex]);

    if (cartEntities != null) {
      if (!cartEntities.value.contains(cartEntity)) {
        cartEntities.value.add(cartEntity);
        cartEntities.publish(cartEntities.value);

        if (userBloc.auth.value)
          _productApiProvider.addProductToCart(cartEntity);
      } else {
        CartEntity cartEntityinCart =
            // ignore: unrelated_type_equality_checks
            cartEntities.value.firstWhere((element) => element == cartEntity);
        cartEntityinCart.count += count;

        if (userBloc.auth.value) {
          _productApiProvider.addProductToCart(cartEntity);
        }
      }

      if (!userBloc.auth.value) saveCartEntitiesToLocal();
    }
  }

  removeProductFromCart(CartEntity cartEntity) {
    if (cartEntities.value.contains(cartEntity)) {
      cartEntities.value.remove(cartEntity);
      cartEntities.publish(cartEntities.value);

      if (userBloc.auth.value)
        _productApiProvider.removeProductFromCart(cartEntity);
      else
        saveCartEntitiesToLocal();
    }
  }

  calculateCartTotal() async {
    if (cartEntities.value.isNotEmpty && cartProducts.value.data.isNotEmpty) {
      double total = 0;

      for (CartEntity cartEntity in cartEntities.value) {
        Product product = cartProducts.value.data
            // ignore: unrelated_type_equality_checks
            .firstWhere((element) => cartEntity == element);

        total += cartEntity.count * product.totalPrice;
      }

      cartTotalPrice.publish(total);
    } else
      cartTotalPrice.publish(0);
  }

  clearCart() {
    cartEntities.value.clear();
    cartEntities.publish(cartEntities.value);
  }

  /// Избранное

  getFavoritesProducts() async {
    ApiResponse<List<Product>> favorites =
        await _productApiProvider.getProductsByID(favoritesEntities.value);

    favoritesProducts.publish(favorites);
  }

  getFavoritesEntitiesFromLocal() {
    List<String> favorites = appBloc.prefs.getStringList("favorites");
    if (favorites != null)
      favoritesEntities.publish(favorites);
    else
      favoritesEntities.publish([]);
  }

  saveFavoritesEntitiesToLocal() =>
      appBloc.prefs.setStringList("favorites", favoritesEntities.value);

  addProductToFavorite(Product product) async {
    if (favoritesEntities != null &&
        !favoritesEntities.value.contains(product.id)) {
      favoritesEntities.value.add(product.id);
      favoritesEntities.publish(favoritesEntities.value);
    }
  }

  removeProductFromFavorite(Product product) async {
    if (favoritesEntities != null &&
        favoritesEntities.value.contains(product.id)) {
      favoritesEntities.value.remove(product.id);
      favoritesEntities.publish(favoritesEntities.value);
    }
  }

  void dispose() async {
    await categories.dispose();
    await products.dispose();
    await cartProducts.dispose();
    await favoritesProducts.dispose();

    await cartEntities.dispose();
    await favoritesEntities.dispose();

    await cartTotalPrice.dispose();
  }
}

final ProductBloc productBloc = ProductBloc();

enum SortType { PriceAsc, PriceDesc, NameAsc, NameDesc }
