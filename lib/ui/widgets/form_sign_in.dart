import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/ui/screen_personal.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/fields.dart';
import 'package:Zarin/ui/widgets/form_button.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';

import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  @override
  void initState() {
    userBloc.email.publish("");
    userBloc.password.publish("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc.canFieldsRequestFocus = false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 40.0),
                alignment: Alignment.center,
                child: Text(
                  "Войти в Zarin Shop",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'SegoeUISemiBold',
                  ),
                ),
              ),
              EmailField(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              PasswordField(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              button(context),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 7.5),
              ),
              GestureDetector(
                  onTap: () {
                    userBloc.email.publish("");
                    userBloc.animateLoginScreenLeft();
                  },
                  child: Text("Забыли пароль?",
                      style:
                          TextStyle(color: Colors.blue[600], fontSize: 12.0))),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              GestureDetector(
                onTap: () {
                  userBloc.email.publish("");
                  userBloc.password.publish("");
                  userBloc.animateLoginScreenRight();
                },
                child: Text(
                  "Регистрация",
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 16.0,
                    fontFamily: 'SegoeUISemiBold',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(BuildContext context) {
    return FormButton(
      title: "Войти",
      onTap: () async {
        if (userBloc.validateFields()) {
          ApiResponse<dynamic> authResult = await userBloc.signIn();

          if (authResult.status != Status.COMPLETED) {
            showErrorMessage(authResult.message, context);
          } else if (authResult.status == Status.COMPLETED &&
              !userBloc.auth.value)
            showErrorMessage(
                "Проверьте правильность введенного пароля", context);
          else {
            Navigator.of(context).pushReplacement(FadePageRoute(
              builder: (context) => UserScreen(),
            ));
          }
        }
      },
    );
  }
}
