import 'dart:async';

import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Sizes extends StatefulWidget {
  final BehaviorSubject<dynamic> subject;
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
      if (value is int && value == -2)
        setState(() => isError = true);
      else if (isError) setState(() => isError = false);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.subject is BehaviorSubject<int>) streamSubscription.cancel();
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
              AnimatedContainer(
                margin: EdgeInsets.only(top: 5.0),
                duration: Duration(milliseconds: 500),
                height: isError ? 30 : 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Выберите размер",
                    style: TextStyle(
                        color: Colors.red[400], fontFamily: "SegoeUISemiBold"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 20.0,
                  spacing: 10.0,
                  children: List.generate(
                      widget.sizes.length,
                      (index) => SizeContainer(
                          widget.sizes[index], index, widget.subject)),
                ),
              ),
            ],
          );
  }
}

class SizeContainer extends StatefulWidget {
  final String size;
  final BehaviorSubject<dynamic> currentSizeSubject;
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
    if (widget.currentSizeSubject is BehaviorSubject<int>)
      streamSubscription = widget.currentSizeSubject.listen((value) {
        if (value != widget.index && isActive) setState(() => isActive = false);
      });

    if (widget.currentSizeSubject is BehaviorSubject<List<int>>) {
      if (widget.currentSizeSubject.value != null &&
          widget.currentSizeSubject.value.isNotEmpty) {
        if (widget.currentSizeSubject.value.contains(widget.index))
          isActive = true;
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.currentSizeSubject is BehaviorSubject<int>)
      streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.currentSizeSubject is BehaviorSubject<int>) {
          widget.currentSizeSubject.sink.add(widget.index);
          setState(() => isActive = true);
        } else if (widget.currentSizeSubject is BehaviorSubject<List<int>>) {
          if (isActive) {
            widget.currentSizeSubject.value.remove(widget.index);
            widget.currentSizeSubject.sink.add(widget.currentSizeSubject.value);
            setState(() => isActive = false);
          } else {
            widget.currentSizeSubject.value.add(widget.index);
            widget.currentSizeSubject.sink.add(widget.currentSizeSubject.value);
            setState(() => isActive = true);
          }
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
            boxShadow: Styles.cardShadows,
            color: isActive ? Styles.mainColor : Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          widget.size,
          style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontFamily: "SegoeUISemiBold"),
        ),
      ),
    );
  }
}
