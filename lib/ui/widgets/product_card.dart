import 'package:Zarin/ui/screen_product_info.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).push(FadePageRoute(
        builder: (context) => ProductInfo(),
      )),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 15.0, bottom: 15.0),
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Styles.cardFavoriteIconBackgroundColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 8.0, left: 10, right: 10),
                        child: Icon(Icons.favorite, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Махровый халат",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.5),
                  ),
                  Text(
                    "5000 сум",
                    style: TextStyle(
                      color: Styles.cardTextColor,
                      fontSize: 15.0,
                    ),
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
