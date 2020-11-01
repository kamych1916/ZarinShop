import 'dart:async';
import 'dart:ui';

import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/widgets/cart_icon.dart';
import 'package:Zarin/ui/widgets/favorite_icon.dart';
import 'package:Zarin/ui/widgets/sizes.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:Zarin/ui/widgets/slider_img.dart' as Zarin;
import 'package:rxdart/rxdart.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    String color = "0x" + hexString;
    print(color);
    print(Color(int.parse(color)));
    return Color(int.parse(color));
  }
}

class ProductInfo extends StatefulWidget {
  final Product product;

  const ProductInfo(this.product, {Key key}) : super(key: key);

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  final GlobalKey _cartKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  final PublishSubject<List<dynamic>> addToCartOffsetsSubject =
      PublishSubject();
  final PublishSubject<bool> startDotAnimationSubject = PublishSubject();
  final BehaviorSubject<int> countSubject = BehaviorSubject();
  final BehaviorSubject<int> sizeSubject = BehaviorSubject()..sink.add(-1);

  Offset cartPosition;
  Offset buttonPosition;

  int initCount = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      countSubject.sink.add(initCount);

      final RenderBox renderBoxCart =
          _cartKey.currentContext.findRenderObject();
      cartPosition = renderBoxCart.localToGlobal(Offset.zero);
      final RenderBox renderBoxButton =
          _buttonKey.currentContext.findRenderObject();
      buttonPosition = renderBoxButton.localToGlobal(Offset.zero);

      addToCartOffsetsSubject.sink.add([buttonPosition, cartPosition]);
    });
    super.initState();
  }

  @override
  void dispose() {
    addToCartOffsetsSubject.close();
    startDotAnimationSubject.close();
    countSubject.close();
    sizeSubject.close();
    super.dispose();
  }

  buttonCallback() {
    if (widget.product.sizes.isEmpty || sizeSubject.value == -1) {
      sizeSubject.sink.add(-2);
    } else
      startDotAnimationSubject.sink.add(true);
  }

  counterCallback(int count) => countSubject.sink.add(count);

  addToCartCallback() => productBloc.addProductToCart(
      widget.product, countSubject.value, sizeSubject.value);

  @override
  Widget build(BuildContext context) {
    widget.product.precacheImages(context);

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
                      CartIcon(cartKey: _cartKey),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.8,
                    margin: EdgeInsets.only(top: 5.0),
                    child: Zarin.Slider(
                      children: List.generate(
                        widget.product.images.length,
                        (index) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: widget.product.images[index])),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 2.5)),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Text(
                            widget.product.totalPrice.floor().toString() +
                                " сум",
                            style: TextStyle(
                                fontFamily: "SegoeUIBold", fontSize: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                          ),
                          Text(
                            (widget.product.price).floor().toString() + " сум",
                            style: TextStyle(
                                fontFamily: "SegoeUI",
                                fontSize: 14,
                                color: Colors.red[300],
                                decoration: TextDecoration.lineThrough),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Counter(widget.product.maxCount, counterCallback)
                        ],
                      )),
                  //Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(20)),
                    child: Sizes(widget.product.sizes, sizeSubject),
                  ),
                  //Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  Container(
                    margin:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 80.0),
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          widget.product.name,
                          style: TextStyle(
                              height: 0.9,
                              color: Styles.textColor,
                              fontFamily: "SegoeUIBold",
                              fontSize: 20),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        Row(
                          children: [
                            Text(
                              "Цвет",
                              style: TextStyle(fontFamily: "SegoeUISemiBold"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: ShapeDecoration(

                                  /// TODO: цвет
                                  //color: HexColor.fromHex(widget.product.color),
                                  color: Colors.red,
                                  shadows: Styles.cardShadows,
                                  shape: CircleBorder()),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        SelectableText(
                          widget.product.description,
                          style: TextStyle(
                              fontSize: 13, fontFamily: "SegoeUISemiBold"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AddToCartButton(_buttonKey, buttonCallback, countSubject),
        AddToCartDot(addToCartOffsetsSubject, startDotAnimationSubject,
            countSubject, addToCartCallback),
      ],
    );
  }
}

class AddToCartButton extends StatefulWidget {
  final GlobalKey buttonKey;
  final Function callback;
  final BehaviorSubject<int> countSubject;

  AddToCartButton(this.buttonKey, this.callback, this.countSubject, {Key key})
      : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool isCollapsed = false;
  bool isAnimationStop = true;
  bool isGesureAllowed = true;
  int count;

  StreamSubscription streamSubscription;

  @override
  void initState() {
    streamSubscription = widget.countSubject.listen((value) => count = value);
    super.initState();
  }

  @override
  void setState(func) {
    if (mounted) {
      super.setState(func);
    }
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
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
          width: isCollapsed ? 18 : MediaQuery.of(context).size.width - 100,
          height: isCollapsed ? 18 : 40,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 50, bottom: 10, right: 50),
          decoration: isCollapsed
              ? ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.deepPurple,
                  shadows: Styles.cardShadows)
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepPurple,
                  boxShadow: Styles.cardShadows),
          child: isCollapsed
              ? Padding(
                  padding: EdgeInsets.only(
                      top: 1.5, bottom: 3.0, left: 3.0, right: 3.0),
                  child: Text(count.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 10,
                          fontFamily: "SegoeUI")),
                )
              : isAnimationStop
                  ? Text("В корзину",
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          fontFamily: "SegoeUI"))
                  : null,
        ),
      ),
    );
  }
}

