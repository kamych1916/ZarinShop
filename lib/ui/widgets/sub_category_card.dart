import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/screen_products.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoryCard extends StatelessWidget {
  final Category category;

  const SubCategoryCard(this.category, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductsScreen(
            category,
            isSubCategoryShowing: false,
          ),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image(
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.width / 4 - 20,
              image: NetworkImage(category.imgUrl ?? ""),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
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
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.width / 4 - 20,
                              ),
                            ));
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            padding:
                EdgeInsets.only(top: 5.0, bottom: 8.0, left: 25.0, right: 25.0),
            decoration: BoxDecoration(
                color: Styles.mainColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
                boxShadow: Styles.cardShadows),
            child: Text(
              category.name,
              maxLines: 2,
              style: TextStyle(
                fontFamily: "SegoeUISemiBold",
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
