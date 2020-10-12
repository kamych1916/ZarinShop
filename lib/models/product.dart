class Product {
  String id;
  String name;
  String description;
  String price;

  Product(this.id, this.name, this.description, this.price);

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
