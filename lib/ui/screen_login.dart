import 'package:Zarin/ui/widgets/form_password_reset.dart';
import 'package:Zarin/ui/widgets/form_sign_up.dart';
import 'package:Zarin/ui/widgets/form_sign_up_code_verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/form_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final PageController pageController = new PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      PasswordResetForm(),
      SignInForm(
        pageController: pageController,
      ),
      SignUpForm(pageController: pageController),
      SignUpCodeVerify()
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () async {
              await SystemChannels.textInput.invokeMethod('TextInput.hide');
              pageController.page != 1
                  ? pageController.animateToPage(1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut)
                  : Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        //physics: NeverScrollableScrollPhysics(),
        children: pages,
      ),
    );
  }
}
