import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/ui/widgets/fields.dart';
import 'package:Zarin/utils/fading_circle.dart';
import 'package:Zarin/utils/styles.dart';

import '../../utils/strings.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  final PageController pageController;

  const SignInForm({Key key, this.pageController}) : super(key: key);

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(color: Styles.backgroundColor),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              MediaQuery.of(context).padding.top -
              50,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Войти в Zarin Shop",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
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
                          onTap: () => widget.pageController.animateToPage(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut),
                          child: Text(
                            "Забыли пароль?",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      GestureDetector(
                        onTap: () => widget.pageController.animateToPage(2,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut),
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Styles.mainColor,
                                borderRadius: BorderRadius.circular(25)),
                            child: Text(
                              "Регистрация",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button(BuildContext context) {
    return GestureDetector(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Styles.mainColor,
                borderRadius: BorderRadius.circular(25)),
            child: Text(
              "Войти",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            )),
        onTap: () async {
          if (userBloc.validateFields()) {
            ApiResponse<bool> authResult = await userBloc.signIn();

            if (authResult.status != Status.COMPLETED) {
              _showErrorMessage(authResult.message, context);
            } else if (authResult.status == Status.COMPLETED &&
                !authResult.data)
              _showErrorMessage(
                  "Проверьте правильность введенного пароля", context);
            else {
              //Navigator
              print("Auth true");
            }
          }
        });
  }

  _showErrorMessage(String message, BuildContext context) {
    final snackbar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      duration: new Duration(seconds: 2),
      backgroundColor: Colors.red,
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
