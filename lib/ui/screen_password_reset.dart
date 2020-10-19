import 'package:Zarin/ui/widgets/form_password_reset_code_verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResetScreen extends StatelessWidget {
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
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
          ),
        ),
        body: PasswordResetCodeVerify(true));
  }
}
