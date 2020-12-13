import 'package:Zarin/ui/screen_search.dart';
import 'package:Zarin/ui/widgets/cart_icon.dart';
import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/ui/screen_cart.dart';
import 'package:Zarin/ui/screen_home.dart';
import 'package:Zarin/ui/screen_favorites.dart';
import 'package:Zarin/ui/screen_user.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens;
  List<PersistentBottomNavBarItem> tabs;
  Color activeTabColor = Styles.mainColor;

  @override
  void initState() {
    screens = [
      HomeScreen(),
      SearchScreen(),
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
        icon: CartIcon(),
        activeColor: activeTabColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.heart),
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
      iconSize: 20,
      controller: appBloc.tabController,
      screens: screens,
      items: tabs,
      confineInSafeArea: true,
      backgroundColor: Styles.subBackgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: false,
      ),
      navBarStyle: NavBarStyle.style14,
    );
  }
}
