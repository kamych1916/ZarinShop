import 'package:Zarin/ui/widgets/cart_card.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.backgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
          ),
          title: Text(
            "Корзина",
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ),
      backgroundColor: Styles.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: CupertinoScrollbar(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) => CartCard(),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Styles.subBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Доставка",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("1000 Р",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Итого",
                      style: TextStyle(
                          color: Styles.cartFooterTotalTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("1000 Р",
                        style: TextStyle(
                            color: Styles.cartFooterTotalTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                    color: Styles.mainColor,
                    borderRadius: BorderRadius.circular(25)),
                child: Text(
                  "Оплатить",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
