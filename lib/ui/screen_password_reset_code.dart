import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/form_button.dart';
import 'package:Zarin/ui/widgets/verification_code.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class PasswordResetCodeScreen extends StatefulWidget {
  final int popCount;
  const PasswordResetCodeScreen({Key key, this.popCount = 2}) : super(key: key);

  @override
  _PasswordResetCodeScreenState createState() =>
      _PasswordResetCodeScreenState();
}

class _PasswordResetCodeScreenState extends State<PasswordResetCodeScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FocusNode firstInputFocusNode = new FocusNode();

  bool codeSubmit = false;
  String code;
  String password;
  String secondPassword;

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
              int count = 0;
              Navigator.of(context).popUntil((route) {
                return count++ == widget.popCount;
              });
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20.0),
                    alignment: Alignment.center,
                    child: Text(
                      "На ваш email " +
                          userBloc.email.value +
                          " был отправлен код подтверждения",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SegoeUIBold',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  VerificationCode(
                    textStyle:
                        TextStyle(fontSize: 30.0, color: Styles.cardTextColor),
                    underlineColor: Styles.cartFooterTotalTextColor,
                    keyboardType: TextInputType.number,
                    itemSize: MediaQuery.of(context).size.width / 4 - 40,
                    autofocus: true,
                    length: 4,
                    onCompleted: (value) {
                      code = value;
                      firstInputFocusNode.requestFocus();
                    },
                    onEditing: (value) {},
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 40.0,
                      bottom: 20,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 55,
                            child: TextFormField(
                              focusNode: firstInputFocusNode,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              textAlign: TextAlign.center,
                              onChanged: (value) => password = value,
                              cursorColor: Colors.black54,
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
                                  helperText: ' ',
                                  contentPadding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintMaxLines: 1,
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(134, 145, 173, 1),
                                      fontSize: 14.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  hintText: "Введите новый пароль"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          SizedBox(
                            height: 55,
                            child: TextFormField(
                              obscureText: true,
                              cursorColor: Colors.black54,
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
                                  helperText: ' ',
                                  contentPadding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintMaxLines: 1,
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(134, 145, 173, 1),
                                      fontSize: 14.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  hintText: "Введите новый пароль повторно"),
                            ),
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
                        userBloc.clearVerificationCodeInput.publish(true);
                        showErrorMessage("Неверный код", context);
                      } else {
                        showMessage("Пароль успешно изменен", context);
                        await Future.delayed(Duration(seconds: 2));
                        int count = 0;
                        Navigator.of(context).popUntil((route) {
                          return count++ == widget.popCount;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
