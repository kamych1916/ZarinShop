import 'package:flutter/material.dart';

class Styles {
  static final Color mainColor = Color.fromRGBO(191, 171, 141, 1);
  static final Color textColor = Color.fromRGBO(170, 158, 139, 1);
  static final Color subBackgroundColor = Color.fromRGBO(244, 241, 236, 1);
  static final Color backgroundColor = Color.fromRGBO(247, 248, 252, 1);
  static final Color cardTextColor = Color.fromRGBO(155, 124, 90, 1);
  static final Color cardFavoriteIconBackgroundColor =
      Color.fromRGBO(224, 215, 205, 1);
  static final Color cartCardTitleTextColor = Color.fromRGBO(127, 127, 127, 1);
  static final Color cartFooterTotalTextColor = Color.fromRGBO(98, 97, 94, 1);

  static final List<BoxShadow> cardShadows = [
    BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: Offset(0, 0),
        blurRadius: 0.5,
        spreadRadius: 0.05),
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      offset: Offset(0, 0),
      blurRadius: 5.0,
    ),
  ];
}
