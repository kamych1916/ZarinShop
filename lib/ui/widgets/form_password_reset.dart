import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/fields.dart';
import 'package:Zarin/ui/widgets/form_button.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResetForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.0),
      decoration: BoxDecoration(color: Styles.backgroundColor),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 40.0),
              alignment: Alignment.center,
              child: Text(
                "Восстановить пароль",
                style: TextStyle(fontSize: 20),
              ),
            ),
            EmailField(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            FormButton(
              title: "Продолжить",
              onTap: () async {
                if (userBloc.validateEmail()) {
                  ApiResponse<bool> response = await userBloc.resetPassword();
                  if (response.status != Status.COMPLETED) {
                    showErrorMessage(response.message, context);
                  } else if (response.status == Status.COMPLETED &&
                      !response.data)
                    showErrorMessage(
                        "Пользователя с таким email не существует", context);
                  else
                    userBloc.animateLoginScreenLeft();
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
            )
          ],
        ),
      ),
    );
  }
}
