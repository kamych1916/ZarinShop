import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/ui/screen_main.dart';
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
    await appBloc.init(context);
    Navigator.pushReplacement(
        context,
        FadePageRoute(
          builder: (context) => MainScreen(),
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
      color: Styles.backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Zarin Shop",
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black54,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
          Expanded(
            child: Center(
                child: AppCircularProgressIndicator(
              color: Colors.black54,
              size: 25,
            )),
          )
        ],
      ),
    );
  }
}
