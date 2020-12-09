import 'package:flutter/material.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  const AppCircularProgressIndicator(
      {Key key, this.size, this.color, this.strokeWidth = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 20.0,
      height: size ?? 20.0,
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(color ?? Colors.white),
        strokeWidth: strokeWidth,
      ),
    );
  }
}
