import 'package:Zarin/ui/screen_password_reset_code.dart';
import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/ui/screen_login.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userBloc.auth.stream,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData)
          return Container(
            color: Styles.subBackgroundColor,
          );
        return !snapshot.data
            ? LoginScreen()
            : Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: AppBar(
                    backgroundColor: Styles.subBackgroundColor,
                    centerTitle: true,
                    title: Text(
                      "Личный кабинет",
                      style: TextStyle(fontFamily: "SegoeUIBold", fontSize: 18),
                    ),
                  ),
                ),
                backgroundColor: Styles.subBackgroundColor,
                body: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                        style: TextStyle(
                            fontSize: 14, fontFamily: "SegoeUiSemiBold"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.5),
                      ),
                      Text(
                        userBloc.email.value,
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
                          pushNewScreen(
                            context,
                            screen: PasswordResetCodeScreen(
                              popCount: 1,
                            ),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
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
                                  color: Colors.red[400],
                                  fontFamily: "SegoeUiSemiBold"),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
