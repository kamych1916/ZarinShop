class Category {
  String id;
  String name;
  List<Category> subcategories;

  Category(this.id, this.name, this.subcategories);

  Category.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];

    subcategories = new List();
    for (dynamic subcategory in json["subcategories"])
      subcategories.add(Category.fromJson(subcategory));
  }
}
