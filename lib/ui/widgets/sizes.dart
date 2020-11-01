import 'dart:async';

import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Sizes extends StatefulWidget {
  final BehaviorSubject<int> subject;
  final List<String> sizes;

  const Sizes(this.sizes, this.subject, {Key key}) : super(key: key);

  @override
  _SizesState createState() => _SizesState();
}

class _SizesState extends State<Sizes> {
  StreamSubscription streamSubscription;
  bool isError = false;

  @override
  void initState() {
    streamSubscription = widget.subject.listen((value) {
      if (value == -2)
        setState(() => isError = true);
      else if (isError) setState(() => isError = false);
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.sizes == null || widget.sizes.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.5),
              ),
              Text(
                "Размеры",
                style: TextStyle(fontFamily: "SegoeUIBold"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 20.0,
                spacing: 10.0,
                children: List.generate(
                    widget.sizes.length,
                    (index) => SizeContainer(
                        widget.sizes[index], index, widget.subject)),
              ),
              AnimatedContainer(
                margin: EdgeInsets.only(top: 10.0),
                duration: Duration(milliseconds: 500),
                height: isError ? 30 : 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Выберите размер",
                    style: TextStyle(
                        color: Colors.red, fontFamily: "SegoeUISemiBold"),
                  ),
                ),
              )
            ],
          );
  }
}

class SizeContainer extends StatefulWidget {
  final String size;
  final BehaviorSubject<int> currentSizeSubject;
  final int index;

  const SizeContainer(this.size, this.index, this.currentSizeSubject, {Key key})
      : super(key: key);

  @override
  _SizeContainerState createState() => _SizeContainerState();
}

class _SizeContainerState extends State<SizeContainer> {
  StreamSubscription streamSubscription;
  bool isActive = false;

  @override
  void initState() {
    streamSubscription = widget.currentSizeSubject.listen((value) {
      if (value != widget.index && isActive) setState(() => isActive = false);
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.currentSizeSubject.sink.add(widget.index);
        setState(() => isActive = true);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
            color: isActive ? Styles.mainColor : Colors.white,
            boxShadow: Styles.cardShadows,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          widget.size,
          style: TextStyle(fontFamily: "SegoeUISemiBold"),
        ),
      ),
    );
  }
}
