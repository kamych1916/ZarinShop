import 'dart:async';

import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/ui/widgets/progress_indicator.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class FormButton extends StatefulWidget {
  final Function onTap;
  final String title;

  const FormButton({Key key, this.onTap, this.title}) : super(key: key);

  @override
  _FormButtonState createState() => _FormButtonState();
}

class _FormButtonState extends State<FormButton> {
  bool responseAwait = false;
  StreamSubscription stateUpdater;

  @override
  void initState() {
    stateUpdater = userBloc.apiResponse.listen(listener);
    super.initState();
  }

  listener(bool event) => setState(() => responseAwait = event);

  @override
  void dispose() {
    stateUpdater.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Styles.mainColor,
                borderRadius: BorderRadius.circular(10)),
            child: responseAwait
                ? AppCircularProgressIndicator()
                : Text(
                    widget.title,
                    style: TextStyle(
                        fontFamily: 'SegoeUIBold', color: Colors.white),
                  )),
        onTap: responseAwait ? null : widget.onTap);
  }
}
