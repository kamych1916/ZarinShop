import 'dart:async';

import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/ui/screen_cart.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class CartIcon extends StatefulWidget {
  final GlobalKey cartKey;

  const CartIcon({Key key, this.cartKey}) : super(key: key);

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
    return GestureDetector(
        onTap: () => Navigator.of(context).push(FadePageRoute(
              builder: (context) => CartScreen(),
            )),
        child: Container(
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                AppIcons.cart,
                size: 22,
              ),
              Align(
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
                      key: widget.cartKey,
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
                              fontFamily: "SegoeUIBold"),
                        ),
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
