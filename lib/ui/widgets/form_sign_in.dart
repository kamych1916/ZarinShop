import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/fields.dart';
import 'package:Zarin/ui/widgets/form_button.dart';
import 'package:Zarin/utils/styles.dart';

import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  @override
  void initState() {
    userBloc.changeEmail("");
    userBloc.changePassword("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc.canFieldsRequestFocus = true;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.0),
      decoration: BoxDecoration(color: Styles.backgroundColor),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 40.0),
                alignment: Alignment.center,
                child: Text(
                  "Войти в Zarin Shop",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              EmailField(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              PasswordField(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              button(context),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              GestureDetector(
                  onTap: () {
                    userBloc.changeEmail("");
                    userBloc.animateLoginScreenLeft();
                  },
                  child: Text(
                    "Забыли пароль?",
                    style: TextStyle(decoration: TextDecoration.underline),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              GestureDetector(
                onTap: () {
                  userBloc.changeEmail("");
                  userBloc.changePassword("");
                  userBloc.animateLoginScreenRight();
                },
                child: Text(
                  "Регистрация",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
              )
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
          ApiResponse<bool> authResult = await userBloc.signIn();

          if (authResult.status != Status.COMPLETED) {
            showErrorMessage(authResult.message, context);
          } else if (authResult.status == Status.COMPLETED && !authResult.data)
            showErrorMessage(
                "Проверьте правильность введенного пароля", context);
          else {
            //Navigator
            print("Auth true");
          }
        }
      },
    );
  }
}
