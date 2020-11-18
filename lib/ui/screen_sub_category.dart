import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/screen_products.dart';
import 'package:Zarin/ui/widgets/sub_category_card.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoryScreen extends StatelessWidget {
  final Category category;

  SubCategoryScreen(this.category, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.subBackgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.translucent,
            child: Container(
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            category.name,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 18),
          ),
        ),
      ),
      backgroundColor: Styles.subBackgroundColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width / 2,
            child: Stack(
              children: [
                Image(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width / 2,
                  image: NetworkImage(category.imgUrl),
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
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
                                        MediaQuery.of(context).size.width / 2,
                                  ),
                                ));
                    }
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[300].withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.count.toString(),
                                style: TextStyle(
                                    fontFamily: "SegoeUIBold",
                                    fontSize: 28,
                                    color: Colors.black.withAlpha(180)),
                              ),
                              Text(
                                category.count == 1
                                    ? "Товар"
                                    : category.count <= 4
                                        ? "Товара"
                                        : "Товаров",
                                style: TextStyle(
                                    fontFamily: "SegoeUI",
                                    fontSize: 20,
                                    color: Colors.black.withAlpha(180)),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      GestureDetector(
                        onTap: () => pushNewScreen(
                          context,
                          screen: ProductsScreen(
                            category,
                            isSubCategoryShowing: false,
                          ),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 5.0, bottom: 8.0),
                          decoration: BoxDecoration(
                            color: Styles.mainColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: Styles.cardShadows,
                          ),
                          child: Text(
                            "Показать все",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "SegoeUISemiBold",
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CupertinoScrollbar(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                shrinkWrap: true,
                itemCount: category.subcategories.length,
                itemBuilder: (context, index) {
                  return SubCategoryCard(category.subcategories[index]);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
