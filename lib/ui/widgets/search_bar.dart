import 'dart:async';

import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController controller;
  Debouncing debouncingSearch =
      Debouncing(duration: Duration(milliseconds: 500));

  Throttling throttlingKeyboard =
      Throttling(duration: Duration(milliseconds: 500));

  bool searchState = false;
  bool searchStateDelayed = false;

  void focusNodeStateListener() {
    if (productBloc.searchFieldFocusNode.hasFocus && !searchState)
      setState(() {
        searchState = true;
        Future.delayed(Duration(milliseconds: 300),
            () => setState(() => searchStateDelayed = true));
      });
    if (!productBloc.searchFieldFocusNode.hasFocus && searchState)
      setState(() {
        searchState = false;
        searchStateDelayed = false;
      });
  }

  void scrollListener() {
    throttlingKeyboard.throttle(() {
      productBloc.searchFieldFocusNode.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  @override
  void initState() {
    controller = TextEditingController();

    productBloc.searchFieldFocusNode.addListener(() => productBloc
            .searchFieldFocusNode.hasFocus
        ? productBloc.productsListScrollController.addListener(scrollListener)
        : productBloc.productsListScrollController
            .removeListener(scrollListener));

    productBloc.searchFieldFocusNode.addListener(focusNodeStateListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedContainer(
          height: 30,
          width:
              MediaQuery.of(context).size.width - 32 - (searchState ? 90 : 0),
          duration: Duration(milliseconds: 250),
          child: Stack(
            children: [
              TextField(
                focusNode: productBloc.searchFieldFocusNode,
                controller: controller,
                cursorColor: Colors.black54,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value.length >= 3) {
                    debouncingSearch.debounce(() => productBloc.search(value));
                    if (!productBloc.searchEvent.value)
                      productBloc.searchEvent.publish(true);
                  }
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    productBloc.search(value);
                    productBloc.searchEvent.publish(true);
                  }
                },
                style: TextStyle(
                    decoration: TextDecoration.none,
                    decorationColor: Colors.white.withOpacity(0)),
                decoration: InputDecoration(
                  hintText: "Поиск",
                  contentPadding: EdgeInsets.only(left: 30, right: 30, top: 5),
                  filled: true,
                  fillColor: Colors.white,
                  hintMaxLines: 1,
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none)),
                ),
              ),
              searchStateDelayed
                  ? Align(
                      alignment: Alignment(0.95, 0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => controller.clear(),
                        child: Icon(
                          Icons.close,
                          color: Styles.mainColor,
                          size: 16,
                        ),
                      ),
                    )
                  : Container(),
              !searchState
                  ? Align(
                      alignment: Alignment(-0.95, 0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => controller.clear(),
                        child: Icon(
                          AppIcons.magnifier,
                          color: Styles.mainColor,
                          size: 16,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        searchStateDelayed
            ? GestureDetector(
                onTap: () {
                  productBloc.searchFieldFocusNode.unfocus();
                  controller.clear();
                  productBloc.searchEvent.publish(false);
                },
                child: Text(
                  "Отменить",
                  style: TextStyle(fontFamily: "SegoeUISemiBold", fontSize: 16),
                ))
            : Container()
      ],
    );
  }
}

class Debouncing {
  Duration _duration;
  Duration get duration => this._duration;
  set duration(Duration value) {
    assert(duration is Duration && !duration.isNegative);
    this._duration = value;
  }

  Timer _waiter;
  // ignore: unused_field
  bool _isReady = true;
  bool get isReady => isReady;
  // ignore: close_sinks
  StreamController<dynamic> _resultSC =
      new StreamController<dynamic>.broadcast();
  // ignore: close_sinks
  final StreamController<bool> _stateSC =
      new StreamController<bool>.broadcast();

  Debouncing({Duration duration = const Duration(seconds: 1)})
      : assert(duration is Duration && !duration.isNegative),
        this._duration = duration ?? Duration(seconds: 1) {
    this._stateSC.sink.add(true);
  }

  Future<dynamic> debounce(Function func) async {
    if (this._waiter?.isActive ?? false) {
      this._waiter?.cancel();
      this._resultSC.sink.add(null);
    }
    this._isReady = false;
    this._stateSC.sink.add(false);
    this._waiter = Timer(this._duration, () {
      this._isReady = true;
      this._stateSC.sink.add(true);
      this._resultSC.sink.add(Function.apply(func, []));
    });
    return this._resultSC.stream.first;
  }

  StreamSubscription<bool> listen(Function(bool) onData) =>
      this._stateSC.stream.listen(onData);

  dispose() {
    this._resultSC.close();
    this._stateSC.close();
  }
}

class Throttling {
  Duration _duration;
  Duration get duration => this._duration;
  set duration(Duration value) {
    assert(duration is Duration && !duration.isNegative);
    this._duration = value;
  }

  bool _isReady = true;
  bool get isReady => isReady;
  Future<void> get _waiter => Future.delayed(this._duration);
  // ignore: close_sinks
  final StreamController<bool> _stateSC =
      new StreamController<bool>.broadcast();

  Throttling({Duration duration = const Duration(seconds: 1)})
      : assert(duration is Duration && !duration.isNegative),
        this._duration = duration ?? Duration(seconds: 1) {
    this._stateSC.sink.add(true);
  }

  dynamic throttle(Function func) {
    if (!this._isReady) return null;
    this._stateSC.sink.add(false);
    this._isReady = false;
    _waiter
      ..then((_) {
        this._isReady = true;
        this._stateSC.sink.add(true);
      });
    return Function.apply(func, []);
  }

  StreamSubscription<bool> listen(Function(bool) onData) =>
      this._stateSC.stream.listen(onData);

  dispose() {
    this._stateSC.close();
  }
}
