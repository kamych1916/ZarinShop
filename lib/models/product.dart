import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  String description;
  String color;
  List<String> sizes;
  List<String> images;
  double price;
  int discount;
  double totalPrice;
  bool hitSale;
  bool specialOffer;

  int maxCount;

  Product(this.id);

  String get firstImage => images[0];

  /// !!!: для Map исправить
  @override
  // ignore: hash_and_equals
  bool operator ==(covariant Product other) => other.id == id;

  Product.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    price = json["price"];
    discount = json["discount"];
    hitSale = json["hit_sales"];
    specialOffer = json["special_offer"];
    color = json["color"];

    maxCount = 5;

    if (json["size"] != null) {
      List<String> sizes = [];
      for (dynamic size in json["size"]) sizes.add(size);

      this.sizes = sizes;
    }

    if (json["image"] != null) {
      List<String> images = [];
      for (dynamic img in json["image"]) images.add(img);

      this.images = images;
    }

    totalPrice = (price - price * (discount / 100));
  }
}
