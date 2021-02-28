import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/ui/screen_signup_code.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/fields.dart';
import 'package:Zarin/ui/widgets/form_button.dart';
import 'package:Zarin/ui/widgets/terms_of_use.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rxdart/rxdart.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  final PublishSubject<bool> checkboxErrorSubject = PublishSubject();

  @override
  void dispose() {
    checkboxErrorSubject.close();
    super.dispose();
  }

  Widget stringInputField(int index, String hintText, String errorText) {
    return SizedBox(
      height: 55,
      child: TextFormField(
        keyboardType: TextInputType.name,
        textAlign: TextAlign.center,
        cursorColor: Colors.black54,
        onChanged: (value) => userBloc.signUpInputStrings[index] = value,
        validator: (value) {
          return value == null || value.isEmpty ? errorText : null;
        },
        style: TextStyle(
            decoration: TextDecoration.none,
            decorationColor: Colors.white.withOpacity(0)),
        decoration: InputDecoration(
            helperText: ' ',
            contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
            filled: true,
            fillColor: Colors.white,
            hintMaxLines: 1,
            hintStyle: TextStyle(
                color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            hintText: hintText),
      ),
    );
  }

  Widget phoneInputField(int index) {
    return SizedBox(
      height: 55,
      child: TextFormField(
        cursorColor: Colors.black54,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        onChanged: (value) => userBloc.signUpInputStrings[index] = value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Введите свой номер телефона";
          }

          Pattern pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
          RegExp regex = new RegExp(pattern);

          if (!regex.hasMatch(value)) {
            return "Некорректный номер телефона";
          }

          return null;
        },
        style: TextStyle(
            decoration: TextDecoration.none,
            decorationColor: Colors.white.withOpacity(0)),
        decoration: InputDecoration(
            helperText: ' ',
            contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
            filled: true,
            fillColor: Colors.white,
            hintMaxLines: 1,
            hintStyle: TextStyle(
                color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            hintText: "Номер телефона"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool termsOfUse = false;

    checkboxCallback(bool value) => termsOfUse = value;

    Widget button(BuildContext context) {
      return FormButton(
        title: "Продолжить",
        onTap: () async {
          bool emailAndPasswordValidate = userBloc.validateFields();
          bool formValidate = formKey.currentState.validate();
          if (emailAndPasswordValidate && formValidate) {
            if (!termsOfUse) {
              checkboxErrorSubject.sink.add(true);
              return;
            }

            ApiResponse<bool> response = await userBloc.signUp();

            if (response.status != Status.COMPLETED) {
              showErrorMessage(response.message, context);
            } else if (response.status == Status.COMPLETED && !response.data)
              showErrorMessage("Email уже зарегистрирован", context);
            else
              pushNewScreen(
                context,
                screen: SignUpCodeScreen(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
          }
        },
      );
    }

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
              userBloc.password.publish("");
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 40.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Регистрация",
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
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                Form(
                  key: formKey,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                                child:
                                    stringInputField(0, "Имя", "Введите имя")),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.5),
                            ),
                            Expanded(
                                child: stringInputField(
                                    1, "Фамилия", "Введите фамилию")),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        phoneInputField(2),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                PasswordField(),
                TermsOfUseCheckBox(checkboxCallback, checkboxErrorSubject),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                button(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TermsOfUseCheckBox extends StatefulWidget {
  final Function(bool) callback;
  final PublishSubject<bool> errorSubject;

  const TermsOfUseCheckBox(this.callback, this.errorSubject, {Key key})
      : super(key: key);

  @override
  _TermsOfUseCheckBoxState createState() => _TermsOfUseCheckBoxState();
}

class _TermsOfUseCheckBoxState extends State<TermsOfUseCheckBox> {
  bool value = false;
  bool error = false;

  @override
  void initState() {
    widget.errorSubject.listen((value) => setState(() => error = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: 'Я согласен с ',
            style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 12,
                  fontFamily: 'SegoeUISemiBold',
                ),
            children: <TextSpan>[
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      // await SystemChannels.textInput
                      //     .invokeMethod('TextInput.hide');
                      // showModalBottomSheet(
                      //     isScrollControlled: true,
                      //     backgroundColor: Colors.transparent,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.vertical(
                      //           top: Radius.circular(25.0)),
                      //     ),
                      //     context: context,
                      //     builder: (context) => DraggableScrollableSheet(
                      //         expand: false,
                      //         initialChildSize: 0.64,
                      //         minChildSize: 0.2,
                      //         maxChildSize: 1,
                      //         builder: (context, scrollController) =>
                      //             TermsOfUse(
                      //               controller: scrollController,
                      //             )));
                    },
                  text: 'пользовательским соглашением',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue)),
            ],
          ),
        ),
        CircularCheckBox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (value) {
            setState(() => this.value = value);
            widget.callback(value);
          },
          value: value,
          activeColor: Styles.mainColor,
          inactiveColor: error ? Colors.red[300] : Colors.grey[400],
        )
      ],
    );
  }
}
