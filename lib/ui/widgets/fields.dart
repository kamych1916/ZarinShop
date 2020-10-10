import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/utils/strings.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userBloc.passwordStream,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return TextField(
            keyboardType: TextInputType.visiblePassword,
            textAlign: TextAlign.center,
            onChanged: userBloc.changePassword,
            obscureText: true,
            style: TextStyle(
                decoration: TextDecoration.none,
                decorationColor: Colors.white.withOpacity(0)),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
                filled: true,
                fillColor: Color.fromRGBO(230, 236, 240, 1),
                hintMaxLines: 1,
                hintStyle: TextStyle(
                    color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                hintText: StringConstant.passwordHint,
                errorText: snapshot.error),
          );
        });
  }
}

class EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userBloc.emailStream,
        builder: (context, snapshot) {
          return TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: userBloc.changeEmail,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  decorationColor: Colors.white.withOpacity(0)),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
                  filled: true,
                  fillColor: Color.fromRGBO(230, 236, 240, 1),
                  hintMaxLines: 1,
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none)),
                  hintText: StringConstant.emailHint,
                  errorText: snapshot.error));
        });
  }
}
