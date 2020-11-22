import 'dart:async';

import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/product.dart';
import 'package:flutter/material.dart';

class ProductCardFavoriteIcon extends StatefulWidget {
  final Product product;
  final ValueKey key;

  const ProductCardFavoriteIcon(this.product, {this.key}) : super(key: key);
  @override
  _ProductCardFavoriteIconState createState() =>
      _ProductCardFavoriteIconState();
}

class _ProductCardFavoriteIconState extends State<ProductCardFavoriteIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _colorTween;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _colorTween = ColorTween(begin: Colors.white, end: Colors.red[400])
        .animate(_animationController);

    if (productBloc.favoritesEntities.value.contains(widget.product.id)) {
      _animationController.forward(from: 1.0);
    }

    streamSubscription = productBloc.favoritesEntities.listen((event) {
      if (!event.contains(widget.product.id))
        _animationController.reset();
      else
        _animationController.forward(from: 1.0);
    });

    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: widget.key,
      onTap: () {
        if (_animationController.status == AnimationStatus.completed) {
          productBloc.removeProductFromFavorite(widget.product);
          _animationController.reverse();
        } else {
          productBloc.addProductToFavorite(widget.product);
          _animationController.forward();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        child: AnimatedBuilder(
            animation: _colorTween,
            builder: (context, child) {
              return Container(
                margin: EdgeInsets.all(5.0),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 8.0, bottom: 6.0, left: 8, right: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.black87,
                                spreadRadius: 2,
                                blurRadius: 15)
                          ], color: Colors.green)),
                      Icon(
                        AppIcons.heart_1,
                        color: _colorTween.value,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
