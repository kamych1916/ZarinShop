import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Slider extends StatefulWidget {
  final List<Widget> children;

  Slider({Key key, this.children}) : super(key: key);

  @override
  _SliderState createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  BehaviorSubject<int> currentIndex;

  @override
  void initState() {
    currentIndex = new BehaviorSubject()..add(0);
    super.initState();
  }

  @override
  void dispose() {
    currentIndex.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / widget.children.length;
    return Column(
      children: [
        Expanded(
          child: PageView(
            children: widget.children,
            onPageChanged: (value) => currentIndex.sink.add(value),
          ),
        ),
        widget.children.length >= 2
            ? Container(
                height: 2,
                width: double.infinity,
                color: Styles.subBackgroundColor,
                alignment: Alignment.centerLeft,
                child: Line(
                  size: size,
                  currentIndex: currentIndex,
                ),
              )
            : Container()
      ],
    );
  }
}

class Line extends StatefulWidget {
  final double size;
  final BehaviorSubject currentIndex;

  const Line({Key key, this.size, this.currentIndex}) : super(key: key);
  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  double position;
  bool show = false;

  @override
  void initState() {
    position = 0;
    widget.currentIndex
        .listen((value) => setState(() => position = value * widget.size));

    Future.delayed(
        Duration(milliseconds: 100), () => setState(() => show = true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: Duration(milliseconds: 500),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        height: 2,
        margin: EdgeInsets.only(left: position),
        width: widget.size,
        decoration: BoxDecoration(
          boxShadow: Styles.cardShadows,
          color: Colors.black,
        ),
      ),
    );
  }
}
