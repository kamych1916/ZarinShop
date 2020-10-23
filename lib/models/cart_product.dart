import 'package:Zarin/models/product.dart';

class CartProduct {
  String id;
  int count;

  CartProduct(this.id, this.count);

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant dynamic other) => other.id == id;

  CartProduct.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    count = json["count"];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{"id": id, "count": count};
}
