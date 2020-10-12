import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/verification_code.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class SignUpCodeVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(color: Styles.backgroundColor),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
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
          ),
          Flexible(
            flex: 2,
            child: VerificationCode(
              textStyle: TextStyle(fontSize: 30.0, color: Styles.cardTextColor),
              underlineColor: Styles.cartFooterTotalTextColor,
              keyboardType: TextInputType.number,
              itemSize: MediaQuery.of(context).size.width / 4 - 20,
              autofocus: true,
              length: 4,
              onCompleted: (value) async {
                ApiResponse<bool> authResult =
                    await userBloc.checkSignUpCode(value);

                if (authResult.status != Status.COMPLETED) {
                  showErrorMessage(authResult.message, context);
                } else if (authResult.status == Status.COMPLETED &&
                    !authResult.data) {
                  userBloc.clearCodeVerifyInputs;
                  showErrorMessage("Неверный код", context);
                } else {
                  showMessage("Регистрация прошла успешно", context);
                  Future.delayed(Duration(seconds: 2),
                      () => userBloc.animateLoginScreenToMainPage());
                }
              },
              onEditing: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
