import 'package:Zarin/utils/data.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveryInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.subBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.subBackgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.translucent,
            child: Container(
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
          ),
          title: Text(
            "Доставка",
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 18),
          ),
        ),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                Text(
                  Data.deliveryInfo,
                  style: TextStyle(fontSize: 12),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Самовывоз",
                    style: TextStyle(fontFamily: "SegoeUISemiBold"),
                  ),
                ),
                Text(
                  Data.deliveryTypeInfo[0],
                  style: TextStyle(fontSize: 12),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Курьер",
                    style: TextStyle(fontFamily: "SegoeUISemiBold"),
                  ),
                ),
                Text(
                  Data.deliveryTypeInfo[1],
                  style: TextStyle(fontSize: 12),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Почта",
                    style: TextStyle(fontFamily: "SegoeUISemiBold"),
                  ),
                ),
                Text(
                  Data.deliveryTypeInfo[2],
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
