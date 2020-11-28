import 'dart:async';

import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController controller;
  Debouncing throttlingSearch =
      Debouncing(duration: Duration(milliseconds: 500));

  bool searchState = false;
  bool searchStateDelayed = false;

  void focusNodeStateListener() {
    if (productBloc.searchFieldFocusNode.hasFocus && !searchState)
      setState(() {
        searchState = true;
        Future.delayed(Duration(milliseconds: 500),
            () => setState(() => searchStateDelayed = true));
      });
    if (!productBloc.searchFieldFocusNode.hasFocus && searchState)
      setState(() {
        searchState = false;
        searchStateDelayed = false;
      });
  }

  void scrollListener() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
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

  /// TODO: скафолд в streambuilder с ивентом на поиск. Если поле submit, то начинаем поиск. Если длинна больше 3, то начинаем поиск (но с редьюсом)

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedContainer(
          height: 30,
          width:
              MediaQuery.of(context).size.width - 32 - (searchState ? 90 : 0),
          duration: Duration(milliseconds: 500),
          child: Stack(
            alignment: Alignment(0.95, 0),
            children: [
              TextField(
                focusNode: productBloc.searchFieldFocusNode,
                controller: controller,
                cursorColor: Colors.black54,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value.length >= 3) {
                    throttlingSearch.debounce(() => productBloc.search(value));
                    if (!productBloc.searchEvent.value)
                      productBloc.searchEvent.publish(true);
                  }
                },
                onSubmitted: (value) {
                  productBloc.searchFieldFocusNode.requestFocus();

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
                  contentPadding: EdgeInsets.only(
                      left: 15, right: searchState ? 30 : 15, top: 5),
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
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => controller.clear(),
                      child: Icon(
                        Icons.close,
                        color: Styles.mainColor,
                        size: 16,
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
