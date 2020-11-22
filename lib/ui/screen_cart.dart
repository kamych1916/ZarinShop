import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/screen_order.dart';
import 'package:Zarin/ui/widgets/cart_product_card.dart';
import 'package:Zarin/ui/widgets/cart_product_card_loading.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StreamSubscription streamSubscription;

  @override
  void initState() {
    streamSubscription = productBloc.cartEntities.listen((event) async {
      await productBloc.getCartProducts();
    });

    super.initState();
  }

  refresh() => productBloc.getCartProducts();

  @override
  void dispose() {
    streamSubscription.cancel();
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
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          backgroundColor: Styles.subBackgroundColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Корзина",
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 18),
          ),
        ),
      ),
      backgroundColor: Styles.subBackgroundColor,
      body: StreamBuilder(
          stream: userBloc.auth.stream,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData)
              return Container(
                color: Styles.subBackgroundColor,
              );
            return !snapshot.data
                ? Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Войдите, чтобы просматривать корзину",
                            style: TextStyle(fontFamily: "SegoeUISemiBold"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => appBloc.tabController.jumpToTab(4),
                            child: Text(
                              "Войти",
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontSize: 16.0,
                                fontFamily: 'SegoeUISemiBold',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: productBloc.cartProducts.stream,
                          builder: (context,
                              AsyncSnapshot<ApiResponse<List<Product>>>
                                  snapshot) {
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

                            if (productBloc.cartProducts.value.data.isEmpty)
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 100.0),
                                  child: Text("Корзина пуста"),
                                ),
                              );

                            return CupertinoScrollbar(
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: productBloc
                                      .cartProducts.value.data.length,
                                  itemBuilder: (context, index) =>
                                      CartProductCard(productBloc
                                          .cartEntities.value[index])),
                            );
                          },
                        ),
                      ),
                      Column(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                                      stream: productBloc.cartTotalPrice.stream,
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
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (productBloc.cartEntities.value.isNotEmpty)
                              pushNewScreen(
                                context,
                                screen: OrderScreen(),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade,
                              );
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                                boxShadow: Styles.cardShadows,
                                color: Styles.mainColor,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  topRight: const Radius.circular(10.0),
                                )),
                            child: Text(
                              "Оплатить",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontFamily: 'SegoeUIBold'),
                            ),
                          ),
                        )
                      ])
                    ],
                  );
          }),
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
