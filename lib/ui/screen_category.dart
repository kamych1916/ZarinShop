import 'package:Zarin/ui/widgets/cart_icon.dart';
import 'package:Zarin/ui/widgets/category_card.dart';
import 'package:Zarin/ui/widgets/drawer.dart';
import 'package:Zarin/ui/widgets/slider_menu.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Zarin/data.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Map<String, int>> categories = Data.categories;
  final GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
        appBarColor: Styles.backgroundColor,
        key: _key,
        sliderOpen: SliderOpen.LEFT_TO_RIGHT,
        sliderMenuOpenOffset: MediaQuery.of(context).size.width - 100,
        appBarHeight: 40,
        sliderMenu: ZarinDrawer(sliderKey: _key),
        drawerIconColor: Colors.black87,
        drawerIconSize: 22.0,
        isShadow: false,
        sliderAnimationTimeInMilliseconds: 500,
        trailing:
            Container(padding: EdgeInsets.only(right: 10.0), child: CartIcon()),
        sliderMain: Container(
          color: Styles.backgroundColor,
          child: CupertinoScrollbar(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) =>
                  CategoryCard(categories[index], index),
            ),
          ),
        ),
      ),
    );
    // return Scaffold(
    //   //drawer: ZarinDrawer(),
    //   // appBar: PreferredSize(
    //   //   preferredSize: Size.fromHeight(40),
    //   //   child: AppBar(
    //   //     automaticallyImplyLeading: false,
    //   //     leading: GestureDetector(
    //   //       child: Icon(Icons.menu),
    //   //     ),
    //   //     actions: [
    //   //       Container(padding: EdgeInsets.only(right: 10.0), child: CartIcon())
    //   //     ],
    //   //   ),
    //   // ),
    //   body: Container(
    //     color: Styles.backgroundColor,
    //     child: CupertinoScrollbar(
    //       child: ListView.builder(
    //         physics: BouncingScrollPhysics(),
    //         itemCount: categories.length,
    //         itemBuilder: (context, index) =>
    //             CategoryCard(categories[index], index),
    //       ),
    //     ),
    //   ),
    // );
  }
}
