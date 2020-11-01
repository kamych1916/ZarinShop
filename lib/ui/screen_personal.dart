import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/ui/screen_login.dart';
import 'package:Zarin/ui/screen_password_reset.dart';
import 'package:Zarin/ui/widgets/cart_icon.dart';
import 'package:Zarin/ui/widgets/favorite_icon.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.backgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Row(
                children: [
                  FavoriteIcon(),
                  CartIcon(),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Icon(
              AppIcons.user,
              size: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            Text(
              userBloc.firstName + " " + userBloc.lastName,
              style: TextStyle(fontSize: 14, fontFamily: "SegoeUiSemiBold"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.5),
            ),
            Text(
              userBloc.email,
              style: TextStyle(fontFamily: "SegoeUiBold"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            Row(
              children: [
                Icon(
                  AppIcons.language,
                  size: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                ),
                Expanded(
                    child: Text(
                  "Язык приложения",
                  style: TextStyle(fontFamily: "SegoeUiSemiBold"),
                )),
                DropdownButton<String>(
                  isDense: true,
                  dropdownColor: Styles.backgroundColor,
                  elevation: 1,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                  ),
                  underline: Container(),
                  onChanged: (value) {},
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        "Русский",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    DropdownMenuItem(
                      child: Text(
                        "Узбекский",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            Row(
              children: [
                Icon(
                  AppIcons.map_marker,
                  size: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                ),
                Expanded(
                    child: Text(
                  "Мои адреса",
                  style: TextStyle(fontFamily: "SegoeUiSemiBold"),
                )),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            Row(
              children: [
                Icon(
                  AppIcons.question_circle,
                  size: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                ),
                Expanded(
                    child: Text(
                  "Помощь и связь",
                  style: TextStyle(fontFamily: "SegoeUiSemiBold"),
                )),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            GestureDetector(
              onTap: () {
                userBloc.resetPassword();
                Navigator.of(context).push(FadePageRoute(
                  builder: (context) => PasswordResetScreen(),
                ));
              },
              child: Row(
                children: [
                  Icon(
                    AppIcons.key,
                    size: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                  ),
                  Expanded(
                      child: Text(
                    "Сменить пароль",
                    style: TextStyle(fontFamily: "SegoeUiSemiBold"),
                  )),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            GestureDetector(
              onTap: () {
                userBloc.logout();
                Navigator.of(context).pushReplacement(FadePageRoute(
                  builder: (context) => LoginScreen(),
                ));
              },
              child: Row(
                children: [
                  Icon(
                    AppIcons.exit,
                    size: 20.0,
                    color: Colors.red[400],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                  ),
                  Expanded(
                      child: Text(
                    "Выйти",
                    style: TextStyle(
                        color: Colors.red[400], fontFamily: "SegoeUiSemiBold"),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
