import 'dart:async';

import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/widgets/product_card.dart';
import 'package:Zarin/ui/widgets/product_card_loading.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  StreamSubscription streamSubscription;

  @override
  void initState() {
    productBloc.getFavoritesProducts();
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  refresh() => productBloc.getFavoritesProducts();

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
    print("favorites build");
    return Scaffold(
      backgroundColor: Styles.subBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          backgroundColor: Styles.subBackgroundColor,
          centerTitle: true,
          title: Text(
            "Избранное",
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 18),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: StreamBuilder(
          stream: productBloc.favoritesProducts.stream,
          builder:
              (context, AsyncSnapshot<ApiResponse<List<Product>>> snapshot) {
            if (!snapshot.hasData || snapshot.data.status == Status.LOADING)
              return CupertinoScrollbar(
                child: GridView.count(
                  childAspectRatio: 1 / 2,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 30.0,
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: List.generate(6, (index) {
                    return ProductCardLoading();
                  }),
                ),
              );

            if (snapshot.data.status == Status.ERROR)
              return Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: _error(snapshot.data.message),
              );

            if (productBloc.favoritesProducts.value.data.isEmpty)
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100.0),
                  child: Text("Список избранного пуст"),
                ),
              );

            return CupertinoScrollbar(
              child: GridView.count(
                childAspectRatio: 1 / 2,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 30.0,
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(
                    productBloc.favoritesProducts.value.data.length, (index) {
                  return ProductCard(
                      productBloc.favoritesProducts.value.data[index]);
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}
