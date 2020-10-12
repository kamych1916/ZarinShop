import 'dart:math';

import 'package:Zarin/app_icons.dart';
import 'package:Zarin/ui/screen_product_info.dart';
import 'package:Zarin/ui/widgets/product_card_favorite_icon.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final rng = new Random();
  @override
  Widget build(BuildContext context) {
    int rnd = rng.nextInt(2);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).push(FadePageRoute(
        builder: (context) => ProductInfo(),
      )),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3 - 15.0,
                  decoration: BoxDecoration(
                      color: Styles.mainColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: Styles.cardShadows),
                ),
                ProductCardFavoriteIcon() //productId
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Халат махровый",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.5),
                  ),
                  Text(
                    "5000 сум",
                    style: TextStyle(
                        color: Styles.cardTextColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
