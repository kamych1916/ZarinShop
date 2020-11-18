import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/ui/widgets/error_message.dart';
import 'package:Zarin/ui/widgets/verification_code.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class SignUpCodeScreen extends StatelessWidget {
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
              var count = 0;
              Navigator.of(context).popUntil((route) {
                return count++ == 2;
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Builder(
          builder: (context) => Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  onCompleted: (value) async {
                    ApiResponse<bool> authResult =
                        await userBloc.checkSignUpCode(value);

                    if (authResult.status != Status.COMPLETED) {
                      showErrorMessage(authResult.message, context);
                    } else if (authResult.status == Status.COMPLETED &&
                        !authResult.data) {
                      userBloc.clearVerificationCodeInput.publish(true);
                      showErrorMessage("Неверный код", context);
                    } else {
                      showMessage("Регистрация прошла успешно", context);
                      await Future.delayed(Duration(seconds: 2));
                      var count = 0;
                      Navigator.of(context).popUntil((route) {
                        return count++ == 2;
                      });
                    }
                  },
                  onEditing: (value) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
