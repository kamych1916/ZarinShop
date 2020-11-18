import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/ui/screen_password_reset_code.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/fields.dart';
import 'package:Zarin/ui/widgets/form_button.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class PasswordResetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.subBackgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              userBloc.email.publish("");
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Styles.subBackgroundColor,
      body: Builder(
        builder: (context) => Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 40.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Восстановить пароль",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'SegoeUIBold',
                    ),
                  ),
                ),
                EmailField(
                  focusRequest: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                FormButton(
                  title: "Продолжить",
                  onTap: () async {
                    if (userBloc.validateEmail()) {
                      ApiResponse<bool> response =
                          await userBloc.resetPassword();
                      if (response.status != Status.COMPLETED) {
                        showErrorMessage(response.message, context);
                      } else if (response.status == Status.COMPLETED &&
                          !response.data)
                        showErrorMessage(
                            "Пользователя с таким email не существует",
                            context);
                      else
                        pushNewScreen(
                          context,
                          screen: PasswordResetCodeScreen(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
