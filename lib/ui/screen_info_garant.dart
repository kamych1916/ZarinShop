import 'package:Zarin/utils/data.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GarantInfoScreen extends StatelessWidget {
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
              "Гарант качества",
              overflow: TextOverflow.fade,
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "SegoeUIBold",
                  fontSize: 18),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Text(
            Data.garantInfo,
            style: TextStyle(fontSize: 12),
          ),
        ));
  }
}
