import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/ui/screen_category.dart';
import 'package:Zarin/ui/widgets/progress_indicator.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  appInit() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    await productBloc.init(context);
    Navigator.pushReplacement(
        context,
        FadePageRoute(
          builder: (context) => CategoryScreen(),
        ));
  }

  @override
  void initState() {
    appInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.mainColor,
      child: Column(
        children: [
          Expanded(
            child: Center(
                child: Text(
              "Zarin Shop",
              style: TextStyle(
                  fontSize: 30.0,
                  color: Styles.textColor,
                  decoration: TextDecoration.none),
            )),
          ),
          Expanded(
            child: Center(
                child: AppCircularProgressIndicator(
              size: 25,
            )),
          )
        ],
      ),
    );
  }
}
