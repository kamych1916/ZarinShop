class Product {
  String id;
  String name;
  String description;
  String color;
  List<Map<String, dynamic>> sizes;
  bool productWithOutSize = false;
  List<String> images;
  double price;
  int discount;
  double totalPrice;
  List<Map<String, dynamic>> linkColor;

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
    description = description.replaceAll("<br/>", "\n");
    price = json["price"];
    discount = json["discount"];
    color = json["color"];

    if (json["size_kol"] != null) {
      List<Map<String, dynamic>> sizes = [];
      for (dynamic size in json["size_kol"])
        sizes.add({"size": size["size"], "kol": size["kol"]});
      this.sizes = sizes;

      if (sizes[0]["size"] == "Нет размера") productWithOutSize = true;
    }

    if (json["images"] != null) {
      List<String> images = [];
      for (dynamic img in json["images"]) images.add(img);

      this.images = images;
    }

    if (json["link_color"] != null) {
      List<Map<String, dynamic>> linkColor = [];
      for (dynamic link in json["link_color"]) linkColor.add(link);

      this.linkColor = linkColor;
    }

    totalPrice = (price - price * (discount / 100));
  }
}
