import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/ui/widgets/form_password_reset.dart';
import 'package:Zarin/ui/widgets/form_password_reset_code_verify.dart';
import 'package:Zarin/ui/widgets/form_sign_up.dart';
import 'package:Zarin/ui/widgets/form_sign_up_code_verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/form_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final List<Widget> pages = [
    PasswordResetCodeVerify(false),
    PasswordResetForm(),
    SignInForm(),
    SignUpForm(),
    SignUpCodeVerify()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () async {
              await SystemChannels.textInput.invokeMethod('TextInput.hide');
              if (userBloc.pageController.page != userBloc.mainLoginPage) {
                userBloc.canFieldsRequestFocus = false;
                userBloc.animateLoginScreenToMainPage();
              } else
                Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: userBloc.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: pages,
      ),
    );
  }
}
