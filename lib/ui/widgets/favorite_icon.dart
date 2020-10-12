import 'package:Zarin/app_icons.dart';
import 'package:Zarin/ui/screen_cart.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:flutter/material.dart';

class FavoriteIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(FadePageRoute(
              builder: (context) => CartScreen(),
            )),
        child: Icon(
          AppIcons.heart,
          size: 22,
        ));
  }
}
