import 'package:flutter/material.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;
  const AppCircularProgressIndicator({Key key, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 20.0,
      height: size ?? 20.0,
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(color ?? Colors.white),
        strokeWidth: 1,
      ),
    );
  }
}
