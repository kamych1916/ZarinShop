import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/screen_products.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SubCategoriesScreen extends StatelessWidget {
  final Category category;

  const SubCategoriesScreen(this.category, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.subBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.subBackgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          centerTitle: true,
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
          title: Text(
            category.name,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 18),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 35.0),
        child: CupertinoScrollbar(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              padding: EdgeInsets.zero,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: category.subcategories.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () => category.subcategories[index].subcategories !=
                                null &&
                            category
                                .subcategories[index].subcategories.isNotEmpty
                        ? pushNewScreen(
                            context,
                            screen: SubCategoriesScreen(
                                category.subcategories[index]),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          )
                        : pushNewScreen(
                            context,
                            screen:
                                ProductsScreen(category.subcategories[index]),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          ),
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      margin: index == category.subcategories.length - 1
                          ? EdgeInsets.only(bottom: 20.0)
                          : EdgeInsets.zero,
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                category.subcategories[index].name,
                                style: TextStyle(
                                    fontFamily: "SegoeUISemiBold",
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: category.subcategories[index].count != null
                                ? Text(
                                    category.subcategories[index].count
                                        .toString(),
                                  )
                                : Container(),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                          ),
                        ],
                      ),
                    ),
                  )),
        )),
      ),
    );
  }
}
