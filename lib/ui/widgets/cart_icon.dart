import 'dart:async';

import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class CartIcon extends StatefulWidget {
  const CartIcon({Key key}) : super(key: key);

  @override
  _CartIconState createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  int count = 0;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    streamSubscription = productBloc.cartEntities.listen((event) {
      if (event.length <= 99)
        setState(() {
          count = event.length;
        });
      else if (count != 99)
        setState(() {
          count = 99;
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            AppIcons.cart,
            size: 28,
          ),
          count != 0
              ? IgnorePointer(
                  child: Align(
                    alignment: Alignment(1, -1),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Styles.backgroundColor,
                      ),
                      child: Container(
                          width: 18,
                          height: 18,
                          padding: EdgeInsets.only(
                            bottom: 2.0,
                          ),
                          decoration: ShapeDecoration(
                              shape: CircleBorder(), color: Styles.mainColor),
                          child: Center(
                            child: Text(
                              count.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "SegoeUIBold"),
                            ),
                          )),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
