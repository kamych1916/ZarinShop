import 'dart:async';

import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/cart_entity.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/screen_product_info.dart';
import 'package:Zarin/ui/widgets/filter_sheet.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

class CartProductCard extends StatefulWidget {
  final CartEntity cartEntity;

  const CartProductCard(this.cartEntity, {Key key}) : super(key: key);

  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  final BehaviorSubject<int> countSubject = BehaviorSubject<int>();
  StreamSubscription streamSubscription;
  Product product;

  @override
  void initState() {
    product = productBloc.cartProducts.value.data
        // ignore: unrelated_type_equality_checks
        .firstWhere((element) => widget.cartEntity == element);

    countSubject.sink.add(-product.sizes.firstWhere(
        (element) => element["size"] == widget.cartEntity.size)["kol"]);

    streamSubscription = countSubject.listen((value) {
      if (value >= 1) {
        widget.cartEntity.count = value;
        productBloc.calculateCartTotal();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    countSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => pushNewScreen(
              context,
              screen: ProductInfo(product, product.id + widget.cartEntity.size),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.fade,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Hero(
                tag: product.id + widget.cartEntity.size,
                child: Image(
                  fit: BoxFit.cover,
                  width: 100,
                  height: double.infinity,
                  image: NetworkImage(product.firstImage ?? ""),
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    } else {
                      return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: frame != null
                              ? child
                              : Shimmer.fromColors(
                                  baseColor: Styles.subBackgroundColor,
                                  highlightColor:
                                      Styles.mainColor.withOpacity(0.5),
                                  period: Duration(milliseconds: 2000),
                                  child: Container(
                                    color: Styles.subBackgroundColor,
                                    width: 100,
                                    height: double.infinity,
                                  ),
                                ));
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Styles.cardTextColor,
                              fontSize: 16,
                              fontFamily: "SegoeUIBold"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => productBloc
                            .removeProductFromCart(widget.cartEntity),
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: Icon(
                            Icons.close,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                  ),
                  Row(
                    children: [
                      Text(
                        "Цвет",
                        style: TextStyle(
                            fontSize: 13.0, fontFamily: "SegoeUISemiBold"),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: ShapeDecoration(
                          shadows: [
                            BoxShadow(
                              color: Colors.black54,
                              spreadRadius: 0,
                              blurRadius: 1,
                            )
                          ],
                          color: HexColor.fromHex(product.color),
                          shape: SuperellipseShape(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.cartEntity.size == null ||
                          widget.cartEntity.size == "null" ||
                          product.productWithOutSize
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text(
                                "Размер",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: "SegoeUISemiBold"),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0)),
                              Text(
                                widget.cartEntity.size,
                                style: TextStyle(
                                    color: Styles.cardTextColor,
                                    fontFamily: "SegoeUISemiBold",
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                            product.totalPrice.floor().toString() + " сум",
                            maxLines: 1,
                            style: TextStyle(
                                color: Styles.cardTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                      ),
                      //Counter(countSubject, initCount: widget.cartEntity.count),
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
