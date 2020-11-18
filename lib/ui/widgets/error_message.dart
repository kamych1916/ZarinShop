import 'package:flutter/material.dart';

showErrorMessage(String message, BuildContext context) {
  final snackbar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(fontFamily: "SegoeUI"),
    ),
    duration: new Duration(seconds: 2),
    backgroundColor: Colors.red[400],
  );

  try {
    context.size;
  } catch (exception) {
    return;
  }

  Scaffold.of(context).showSnackBar(snackbar);
}

showMessage(String message, BuildContext context) async {
  final snackbar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(fontFamily: "SegoeUI"),
    ),
    duration: new Duration(seconds: 2),
    backgroundColor: Colors.green[300],
  );

  try {
    context.size;
  } catch (exception) {
    return;
  }

  return Scaffold.of(context).showSnackBar(snackbar);
}
