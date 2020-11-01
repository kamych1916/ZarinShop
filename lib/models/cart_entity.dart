class CartEntity {
  String id;
  String size;
  int count;

  CartEntity(this.id, this.count, this.size);

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant dynamic other) => other is CartEntity
      ? other.id == id && other.size == size
      : other.id == id;

  CartEntity.fromJson(Map<String, dynamic> json) {
    id = json["id"].toString();
    count = json["kol"];
    size = json["size"];
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{"id": id, "kol": count, "size": size};
}
