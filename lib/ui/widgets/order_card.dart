import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:Zarin/models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard(this.order, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String state;
    Color stateColor;

    switch (order.state) {
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

    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Дата заказа: " + order.date,
            style: TextStyle(
              fontFamily: "SegoeUISemiBold",
            ),
          ),
          Divider(),
          Text("Количетво вещей в заказе: " + order.itemsCount.toString()),
          Text("Сумма заказа: " + order.subtotal.toString() + " сум"),
          Divider(),
          Row(
            children: [
              Text(
                "Статус: ",
                style: TextStyle(
                  fontFamily: "SegoeUISemiBold",
                ),
              ),
              Text(
                state,
                style:
                    TextStyle(fontFamily: "SegoeUISemiBold", color: stateColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
