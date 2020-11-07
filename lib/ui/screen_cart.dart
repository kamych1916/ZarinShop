import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/screen_order.dart';
import 'package:Zarin/ui/widgets/cart_product_card.dart';
import 'package:Zarin/ui/widgets/cart_product_card_loading.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StreamSubscription streamSubscribtion;

  @override
  void initState() {
    cartInit();

    streamSubscribtion = productBloc.cartEntitiesStream.listen((event) async {
      await productBloc.getCartProducts();
      productBloc.calculateCartTotal();
    });

    super.initState();
  }

  cartInit() async {
    await productBloc.getCartProducts();
    productBloc.calculateCartTotal();
  }

  refresh() => productBloc.getCartProducts();

  @override
  void dispose() {
    streamSubscribtion.cancel();
    super.dispose();
  }

  Widget _error(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            AppIcons.warning,
            size: 30.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontFamily: "SegoeUI"),
          ),
          FlatButton(
            child: Text(
              "Повторить попытку",
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 12.0,
                  fontFamily: "SegoeUISemiBold"),
            ),
            onPressed: () => refresh(),
          ),
        ],
      ),
    );
  }

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
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 18),
          ),
        ),
      ),
      backgroundColor: Styles.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: StreamBuilder(
                stream: productBloc.cartProductsStream,
                builder: (context,
                    AsyncSnapshot<ApiResponse<List<Product>>> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data.status == Status.LOADING) {
                    return CupertinoScrollbar(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) =>
                              CartProductCardLoading()),
                    );
                  }
                  if (snapshot.data.status == Status.ERROR)
                    return Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: _error(snapshot.data.message),
                    );

                  if (productBloc.cartProducts.isEmpty)
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 100.0),
                        child: Text("Корзина пуста"),
                      ),
                    );

                  return CupertinoScrollbar(
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: productBloc.cartProducts.length,
                        itemBuilder: (context, index) =>
                            CartProductCard(productBloc.cartEntities[index])),
                  );
                },
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
                          fontSize: 18,
                          fontFamily: "SegoeUIBold"),
                    ),
                    Row(
                      children: [
                        StreamBuilder<double>(
                            stream: productBloc.cartTotalStream,
                            builder: (context, snapshot) {
                              return AnimatedCount(
                                count: snapshot.hasData
                                    ? snapshot.data.floor()
                                    : 0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                              );
                            }),
                        Text(
                          " сум",
                          style: TextStyle(
                              color: Styles.cartFooterTotalTextColor,
                              fontSize: 14,
                              fontFamily: "SegoeUIBold"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              GestureDetector(
                onTap: () => productBloc.cartEntities.isNotEmpty
                    ? Navigator.of(context).push(FadePageRoute(
                        builder: (context) => OrderScreen(),
                      ))
                    : null,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Styles.mainColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    "Оплатить",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'SegoeUIBold'),
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class AnimatedCount extends ImplicitlyAnimatedWidget {
  final int count;

  AnimatedCount(
      {Key key,
      @required this.count,
      @required Duration duration,
      Curve curve = Curves.linear})
      : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween _count;

  @override
  Widget build(BuildContext context) {
    return new Text(
      _count.evaluate(animation).toString(),
      style: TextStyle(
          color: Styles.cartFooterTotalTextColor,
          fontSize: 18,
          fontFamily: "SegoeUIBold"),
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _count = visitor(
        _count, widget.count, (dynamic value) => new IntTween(begin: value));
  }
}
