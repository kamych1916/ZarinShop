import 'dart:async';
import 'dart:ui';

import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/ui/screen_product_info_image_view.dart';
import 'package:Zarin/ui/widgets/colors_picker.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/widgets/progress_indicator.dart';
import 'package:Zarin/ui/widgets/sizes.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:Zarin/ui/widgets/slider_img.dart' as Zarin;
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

class ProductInfo extends StatefulWidget {
  final Product product;
  final String heroTag;

  const ProductInfo(this.product, this.heroTag, {Key key}) : super(key: key);

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  final BehaviorSubject<int> countSubject = BehaviorSubject()..sink.add(1);
  final BehaviorSubject<int> sizeSubject = BehaviorSubject()..sink.add(-1);

  int initCount = 1;

  @override
  void dispose() {
    countSubject.close();
    sizeSubject.close();
    super.dispose();
  }

  counterCallback(int count) => countSubject.sink.add(count);

  addToCartCallback() {
    if (widget.product.sizes != null &&
        (widget.product.sizes.isEmpty || sizeSubject.value == -1))
      sizeSubject.sink.add(-2);
    else if (userBloc.auth.value)
      productBloc.addProductToCart(
          widget.product, countSubject.value, sizeSubject.value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Styles.subBackgroundColor,
          body: Container(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Zarin.Slider(
                      children: List.generate(
                        widget.product.images.length,
                        (index) => GestureDetector(
                          onScaleUpdate: (scale) => scale.scale > 3
                              ? pushNewScreen(
                                  context,
                                  screen: ProductInfoImageView(
                                      index == 0
                                          ? widget.heroTag
                                          : widget.heroTag + index.toString(),
                                      widget.product.images[index]),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade,
                                )
                              : null,
                          onTap: () => pushNewScreen(
                            context,
                            screen: ProductInfoImageView(
                                index == 0
                                    ? widget.heroTag
                                    : widget.heroTag + index.toString(),
                                widget.product.images[index]),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          ),
                          child: Hero(
                            tag: index == 0
                                ? widget.heroTag
                                : widget.heroTag + index.toString(),
                            child: index == 0
                                ? Image(
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    image: NetworkImage(
                                        widget.product.images[index]),
                                    frameBuilder: (BuildContext context,
                                        Widget child,
                                        int frame,
                                        bool wasSynchronouslyLoaded) {
                                      if (wasSynchronouslyLoaded) {
                                        return child;
                                      } else {
                                        return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: frame != null
                                                ? child
                                                : Shimmer.fromColors(
                                                    baseColor: Colors.grey[200],
                                                    highlightColor:
                                                        Colors.grey[350],
                                                    child: Container(
                                                      color: Colors.grey,
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                    ),
                                                  ));
                                      }
                                    },
                                  )
                                : Image(
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    image: NetworkImage(
                                        widget.product.images[index]),
                                    frameBuilder: (BuildContext context,
                                        Widget child,
                                        int frame,
                                        bool wasSynchronouslyLoaded) {
                                      if (wasSynchronouslyLoaded) {
                                        return child;
                                      } else {
                                        return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: frame != null
                                                ? child
                                                : Shimmer.fromColors(
                                                    baseColor: Colors.grey[300],
                                                    highlightColor:
                                                        Colors.grey[350],
                                                    child: Container(
                                                      color: Colors.grey,
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                    ),
                                                  ));
                                      }
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      width: double.infinity,
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  widget.product.totalPrice.floor().toString() +
                                      " сум",
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: "SegoeUIBold", fontSize: 20),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                ),
                                Expanded(
                                  child: Text(
                                    (widget.product.price).floor().toString() +
                                        " сум",
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: "SegoeUIBold",
                                        fontSize: 14,
                                        color: Colors.red[300],
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Counter(widget.product.maxCount, counterCallback)
                        ],
                      )),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    width: double.infinity,
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(20)),
                    child: Sizes(widget.product.sizes, sizeSubject),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      width: double.infinity,
                      child: ColorsPicker(
                          widget.product.linkColor, widget.product.color)),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Divider(),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Container(
                    margin:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 80.0),
                    width: double.infinity,
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          widget.product.name,
                          style: TextStyle(
                              height: 0.9,
                              color: Styles.textColor,
                              fontFamily: "SegoeUIBold",
                              fontSize: 20),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        SelectableText(
                          widget.product.description,
                          style: TextStyle(
                              fontSize: 13, fontFamily: "SegoeUISemiBold"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 80,
          child: AppBar(
            brightness: Brightness.light,
            iconTheme: new IconThemeData(color: Colors.black87),
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () {
                appBloc.productInfoLineState.publish(false);
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54,
                                spreadRadius: 1,
                                blurRadius: 10)
                          ]),
                    ),
                    Text("проверить скейл гестюре"),
                    Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AddToCartButton(
          addToCartCallback,
        ),
      ],
    );
  }
}

class AddToCartButton extends StatefulWidget {
  final Function onTap;

  AddToCartButton(this.onTap, {Key key}) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool responseAwait = false;
  StreamSubscription stateUpdater;

  @override
  void initState() {
    stateUpdater = appBloc.apiResponse.listen(listener);
    super.initState();
  }

  listener(bool event) => setState(() => responseAwait = event);

  @override
  void dispose() {
    stateUpdater.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
            child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    boxShadow: Styles.cardShadows,
                    color: Styles.mainColor,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                    )),
                child: responseAwait
                    ? AppCircularProgressIndicator()
                    : Text(
                        "В корзину",
                        style: TextStyle(
                            fontFamily: 'SegoeUIBold',
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.none),
                      )),
            onTap: responseAwait ? null : widget.onTap));
  }
}

class Counter extends StatefulWidget {
  final int maxCount;
  final int current;
  final Function(int) callback;

  const Counter(this.maxCount, this.callback, {Key key, this.current = 1})
      : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int current;
  int productMaxCount = 5;

  @override
  void initState() {
    current = widget.current;
    productMaxCount = widget.maxCount ?? 1;
    super.initState();
  }

  @override
  void setState(func) {
    super.setState(func);
    widget.callback(current);
  }

  increment() => current < productMaxCount ? setState(() => current++) : null;
  decrement() => current > 1 ? setState(() => current--) : null;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => decrement(),
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Text("-",
                style: TextStyle(fontFamily: "SegoeUISemiBold", fontSize: 16)),
          ),
        ),
        Text(
          current.toString(),
          style: TextStyle(fontFamily: "SegoeUIBold", fontSize: 18),
        ),
        GestureDetector(
          onTap: () => increment(),
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20.0),
            child: Text(
              "+",
              style: TextStyle(fontFamily: "SegoeUISemiBold", fontSize: 16),
            ),
          ),
        )
      ],
    );
  }
}
