import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/utils/fading_circle.dart';

import '../../utils/strings.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  //UserBloc _bloc;

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
    //_bloc = UserBlocProvider.of(context);
  }

  @override
  void dispose() {
    //_bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Login From Build");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //emailField(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        //passwordField(),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        //submitButton(),
        Text("Забыли пароль?")
      ],
    );
  }

  // Widget passwordField() {
  //   return StreamBuilder(
  //       stream: _bloc.passwordStream,
  //       builder: (context, AsyncSnapshot<String> snapshot) {
  //         return TextField(
  //           textAlign: TextAlign.center,
  //           onChanged: _bloc.changePassword,
  //           obscureText: true,
  //           style: TextStyle(
  //               decoration: TextDecoration.none,
  //               decorationColor: Colors.white.withOpacity(0)),
  //           decoration: InputDecoration(
  //               contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
  //               filled: true,
  //               fillColor: Color.fromRGBO(230, 236, 240, 1),
  //               hintMaxLines: 1,
  //               hintStyle: TextStyle(
  //                   color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
  //               border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                   borderSide: BorderSide(width: 0, style: BorderStyle.none)),
  //               hintText: StringConstant.passwordHint,
  //               errorText: snapshot.error),
  //         );
  //       });
  // }

  // Widget emailField() {
  //   return StreamBuilder(
  //       stream: _bloc.emailStream,
  //       builder: (context, snapshot) {
  //         return TextField(
  //             textAlign: TextAlign.center,
  //             onChanged: _bloc.changeEmail,
  //             style: TextStyle(
  //                 decoration: TextDecoration.none,
  //                 decorationColor: Colors.white.withOpacity(0)),
  //             decoration: InputDecoration(
  //                 contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
  //                 filled: true,
  //                 fillColor: Color.fromRGBO(230, 236, 240, 1),
  //                 hintMaxLines: 1,
  //                 hintStyle: TextStyle(
  //                     color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
  //                 border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                     borderSide:
  //                         BorderSide(width: 0, style: BorderStyle.none)),
  //                 hintText: StringConstant.emailHint,
  //                 errorText: snapshot.error));
  //       });
  // }

  // Widget submitButton() {
  //   return StreamBuilder(
  //       stream: _bloc.signInStream,
  //       builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
  //         if (!snapshot.hasData || snapshot.hasError) {
  //           return button();
  //         } else {
  //           return FadingCircle(
  //             color: Colors.black,
  //             size: 50,
  //           );
  //         }
  //       });
  // }

  // Widget button() {
  //   return RaisedButton(
  //       child: Text(StringConstant.submit),
  //       textColor: Colors.white,
  //       color: Colors.black,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: new BorderRadius.circular(30.0)),
  //       onPressed: () async {
  //         if (_bloc.validateFields()) {
  //           _bloc.isSignedIn(true);

  //           ApiResponse<bool> authResult = await _bloc.submit();

  //           if (authResult.status != Status.COMPLETED) {
  //             _showErrorMessage(authResult.message);
  //           } else if (authResult.status == Status.COMPLETED &&
  //               !authResult.data)
  //             _showErrorMessage("Проверьте правильность введенного пароля");
  //           else {
  //             //Navigator
  //             print("Auth true");
  //           }

  //           _bloc.signedError("Auth Error");
  //         }
  //       });
}

// _showErrorMessage(String message) {
//   final snackbar = SnackBar(
//     content: Text(
//       message,
//       textAlign: TextAlign.center,
//     ),
//     duration: new Duration(seconds: 2),
//     backgroundColor: Colors.red,
//   );
//   Scaffold.of(context).showSnackBar(snackbar);
