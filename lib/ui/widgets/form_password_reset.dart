import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/ui/widgets/fields.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class PasswordResetForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.0),
      decoration: BoxDecoration(color: Styles.backgroundColor),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(bottom: 20.0),
              alignment: Alignment.center,
              child: Text(
                "Восстановить пароль",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              children: [
                EmailField(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                ),
                PasswordResetFormButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordResetFormButton extends StatefulWidget {
  @override
  _PasswordResetFormButtonState createState() =>
      _PasswordResetFormButtonState();
}

class _PasswordResetFormButtonState extends State<PasswordResetFormButton> {
  bool submit = false;
  @override
  Widget build(BuildContext context) {
    return submit
        ? Container(
            child: Text(
            "На вашу почту высланы инструкции по восстановлению пароля",
            textAlign: TextAlign.center,
          ))
        : GestureDetector(
            onTap: () async {
              if (userBloc.validateEmail()) {
                ApiResponse<bool> response = await userBloc.resetPassword();
                if (response.status == Status.COMPLETED)
                  setState(() => submit = true);
                else
                  _showErrorMessage(response.message);
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: Styles.mainColor,
                  borderRadius: BorderRadius.circular(25)),
              child: Text(
                "Продолжить",
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          );
  }

  _showErrorMessage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      duration: new Duration(seconds: 2),
      backgroundColor: Colors.red,
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
