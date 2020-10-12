import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/form_button.dart';
import 'package:Zarin/ui/widgets/verification_code.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class PasswordResetCodeVerify extends StatefulWidget {
  @override
  _PasswordResetCodeVerifyState createState() =>
      _PasswordResetCodeVerifyState();
}

class _PasswordResetCodeVerifyState extends State<PasswordResetCodeVerify> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FocusNode firstInputFocusNode = new FocusNode();

  bool codeSubmit = false;
  String code;
  String password;
  String secondPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(color: Styles.backgroundColor),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              alignment: Alignment.center,
              child: Text(
                "На ваш email " +
                    userBloc.email +
                    " был отправлен код подтверждения",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            VerificationCode(
              textStyle: TextStyle(fontSize: 30.0, color: Styles.cardTextColor),
              underlineColor: Styles.cartFooterTotalTextColor,
              keyboardType: TextInputType.number,
              itemSize: MediaQuery.of(context).size.width / 4 - 20,
              autofocus: true,
              length: 4,
              onCompleted: (value) {
                code = value;
                firstInputFocusNode.requestFocus();
              },
              onEditing: (value) {},
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      focusNode: firstInputFocusNode,
                      keyboardType: TextInputType.visiblePassword,
                      textAlign: TextAlign.center,
                      onChanged: (value) => password = value,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? "Введите новый пароль"
                            : value.length < 8
                                ? "Длинна пароля должна быть больше 8 символов"
                                : null;
                      },
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          decorationColor: Colors.white.withOpacity(0)),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 15, right: 15, top: 5),
                          filled: true,
                          fillColor: Color.fromRGBO(230, 236, 240, 1),
                          hintMaxLines: 1,
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(134, 145, 173, 1),
                              fontSize: 14.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                          hintText: "Введите новый пароль"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      textAlign: TextAlign.center,
                      onChanged: (value) => secondPassword = value,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? "Введите новый пароль повторно"
                            : value.length < 8
                                ? "Длинна пароля должна быть больше 8 символов"
                                : null;
                      },
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          decorationColor: Colors.white.withOpacity(0)),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 15, right: 15, top: 5),
                          filled: true,
                          fillColor: Color.fromRGBO(230, 236, 240, 1),
                          hintMaxLines: 1,
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(134, 145, 173, 1),
                              fontSize: 14.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                          hintText: "Введите новый пароль повторно"),
                    )
                  ],
                ),
              ),
            ),
            FormButton(
              title: "Продолжить",
              onTap: () async {
                if (code == null || code.isEmpty || code.length != 4) {
                  showErrorMessage("Введите код подтверждения", context);
                  return;
                }

                if (!_formKey.currentState.validate()) return;

                if (password != secondPassword) {
                  showErrorMessage("Пароли не совпадают", context);
                  return;
                }

                ApiResponse<bool> authResult =
                    await userBloc.checkPasswordResetCode(code, password);

                if (authResult.status != Status.COMPLETED) {
                  showErrorMessage(authResult.message, context);
                } else if (authResult.status == Status.COMPLETED &&
                    !authResult.data) {
                  userBloc.clearCodeVerifyInputs;
                  _formKey.currentState.reset();
                  showErrorMessage("Неверный код", context);
                } else {
                  showMessage("Пароль успешно изменен", context);
                  Future.delayed(Duration(seconds: 1),
                      () => userBloc.animateLoginScreenToMainPage());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}