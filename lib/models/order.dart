import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class Order {
  String date;
  int itemsCount;
  int subtotal;
  String state;
  Color stateColor;
  Color state_paydColor;
  String state_payd;

  Order(this.date, this.itemsCount, this.subtotal, this.state, this.state_payd);

  Order.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    List<dynamic> items = json["items"];
    itemsCount = 0;
    for (Map item in items) {
      itemsCount += item["kol"];
    }
    subtotal = json["subtotal"];
    state = json["state"];
    state_payd = json["state_payd"];

    switch (state) {
      case "Awaiting":
        state = "В ожидании";
        stateColor = Styles.mainColor;
        break;
      case "Completed":
        state = "Завершен";
        stateColor = Colors.green;
        break;
      case "Canceled":
        state = "Отменен";
        stateColor = Colors.redAccent;
        break;
      default:
        state = "Неизвестен";
        stateColor = Colors.redAccent;
    }

    switch (state_payd) {
      case "Awaiting":
        state_payd = "В ожидании оплаты";
        state_paydColor = Styles.mainColor;
        break;
      case "Completed":
        state_payd = "Оплачен";
        state_paydColor = Colors.green;
        break;
      case "Canceled":
        state_payd = "Отменен";
        state_paydColor = Colors.redAccent;
        break;
      default:
        state_payd = "Неизвестен";
        state_paydColor = Colors.redAccent;
    }
  }
}
