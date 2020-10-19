import 'package:Zarin/ui/screen_splash.dart';
import 'package:Zarin/ui/screen_category.dart';
import 'package:Zarin/ui/screen_login.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Styles.backgroundColor,
      statusBarIconBrightness: Brightness.dark));

  runApp(ZarinApp());
}

///Отключение Material Splash
class Behavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;
}

class ZarinApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zarin Shop',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Styles.backgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87, size: 22),
            textTheme: TextTheme(
                headline6: TextStyle(color: Colors.black87, fontSize: 16))),
        scaffoldBackgroundColor: Styles.backgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru', 'RU'),
      ],
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: Behavior(),
          child: child,
        );
      },
      initialRoute: "/splash",
      routes: {
        '/splash': (BuildContext context) => SplashScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/home': (BuildContext context) => CategoryScreen(),
      },
    );
  }
}

/// TODO: Добавить галку при регистрации с пользовательскуим соглашением
///
