import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
      width: double.infinity,
      height: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: Styles.cardShadows,
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0)),
      child: Row(
        children: [
          Container(
            width: 75,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(20.0)),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Халат Зарин",
                    style: TextStyle(
                        color: Styles.cartCardTitleTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text("Цвет", style: TextStyle(fontSize: 13.0)),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0)),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: ShapeDecoration(
                              color: Colors.blue,
                              shape: CircleBorder(),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                      Row(
                        children: [
                          Text(
                            "Размер",
                            style: TextStyle(fontSize: 13.0),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0)),
                          Text(
                            "М",
                            style: TextStyle(
                                color: Styles.cardTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("1"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text("x"),
                      ),
                      Text("1000 Р",
                          style: TextStyle(
                              color: Styles.cardTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Styles.mainColor, width: 2)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Text(
                    "+",
                    style: TextStyle(color: Styles.mainColor, fontSize: 20),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Text("-",
                      style: TextStyle(color: Styles.mainColor, fontSize: 25)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
