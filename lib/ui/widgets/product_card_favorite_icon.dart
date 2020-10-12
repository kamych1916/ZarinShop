import 'package:Zarin/app_icons.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class ProductCardFavoriteIcon extends StatefulWidget {
  @override
  _ProductCardFavoriteIconState createState() =>
      _ProductCardFavoriteIconState();
}

class _ProductCardFavoriteIconState extends State<ProductCardFavoriteIcon>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  AnimationController _animationController;
  Animation _colorTween;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorTween = ColorTween(begin: Colors.white, end: Colors.red[400])
        .animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reverse();
        } else {
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
