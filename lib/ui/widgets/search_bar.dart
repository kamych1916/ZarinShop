import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode focusNode;
  TextEditingController controller;

  bool searchState = false;
  bool searchStateDelayed = false;

  void focusNodeStateListener() {
    if (focusNode.hasFocus && !searchState)
      setState(() {
        searchState = true;
        Future.delayed(Duration(milliseconds: 500),
            () => setState(() => searchStateDelayed = true));
      });
    if (!focusNode.hasFocus && searchState)
      setState(() {
        searchState = false;
        searchStateDelayed = false;
      });
  }

  @override
  void initState() {
    focusNode = FocusNode();
    controller = TextEditingController();

    focusNode.addListener(focusNodeStateListener);

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
              TextFormField(
                focusNode: focusNode,
                controller: controller,
                cursorColor: Colors.black54,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                //onChanged: search.publish,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    decorationColor: Colors.white.withOpacity(0)),
                decoration: InputDecoration(
                  hintText: "Поиск",
                  contentPadding: EdgeInsets.only(left: 15, right: 30, top: 5),
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
                  focusNode.unfocus();
                  controller.clear();
                },
                child: Text("Отменить"))
            : Container()
      ],
    );
  }
}
