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
    return Stack(
      children: [
        PageView(
          children: widget.children,
          onPageChanged: (value) => currentIndex.sink.add(value),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 30.0,
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  widget.children.length,
                  (index) => Dot(
                        index: index,
                        currentIndex: currentIndex,
                      )),
            ),
          ),
        )
      ],
    );
  }
}

class Dot extends StatefulWidget {
  final int index;
  final BehaviorSubject currentIndex;

  const Dot({Key key, this.index, this.currentIndex}) : super(key: key);
  @override
  _DotState createState() => _DotState();
}

class _DotState extends State<Dot> {
  double dotSize = 5.0;

  @override
  void initState() {
    widget.currentIndex.listen((value) {
      if (value == widget.index)
        setState(() => dotSize = 8.5);
      else if (dotSize == 8.5) setState(() => dotSize = 5);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: dotSize,
      height: dotSize,
      margin: EdgeInsets.all(5.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
    );
  }
}
