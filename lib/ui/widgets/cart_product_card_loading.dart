import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CartProductCardLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[400],
      child: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
