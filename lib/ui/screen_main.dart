import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/ui/screen_cart.dart';
import 'package:Zarin/ui/screen_categories.dart';
import 'package:Zarin/ui/screen_favorites.dart';
import 'package:Zarin/ui/screen_personal.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PersistentTabController _controller;
  List<Widget> screens;
  List<PersistentBottomNavBarItem> tabs;
  Color activeTabColor = Styles.mainColor;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);

    screens = [
      CategoriesScreen(),
      Container(
        child: Center(child: Text("2")),
      ),
      CartScreen(),
      FavoritesScreen(),
      UserScreen()
    ];

    tabs = [
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.home),
        activeColor: activeTabColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.magnifier),
        activeColor: activeTabColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.cart),
        activeColor: activeTabColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.heart_empty),
        activeColor: activeTabColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.user),
        activeColor: activeTabColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      navBarHeight: 50,
      iconSize: 26,
      controller: _controller,
      screens: screens,
      items: tabs,
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: false,
      ),
      navBarStyle: NavBarStyle.style6,
      onItemSelected: (index) {
        if (index == 3) productBloc.getFavoritesProducts();
      },
    );
  }
}
