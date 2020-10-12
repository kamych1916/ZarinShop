import 'dart:async';
import 'dart:ui';

import 'package:Zarin/ui/widgets/cart_icon.dart';
import 'package:Zarin/ui/widgets/favorite_icon.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:Zarin/ui/widgets/slider_img.dart' as Zarin;
import 'package:rxdart/rxdart.dart';

class ProductInfo extends StatefulWidget {
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  final GlobalKey _cartKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  final PublishSubject<List<dynamic>> addToCartOffsetsStream = PublishSubject();
  final PublishSubject<bool> startAnimationStream = PublishSubject();

  Offset cartPosition;
  Offset buttonPosition;

  Path path;
  bool isPathReady = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBoxCart =
          _cartKey.currentContext.findRenderObject();
      cartPosition = renderBoxCart.localToGlobal(Offset.zero);
      final RenderBox renderBoxButton =
          _buttonKey.currentContext.findRenderObject();
      buttonPosition = renderBoxButton.localToGlobal(Offset.zero);
      setState(() {
        isPathReady = true;
      });
      path = drawPath();
      addToCartOffsetsStream.sink.add([buttonPosition, cartPosition, path]);
    });
    super.initState();
  }

  Path drawPath() {
    Size size = MediaQuery.of(context).size;
    Path path = Path();
    path.moveTo(size.width / 2 - 9, buttonPosition.dy + 50 - 2);
    path.quadraticBezierTo(
        size.width, 100, cartPosition.dx - 2, cartPosition.dy - 2);
    return path;
  }

  @override
  void dispose() {
    addToCartOffsetsStream.close();
    startAnimationStream.close();
    super.dispose();
  }

  callback() => startAnimationStream.sink.add(true);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: AppBar(
              brightness: Brightness.light,
              backgroundColor: Styles.backgroundColor,
              iconTheme: new IconThemeData(color: Colors.black87),
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                ),
              ),
              actions: [
                Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Row(
                    children: [
                      FavoriteIcon(),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                      CartIcon(cartKey: _cartKey),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.7,
                child: Zarin.Slider(
                  children: List.generate(
                      5,
                      (index) => Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Text(index.toString()),
                            ),
                          )),
                ),
              ),
              AddToCartButton(_buttonKey, callback)
            ],
          ),
        ),
        AddToCartDot(addToCartOffsetsStream, startAnimationStream),
        isPathReady
            ? Positioned(
                top: 0,
                child: CustomPaint(
                  painter: PathPainter(path),
                ),
              )
            : Container(),
      ],
    );
  }
}

class PathPainter extends CustomPainter {
  Path path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(this.path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AddToCartButton extends StatefulWidget {
  final GlobalKey buttonKey;
  final Function callback;

  AddToCartButton(this.buttonKey, this.callback, {Key key}) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool isCollapsed = false;
  bool isAnimationStop = true;
  bool isGesureAllowed = true;

  @override
  void setState(func) {
    if (mounted) {
      super.setState(func);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () async {
        if (!isGesureAllowed) return;

        setState(() {
          isCollapsed = true;
          isAnimationStop = false;
          isGesureAllowed = false;
        });

        await Future.delayed(Duration(milliseconds: 800));

        widget.callback();
        setState(() => isCollapsed = false);

        await Future.delayed(Duration(milliseconds: 500));
        setState(() => isAnimationStop = true);

        await Future.delayed(Duration(milliseconds: 500));
        setState(() => isGesureAllowed = true);
      },
      child: AnimatedContainer(
        key: widget.buttonKey,
        duration: Duration(milliseconds: 500),
        width: isCollapsed ? 18 : 200,
        height: 18,
        alignment: Alignment.center,
        margin: EdgeInsets.all(50),
        decoration: isCollapsed
            ? ShapeDecoration(shape: CircleBorder(), color: Colors.deepPurple)
            : BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepPurple),
        child: isCollapsed ? null : isAnimationStop ? Text("В корзину") : null,
      ),
    );
  }
}

class AddToCartDot extends StatefulWidget {
  final PublishSubject<List<dynamic>> offsetsStream;
  final PublishSubject<bool> startAnimationStream;

  const AddToCartDot(this.offsetsStream, this.startAnimationStream, {Key key})
      : super(key: key);

  @override
  _AddToCartDotState createState() => _AddToCartDotState();
}

class _AddToCartDotState extends State<AddToCartDot>
    with SingleTickerProviderStateMixin {
  Offset cartPosition;
  Offset buttonPosition;
  Path path;

  AnimationController _controller;
  Animation _animation;

  bool animate = false;

  @override
  void initState() {
    widget.offsetsStream.listen((value) {
      buttonPosition = value[0];
      cartPosition = value[1];
      path = value[2];
      setState(() {});
    });

    widget.startAnimationStream.listen((value) => setState((() {
          animate = value;
          _controller.forward();
        })));

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animate = false;
          _controller.reverse();
        });
      }
    });
    super.initState();
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buttonPosition == null
        ? Container()
        : Positioned(
            // onEnd: () {
            //   setState(() => animate = false);
            // },
            // curve: Curves.easeInOut,
            //duration: Duration(seconds: 1),
            // left: animate
            //     ? cartPosition.dx - 2
            //     : MediaQuery.of(context).size.width / 2 - 9,
            // top: animate ? cartPosition.dy - 2 : buttonPosition.dy + 50 - 2,
            top: calculate(_animation.value).dy,
            left: calculate(_animation.value).dx,
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color:
                        animate ? Styles.backgroundColor : Colors.transparent),
                child: Container(
                  width: 18,
                  height: 18,
                  padding: EdgeInsets.only(
                      top: 3.5, bottom: 3.0, left: 3.0, right: 3.0),
                  child: Text(
                    "1",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        decoration: TextDecoration.none,
                        color: animate ? Colors.white : Colors.transparent),
                  ),
                  decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      color: animate ? Colors.deepPurple : Colors.transparent),
                ),
              ),
            ),
          );
  }
}
