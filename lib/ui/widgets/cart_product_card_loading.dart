import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class CartProductCardLoading extends StatefulWidget {
  @override
  _CartProductCardLoadingState createState() => _CartProductCardLoadingState();
}

class _CartProductCardLoadingState extends State<CartProductCardLoading>
    with SingleTickerProviderStateMixin {
  Animation<double> animationOpacity;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
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
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 7.5, bottom: 7.5),
      width: double.infinity,
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
      decoration: BoxDecoration(
          boxShadow: Styles.cardShadows,
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0)),
      child: Row(
        children: [
          Container(
              width: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(218, 221, 232, 1)
                      .withOpacity(animationOpacity.value))),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 25,
                        decoration: borderContainerDecoration,
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: borderContainerDecoration,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 25,
                        decoration: borderContainerDecoration,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: borderContainerDecoration,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15,
                            height: 25,
                            decoration: borderContainerDecoration,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7.5),
                          ),
                          Container(
                            width: 60,
                            height: 25,
                            decoration: borderContainerDecoration,
                          ),
                        ],
                      ),
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color.fromRGBO(218, 221, 232, 1)
                                .withOpacity(animationOpacity.value)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
