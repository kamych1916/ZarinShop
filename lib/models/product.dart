import 'package:flutter/material.dart';

class Product {
  String id;
  String name;
  String description;
  String color;
  List<String> sizes;
  List<NetworkImage> images;
  double price;
  int discount;
  double totalPrice;
  bool hitSale;
  bool specialOffer;

  int maxCount;

  Product(this.id);

  /// !!!: для Map исправить
  @override
  // ignore: hash_and_equals
  bool operator ==(covariant Product other) => other.id == id;

  NetworkImage get firstImage => images[0] ?? "";

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
      List<NetworkImage> images = [];
      for (dynamic img in json["image"]) images.add(NetworkImage(img));

      this.images = images;
    }

    totalPrice = (price - price * (discount / 100));
  }

  precacheImages(BuildContext context) async {
    for (NetworkImage img in images) {
      await precacheImage(img, context);
    }
  }
}
