import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class ProductCardLoading extends StatefulWidget {
  @override
  _ProductCardLoadingState createState() => _ProductCardLoadingState();
}

class _ProductCardLoadingState extends State<ProductCardLoading>
    with SingleTickerProviderStateMixin {
  Animation<double> animationOpacity;
  AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animationOpacity = Tween<double>(begin: 0.3, end: 1).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration borderContainerDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(218, 221, 232, 1)
            .withOpacity(animationOpacity.value));

    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3 - 15.0,
            decoration: BoxDecoration(
                color: Color.fromRGBO(218, 221, 232, 1)
                    .withOpacity(animationOpacity.value),
                borderRadius: BorderRadius.circular(25),
                boxShadow: Styles.cardShadows),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 15,
                  decoration: borderContainerDecoration,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                ),
                Container(
                  width: 100,
                  height: 15,
                  decoration: borderContainerDecoration,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
