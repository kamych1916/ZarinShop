import 'package:flutter/material.dart';

showErrorMessage(String message, BuildContext context) {
  final snackbar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    duration: new Duration(seconds: 2),
    backgroundColor: Colors.red,
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
    ),
    duration: new Duration(seconds: 2),
    backgroundColor: Colors.green,
  );

  try {
    context.size;
  } catch (exception) {
    return;
  }

  return Scaffold.of(context).showSnackBar(snackbar);
}
