import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight) / 2;

    return Container(
      width: size.width / 2 - 40,
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Styles.subBackgroundColor,
            highlightColor: Styles.mainColor.withOpacity(0.5),
            period: Duration(milliseconds: 2000),
            child: Container(
              width: double.infinity,
              height: itemHeight - 80,
              decoration: BoxDecoration(
                  color: Styles.subBackgroundColor,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.5),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Styles.subBackgroundColor,
                  highlightColor: Styles.mainColor.withOpacity(0.5),
                  period: Duration(milliseconds: 2000),
                  child: Container(
                    width: 100,
                    height: 15.0,
                    decoration: BoxDecoration(
                        color: Styles.subBackgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                ),
                Shimmer.fromColors(
                  baseColor: Styles.subBackgroundColor,
                  highlightColor: Styles.mainColor.withOpacity(0.5),
                  period: Duration(milliseconds: 2000),
                  child: Container(
                    width: double.infinity,
                    height: 15.0,
                    decoration: BoxDecoration(
                        color: Styles.subBackgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
