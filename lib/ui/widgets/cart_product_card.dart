import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/cart_entity.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class CartProductCard extends StatefulWidget {
  final CartEntity cartEntity;

  const CartProductCard(this.cartEntity, {Key key}) : super(key: key);

  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  @override
  Widget build(BuildContext context) {
    Product product = productBloc.cartProducts
        // ignore: unrelated_type_equality_checks
        .firstWhere((element) => widget.cartEntity == element);

    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
      width: double.infinity,
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
      decoration: BoxDecoration(
          boxShadow: Styles.cardShadows,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          Container(
            width: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // image:
              //     DecorationImage(fit: BoxFit.cover, image: product.firstImage),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Styles.cardTextColor,
                            fontSize: 16,
                            fontFamily: "SegoeUIBold"),
                      ),
                      GestureDetector(
                        onTap: () {
                          productBloc.removeProductFromCart(widget.cartEntity);
                          productBloc.calculateCartTotal();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.5, horizontal: 5.0),
                          child: Icon(
                            Icons.close,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                  ),
                  Row(
                    children: [
                      Text(
                        "Размер",
                        style: TextStyle(fontSize: 13.0),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                      Text(
                        widget.cartEntity.size,
                        style: TextStyle(
                            color: Styles.cardTextColor,
                            fontFamily: "SegoeUISemiBold",
                            fontSize: 16),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              widget.cartEntity.count.toString(),
                              style: TextStyle(
                                  fontFamily: "SegoeUI", fontSize: 14),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                "x",
                                style: TextStyle(fontFamily: "SegoeUISemiBold"),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                  product.totalPrice.floor().toString() +
                                      " сум",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Styles.cardTextColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Styles.mainColor, width: 2)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (widget.cartEntity.count > 1) {
                                  setState(() => widget.cartEntity.count--);
                                  productBloc.calculateCartTotal();
                                  productBloc.saveCartEntitiesToLocal();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: 5, left: 15.0, right: 15.0),
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      color: Styles.mainColor,
                                      fontSize: 20,
                                      fontFamily: "SegoeUIBold"),
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (widget.cartEntity.count <
                                    product.maxCount) {
                                  setState(() => widget.cartEntity.count++);
                                  productBloc.calculateCartTotal();
                                  productBloc.saveCartEntitiesToLocal();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: 5, left: 15.0, right: 15.0),
                                child: Text("+",
                                    style: TextStyle(
                                        color: Styles.mainColor,
                                        fontSize: 25,
                                        fontFamily: "SegoeUIBold")),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
