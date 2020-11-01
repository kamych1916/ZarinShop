import 'dart:async';

import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class ProductCardFavoriteIcon extends StatefulWidget {
  final Product product;

  const ProductCardFavoriteIcon(this.product, {Key key}) : super(key: key);
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
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorTween = ColorTween(begin: Colors.white, end: Colors.red[400])
        .animate(_animationController);

    if (productBloc.favoritesEntities.contains(widget.product.id))
      _animationController.forward();

    streamSubscription = productBloc.favoritesEntitiesStream.listen((event) {
      if (!event.contains(widget.product.id)) _animationController.reset();
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
      onTap: () {
        if (_animationController.status == AnimationStatus.completed) {
          productBloc.removeProductFromFavorite(widget.product);
          _animationController.reverse();
        } else {
          productBloc.addProductToFavorite(widget.product);
          _animationController.forward();
        }
      },
      child: Container(
        child: AnimatedBuilder(
          animation: _colorTween,
          builder: (context, child) => Container(
            margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
            decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Styles.cardFavoriteIconBackgroundColor,
                shadows: Styles.cardShadows),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 8.0, bottom: 6.0, left: 8, right: 8),
              child: Icon(AppIcons.heart, color: _colorTween.value),
            ),
          ),
        ),
      ),
    );
  }
}
