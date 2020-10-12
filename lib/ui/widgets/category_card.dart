import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/screen_sub_category.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final double cardHeight = 110;
  final double horizontalMargin = 20;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    final double cardWidth =
        MediaQuery.of(context).size.width - horizontalMargin;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: horizontalMargin),
      width: cardWidth,
      height: cardWidth,
      color: Styles.backgroundColor,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(FadePageRoute(
          fullscreenDialog: true,
          builder: (context) => SubCategoryScreen(category: category),
        )),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: Styles.cardShadows),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: cardWidth - 100,
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: Styles.cardShadows),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        category.name,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Styles.textColor,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text("5 шт."),

                      /// TODO: category.count
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
