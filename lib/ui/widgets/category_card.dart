import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/screen_products.dart';
import 'package:Zarin/ui/screen_sub_category.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final double cardHeight = 110;
  final double horizontalMargin = 20;

  const CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    final double cardWidth =
        MediaQuery.of(context).size.width - horizontalMargin;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: horizontalMargin),
      width: cardWidth,
      height: cardWidth,
      child: GestureDetector(
        onTap: () {
          if (category.subcategories.isEmpty)
            pushNewScreen(
              context,
              screen: ProductsScreen(category),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.fade,
            );
          else
            pushNewScreen(
              context,
              screen: SubCategoryScreen(category),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.fade,
            );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                fit: BoxFit.cover,
                width: cardWidth,
                height: cardWidth,
                image: NetworkImage(category.imgUrl),
                frameBuilder: (BuildContext context, Widget child, int frame,
                    bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  } else {
                    return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: frame != null
                            ? child
                            : Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[400],
                                child: Container(
                                  color: Colors.grey,
                                  width: cardWidth,
                                  height: cardWidth,
                                ),
                              ));
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: cardWidth - 100,
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                    color: Styles.mainColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
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
                            color: Colors.white,
                            fontSize: 22.0,
                            fontFamily: "SegoeUIBold"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        category.count.toString() + " шт.",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "SegoeUISemiBold",
                        ),
                      ),
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
