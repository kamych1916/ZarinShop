import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/screen_product_info.dart';
import 'package:Zarin/ui/widgets/product_card_favorite_icon.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard(this.product, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).push(FadePageRoute(
        builder: (context) => ProductInfo(product),
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
                      image: DecorationImage(
                          fit: BoxFit.cover, image: product.image),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: Styles.cardShadows),
                ),
                ProductCardFavoriteIcon(product)
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: "SegoeUIBold")),
                  Text(
                    product.price.floor().toString() + " сум",
                    style: TextStyle(
                        color: Styles.cardTextColor,
                        fontSize: 16.0,
                        fontFamily: "SegoeUISemiBold"),
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
