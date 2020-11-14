import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/ui/screen_cart.dart';
import 'package:Zarin/ui/screen_categories.dart';
import 'package:Zarin/ui/screen_favorites.dart';
import 'package:Zarin/ui/screen_login.dart';
import 'package:Zarin/ui/screen_personal.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String categories = 'categories';
  static const String search = 'search';
  static const String cart = 'cart';
  static const String favorites = 'favorites';
  static const String user = 'user';

  static const Map<NavigationBarItem, String> rootRoutes = {
    NavigationBarItem.HOME: categories,
    NavigationBarItem.SEARCH: search,
    NavigationBarItem.CART: cart,
    NavigationBarItem.FAVORITES: favorites,
    NavigationBarItem.USER: user
  };
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.navigationBarItem});

  final GlobalKey<NavigatorState> navigatorKey;
  final NavigationBarItem navigationBarItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.categories: (context) => CategoriesScreen(),
      TabNavigatorRoutes.search: (context) => Container(
            child: Center(
              child: Text("search"),
            ),
          ),
      TabNavigatorRoutes.cart: (context) => CartScreen(),
      TabNavigatorRoutes.favorites: (context) => FavoritesScreen(),
      TabNavigatorRoutes.user: (context) =>
          userBloc.auth ? UserScreen() : LoginScreen()
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    String initialRoute = TabNavigatorRoutes.rootRoutes[navigationBarItem];

    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: (routeSettings) {
        print(routeSettings.name);
        if (routeSettings.name == "/" ||
            routeBuilders[routeSettings.name] == null)
          return MaterialPageRoute(
            builder: (context) => Container(
              child: Center(
                child: Text("Неизвестность"),
              ),
            ),
          );
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}
