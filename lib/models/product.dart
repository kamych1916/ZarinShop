class Product {
  String id;
  String name;
  String description;
  String image; // TODO: implement
  double price;

  Product(this.id, this.name, this.description, this.price);

  /// !!!: для Map исправить
  @override
  // ignore: hash_and_equals
  bool operator ==(covariant Product other) => other.id == id;

  Product.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    price = json["price"];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "name": name,
        "description": description,
        "price": price,
      };
}
