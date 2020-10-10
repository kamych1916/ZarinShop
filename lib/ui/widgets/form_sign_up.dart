import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/ui/widgets/fields.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final PageController pageController;

  SignUpForm({Key key, this.pageController}) : super(key: key);

  Widget stringInputField(int index, String hintText, String errorText) {
    return TextFormField(
      keyboardType: TextInputType.name,
      textAlign: TextAlign.center,
      onChanged: (value) => userBloc.signUpInputStrings[index] = value,
      validator: (value) {
        print(value);
        return value == null || value.isEmpty ? errorText : null;
      },
      style: TextStyle(
          decoration: TextDecoration.none,
          decorationColor: Colors.white.withOpacity(0)),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
          filled: true,
          fillColor: Color.fromRGBO(230, 236, 240, 1),
          hintMaxLines: 1,
          hintStyle: TextStyle(
              color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 0, style: BorderStyle.none)),
          hintText: hintText),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                "Продолжить",
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              )),
          onTap: () async {
            if (userBloc.validateFields() && formKey.currentState.validate()) {
              ApiResponse<bool> response = await userBloc.signUp();

              if (response.status != Status.COMPLETED) {
                _showErrorMessage(response.message, context);
              } else if (response.status == Status.COMPLETED && !response.data)
                _showErrorMessage("При регистрации произошла ошибка", context);
              else
                pageController.animateToPage(3,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
            }
          });
    }

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
                    "Регистрация",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
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
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            stringInputField(0, "Имя", "Введите свое имя"),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                            ),
                            stringInputField(
                                1, "Фамилия", "Введите свою фамилию"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      button(context),
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
