import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/fields.dart';
import 'package:Zarin/ui/widgets/form_button.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Widget stringInputField(int index, String hintText, String errorText) {
    return TextFormField(
      keyboardType: TextInputType.name,
      textAlign: TextAlign.center,
      onChanged: (value) => userBloc.signUpInputStrings[index] = value,
      validator: (value) {
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
      return FormButton(
        title: "Продолжить",
        onTap: () async {
          if (userBloc.validateFields() && formKey.currentState.validate()) {
            ApiResponse<bool> response = await userBloc.signUp();

            if (response.status != Status.COMPLETED) {
              showErrorMessage(response.message, context);
            } else if (response.status == Status.COMPLETED && !response.data)
              showErrorMessage("Email уже зарегистрирован", context);
            else
              userBloc.animateLoginScreenRight();
          }
        },
      );
    }

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
                  "Регистрация",
                  style: TextStyle(fontSize: 20),
                ),
              ),
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
                    stringInputField(1, "Фамилия", "Введите свою фамилию"),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              button(context),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
