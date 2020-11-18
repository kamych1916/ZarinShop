class Category {
  String id;
  String name;
  String imgUrl;
  int count;
  List<Category> subcategories;

  Category(this.id, this.name, this.subcategories);

  Category.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    if (json["image_url"] != null) {
      imgUrl = json["image_url"];
    }
    count = json["kol"];

    subcategories = new List();
    for (dynamic subcategory in json["subcategories"])
      subcategories.add(Category.fromJson(subcategory));
  }
}
