import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/ui/screen_cart.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class CartIcon extends StatelessWidget {
  final GlobalKey cartKey;

  const CartIcon({Key key, this.cartKey}) : super(key: key);
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
                    key: cartKey,
                    padding: EdgeInsets.only(
                        top: 1.5, bottom: 3.0, left: 3.0, right: 3.0),
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      color: Colors.deepPurple,
                    ),
                    child: Text(
                      productBloc.cart == null
                          ? "0"
                          : productBloc.cart.length.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: "SegoeUIBold"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
