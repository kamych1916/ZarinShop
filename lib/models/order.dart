class Order {
  String date;
  int itemsCount;
  int subtotal;
  String state;

  Order(this.date, this.itemsCount, this.subtotal, this.state);

  Order.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    List<dynamic> items = json["items"];
    itemsCount = 0;
    for (Map item in items) {
      itemsCount += item["kol"];
    }
    subtotal = json["subtotal"];
    state = json["state"];
  }
}
