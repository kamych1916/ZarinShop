import 'package:flutter/material.dart';

class Product {
  String id;
  String name;
  String description;
  //List<NetworkImage> images;
  NetworkImage image;
  double price;
  int discount;
  bool hitSale;
  bool specialOffer;

  int maxCount;

  Product(this.id);

  /// !!!: для Map исправить
  @override
  // ignore: hash_and_equals
  bool operator ==(covariant Product other) => other.id == id;

  //NetworkImage get firstImage => images[0];

  Product.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    price = json["price"];
    discount = json["discount"];
    hitSale = json["hit_sales"];
    specialOffer = json["special_offer"];

    maxCount = 5;

    if (json["image"] != null) {
      image = NetworkImage(json["image"]);
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "name": name,
        "description": description,
        "price": price,
      };
}
