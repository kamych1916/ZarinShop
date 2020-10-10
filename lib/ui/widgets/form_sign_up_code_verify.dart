import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class SignUpCodeVerify extends StatelessWidget {
  Widget codeField() {
    return TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      obscureText: true,
      style: TextStyle(
          decoration: TextDecoration.none,
          decorationColor: Colors.white.withOpacity(0)),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
        filled: true,
        fillColor: Color.fromRGBO(230, 236, 240, 1),
        hintMaxLines: 1,
        hintStyle:
            TextStyle(color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );
  }

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
                    //userBloc.email +
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
              onCompleted: (value) {},
              onEditing: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
