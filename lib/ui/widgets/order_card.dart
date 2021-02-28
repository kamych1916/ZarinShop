import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:Zarin/models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard(this.order, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Дата заказа",
                style: TextStyle(
                  fontFamily: "SegoeUISemiBold",
                ),
              ),
              Text(
                order.date,
                style: TextStyle(
                  fontFamily: "SegoeUISemiBold",
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Количетво вещей в заказе"),
              Text(order.itemsCount.toString())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Сумма заказа"),
              Text(order.subtotal.toString() + " сум")
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Статус оплаты ",
                style: TextStyle(
                  fontFamily: "SegoeUISemiBold",
                ),
              ),
              Text(
                order.state,
                style: TextStyle(
                    fontFamily: "SegoeUISemiBold", color: order.stateColor),
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Статус заказа ",
                style: TextStyle(
                  fontFamily: "SegoeUISemiBold",
                ),
              ),
              Text(
                order.state,
                style: TextStyle(
                    fontFamily: "SegoeUISemiBold", color: order.stateColor),
              )
            ],
          ),
        ],
      ),
    );
  }
}
