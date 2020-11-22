import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/utils/strings.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userBloc.password.stream,
        builder: (context, snapshot) {
          return SizedBox(
            height: 55,
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.center,
              onChanged: userBloc.password.publish,
              obscureText: true,
              cursorColor: Colors.black54,
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
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none)),
                  hintText: StringConstant.passwordHint,
                  errorText: snapshot.error),
            ),
          );
        });
  }
}

class EmailField extends StatelessWidget {
  final bool focusRequest;

  EmailField({this.focusRequest = false});

  final FocusNode focusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    if (focusRequest) focusNode.requestFocus();
    return StreamBuilder(
        stream: userBloc.email.stream,
        builder: (context, snapshot) {
          return SizedBox(
            height: 55,
            child: TextFormField(
                initialValue: userBloc.email.value,
                cursorColor: Colors.black54,
                focusNode: focusNode,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: userBloc.email.publish,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    decorationColor: Colors.white.withOpacity(0)),
                decoration: InputDecoration(
                    helperText: ' ',
                    contentPadding:
                        EdgeInsets.only(left: 15, right: 15, top: 5),
                    filled: true,
                    fillColor: Colors.white,
                    hintMaxLines: 1,
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(134, 145, 173, 1),
                        fontSize: 14.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none)),
                    hintText: StringConstant.emailHint,
                    errorText: snapshot.error)),
          );
        });
  }
}