class AddToCartDot extends StatefulWidget {
  final PublishSubject<List<dynamic>> addToCartOffsetsSubject;
  final PublishSubject<bool> startDotAnimationSubject;
  final BehaviorSubject<int> countSubject;
  final Function callback;

  const AddToCartDot(this.addToCartOffsetsSubject,
      this.startDotAnimationSubject, this.countSubject, this.callback,
      {Key key})
      : super(key: key);

  @override
  _AddToCartDotState createState() => _AddToCartDotState();
}

class _AddToCartDotState extends State<AddToCartDot>
    with SingleTickerProviderStateMixin {
  Offset cartPosition;
  Offset buttonPosition;
  Path path;
  int count;

  StreamSubscription streamSubscription;

  AnimationController _controller;
  Animation _animation;

  bool animate = false;

  @override
  void initState() {
    widget.addToCartOffsetsSubject.listen((value) {
      buttonPosition = value[0];
      cartPosition = value[1];
      path = drawPath();
      setState(() {});
    });

    streamSubscription = widget.countSubject.listen((value) => count = value);

    widget.startDotAnimationSubject.listen((value) => setState((() {
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
        widget.callback();
        setState(() {
          animate = false;
          _controller.reverse();
        });
      }
    });
    super.initState();
  }

  Path drawPath() {
    Size size = MediaQuery.of(context).size;
    Path path = Path();
    path.moveTo(size.width / 2 - 9, buttonPosition.dy + 10 - 2);
    path.quadraticBezierTo(
        size.width, 100, cartPosition.dx - 2, cartPosition.dy - 2);
    return path;
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
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buttonPosition == null
        ? Container()
        : Positioned(
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
                    count.toString(),
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

class Counter extends StatefulWidget {
  final int maxCount;
  final Function(int) callback;

  const Counter(this.maxCount, this.callback, {Key key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int current = 1;
  int productMaxCount = 5;

  @override
  void initState() {
    productMaxCount = widget.maxCount ?? 1;
    super.initState();
  }

  @override
  void setState(func) {
    super.setState(func);
    widget.callback(current);
  }

  increment() => current < productMaxCount ? setState(() => current++) : null;
  decrement() => current > 1 ? setState(() => current--) : null;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => decrement(),
          child: Text("-",
              style: TextStyle(fontFamily: "SegoeUISemiBold", fontSize: 16)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
        ),
        Text(
          current.toString(),
          style: TextStyle(fontFamily: "SegoeUIBold", fontSize: 18),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
        ),
        GestureDetector(
          onTap: () => increment(),
          child: Text(
            "+",
            style: TextStyle(fontFamily: "SegoeUISemiBold", fontSize: 16),
          ),
        )
      ],
    );
  }
}
