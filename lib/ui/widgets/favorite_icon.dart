import 'dart:async';

import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

import '../screen_favorites.dart';

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({Key key}) : super(key: key);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  int count = 0;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    streamSubscription = productBloc.favoritesEntitiesStream.listen((event) {
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
        onTap: () {
          Navigator.of(context).push(FadePageRoute(
            builder: (context) => FavoritesScreen(),
          ));
        },
        child: Container(
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                AppIcons.heart,
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
                      padding: EdgeInsets.only(bottom: 3.0),
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Styles.mainColor,
                      ),
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
