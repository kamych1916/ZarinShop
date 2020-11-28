class Product {
  String id;
  String name;
  String description;
  String color;
  List<String> sizes;
  //List<Map<String, dynamic>> sizes;
  List<String> images;
  double price;
  int discount;
  double totalPrice;
  List<Map<String, dynamic>> linkColor;

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
    color = json["color"];

    maxCount = 5;

    if (json["size"] != null) {
      List<String> sizes = [];
      for (dynamic size in json["size"]) sizes.add(size);

      this.sizes = sizes;
    }

    // if (json["size"] != null) {
    //   List<Map<String, dynamic>> sizes = [];
    //   for (dynamic size in json["size"])
    //     sizes.add({"size": size["size"], "count": size["kol"]});
    //   this.sizes = sizes;
    // }

    if (json["image"] != null) {
      List<String> images = [];
      for (dynamic img in json["image"]) images.add(img);

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
