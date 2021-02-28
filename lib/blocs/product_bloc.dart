import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/cart_entity.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/event.dart';
import 'package:Zarin/models/filter.dart';
import 'package:Zarin/models/order.dart';
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
    userBloc.auth.listen((event) {
      if (event) productBloc.getCartEntities();
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

  Filter filter = Filter();

  final Event<ApiResponse<List<Category>>> categories = Event();
  final Event<ApiResponse<List<Product>>> products = Event();
  final Event<ApiResponse<List<Product>>> productsSales = Event();
  final Event<ApiResponse<List<Product>>> productsOffers = Event();

  final Event<ApiResponse<List<Product>>> cartProducts = Event();
  final Event<ApiResponse<List<Product>>> favoritesProducts = Event();

  final Event<List<CartEntity>> cartEntities = Event();
  final Event<List<String>> favoritesEntities = Event();

  final Event<ApiResponse<List<Order>>> orders = Event();

  final Event<double> cartTotalPrice = Event();

  final Event<bool> searchEvent = Event(initValue: false);

  ScrollController productsListScrollController = ScrollController();
  FocusNode searchFieldFocusNode = FocusNode();

  /// Категории

  getCategories() async {
    categories.publish(ApiResponse.loading("Загрузка категорий"));

    ApiResponse<List<Category>> categoriesResponse =
        await _productApiProvider.getCategories();

    categories.publish(categoriesResponse);
  }

  /// Товары

  void getHomeProducts() async {
    productsSales.publish(ApiResponse.loading("Загрузка товара"));
    productsOffers.publish(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> productsSalesResponse =
        await _productApiProvider.getProductsSales();

    ApiResponse<List<Product>> productsOffersResponse =
        await _productApiProvider.getProductsOffers();

    productsSales.publish(productsSalesResponse);
    productsOffers.publish(productsOffersResponse);
  }

  Future getProductsByCategoryId(String id, context) async {
    print(id);
    filter = Filter();
    products.publish(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> productsResponse =
        await _productApiProvider.getProductsByCategoryId(id);

    if (productsResponse.status != Status.COMPLETED)
      products.publish(productsResponse);
    else {
      if (productsResponse.data.isEmpty)
        products.publish(productsResponse);
      else
        sortProducts(list: productsResponse.data);
    }

    if (productsResponse.status == Status.COMPLETED &&
        productsResponse.data.isNotEmpty) {
      minFilterPrice = getProductsMinPrice();
      maxFilterPrice = getProductsMaxPrice();
    }
  }

  double getProductsMaxPrice() =>
      products.value.data.map((e) => e.totalPrice).reduce(max);
  double getProductsMinPrice() =>
      products.value.data.map((e) => e.totalPrice).reduce(min);

  sortProducts({List<Product> list}) {
    if (products.value == null) return;
    List<Product> sortProducts = list ?? products.value.data;
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

  search(String search) async {
    products.publish(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> searchReslut =
        await _productApiProvider.search(search);

    if (searchReslut.status != Status.COMPLETED)
      products.publish(searchReslut);
    else {
      if (searchReslut.data.isEmpty)
        products.publish(searchReslut);
      else
        sortProducts(list: searchReslut.data);
    }

    if (searchReslut.status == Status.COMPLETED &&
        searchReslut.data.isNotEmpty) {
      minFilterPrice = getProductsMinPrice();
      maxFilterPrice = getProductsMaxPrice();
    }
  }

  List<Product> filterProductsTemp = [];
  double minFilterPrice;
  double maxFilterPrice;

  filterProducts() {
    if (products.value.data == null) return;
    filterProductsTemp = filterProductsTemp.isNotEmpty
        ? filterProductsTemp
        : products.value.data;

    List<Product> filterProducts = [];

    for (Product product in filterProductsTemp) {
      if (filter.check(product)) filterProducts.add(product);
    }

    if (filterProducts.isEmpty) products.publish(ApiResponse.completed([]));

    sortProducts(list: filterProducts);
  }

  cancelFilter() {
    sortProducts(list: filterProductsTemp);
    filterProductsTemp = [];
  }

  /// Корзина

  getCartProducts() async {
    cartProducts.publish(ApiResponse.loading("Загрузка товара"));

    ApiResponse<List<Product>> cart = await _productApiProvider
        .getProductsByID(cartEntities.value.map((e) => e.id).toList());

    cartProducts.publish(cart);
  }

  Future getCartEntities() async {
    ApiResponse<List<CartEntity>> response =
        await _productApiProvider.getUserCart();

    if (response.status == Status.COMPLETED && response.data.isNotEmpty)
      cartEntities.publish(response.data);
    else
      cartEntities.publish([]);
  }

  addProductToCart(Product product, count, sizeIndex) async {
    appBloc.apiResponse.publish(true);

    CartEntity cartEntity = CartEntity(product.id, count,
        product.sizes == null ? null : product.sizes[sizeIndex]["size"]);

    if (cartEntities != null) {
      if (!cartEntities.value.contains(cartEntity)) {
        cartEntities.value.add(cartEntity);
        cartEntities.publish(cartEntities.value);

        await _productApiProvider.addProductToCart(cartEntity);
      } else {
        CartEntity cartEntityinCart =
            // ignore: unrelated_type_equality_checks
            cartEntities.value.firstWhere((element) => element == cartEntity);
        cartEntityinCart.count += count;

        if (cartEntityinCart.count > product.sizes[sizeIndex]["kol"])
          cartEntityinCart.count = product.sizes[sizeIndex]["kol"];

        await _productApiProvider.addProductToCart(cartEntity);
        cartEntities.publish(cartEntities.value);
      }
    }

    appBloc.apiResponse.publish(false);
  }

  removeProductFromCart(CartEntity cartEntity) {
    if (cartEntities.value.contains(cartEntity)) {
      cartEntities.value.remove(cartEntity);
      cartEntities.publish(cartEntities.value);

      _productApiProvider.removeProductFromCart(cartEntity);
    }
  }

  calculateCartTotal() async {
    if (cartEntities.value.isNotEmpty &&
        cartProducts.value.status == Status.COMPLETED) {
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

    await searchEvent.dispose();
  }

  Future<String> pay(
      String deliveryType, String whichBank, int currentAddress) async {
    Map<String, dynamic> userInfo = {
      "firstName": userBloc.firstName,
      "lastName": userBloc.lastName,
      "phone": userBloc.phone,
      "email": userBloc.email.value,
    };

    Map<String, dynamic> addressInfo;

    if (currentAddress >= 0) {
      addressInfo = {
        "address": appBloc.addresses.value[currentAddress].street +
            " " +
            appBloc.addresses.value[currentAddress].apartmentNumber +
            " " +
            appBloc.addresses.value[currentAddress].houseNumber,
        "city": appBloc.addresses.value[currentAddress].city,
        "state": appBloc.addresses.value[currentAddress].state,
        "pincode": appBloc.addresses.value[currentAddress].code
      };
    } else {
      addressInfo = {"address": "", "city": "", "state": "", "pincode": ""};
    }

    userInfo = {}..addAll(userInfo)..addAll(addressInfo);

    List<Map> items = [];

    for (CartEntity cartEntity in cartEntities.value) {
      Product product = cartProducts.value.data
          // ignore: unrelated_type_equality_checks
          .firstWhere((element) => cartEntity == element);

      items.add({
        "id": int.tryParse(cartEntity.id),
        "name": product.name,
        "size": cartEntity.size,
        "kol": cartEntity.count,
        "images": product.images,
        "color": product.color,
        "price": product.price.floor(),
        "discount": product.discount,
        "stock": product.sizes
            .firstWhere((element) => element["size"] == cartEntity.size)["kol"]
      });
    }

    Map<String, dynamic> body = {
      "which_bank": whichBank.toLowerCase(),
      "shipping_type": deliveryType == "Самовывоз" ? "pickup" : "delivery",
      "subtotal": 1800, //cartTotalPrice.value.floor(),
      "list_items": items,
      "client_info": userInfo,
      "shipping_adress": deliveryType == "Самовывоз"
          ? ""
          : appBloc.addresses.value[currentAddress].code +
              " " +
              appBloc.addresses.value[currentAddress].state +
              " " +
              appBloc.addresses.value[currentAddress].city +
              " " +
              appBloc.addresses.value[currentAddress].street +
              " " +
              appBloc.addresses.value[currentAddress].apartmentNumber +
              " " +
              appBloc.addresses.value[currentAddress].houseNumber,
    };

    return await _productApiProvider.pay(body);
  }

  getUserOrders() async {
    orders.publish(ApiResponse.loading("Загрузка категорий"));

    ApiResponse<List<Order>> ordersResponse =
        await _productApiProvider.getUserOrders();

    orders.publish(ordersResponse);
  }
}

final ProductBloc productBloc = ProductBloc();

enum SortType { PriceAsc, PriceDesc, NameAsc, NameDesc }
