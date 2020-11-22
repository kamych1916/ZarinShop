import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/event.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/widgets/product_card.dart';
import 'package:Zarin/ui/widgets/product_card_loading.dart';
import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Event<String> search = Event();
  final ScrollController controller = ScrollController();
  final FocusNode focusNode = FocusNode();

  scrollListener() {
    focusNode.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void initState() {
    focusNode.addListener(() => focusNode.hasFocus
        ? controller.addListener(scrollListener)
        : controller.removeListener(scrollListener));
    search.listen((event) {
      productBloc.search(event);
    });
    super.initState();
  }

  refresh() async => await productBloc.search(search.value);

  Widget _error(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            AppIcons.warning,
            size: 30.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontFamily: "SegoeUI"),
          ),
          FlatButton(
            child: Text(
              "Повторить попытку",
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 12.0,
                  fontFamily: "SegoeUISemiBold"),
            ),
            onPressed: () => refresh(),
          ),
        ],
      ),
    );
  }

  Widget _searchError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            AppIcons.warning,
            size: 30.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontFamily: "SegoeUI"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.subBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Styles.subBackgroundColor,
        iconTheme: new IconThemeData(color: Colors.black87),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 30,
          child: TextFormField(
              focusNode: focusNode,
              cursorColor: Colors.black54,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: search.publish,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  decorationColor: Colors.white.withOpacity(0)),
              decoration: InputDecoration(
                hintText: "Поиск",
                contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
                filled: true,
                fillColor: Colors.white,
                hintMaxLines: 1,
                hintStyle: TextStyle(
                    color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none)),
              )),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: StreamBuilder(
          stream: productBloc.searchProducts.stream,
          builder:
              (context, AsyncSnapshot<ApiResponse<List<Product>>> snapshot) {
            if (!snapshot.hasData || snapshot.data.status == Status.LOADING)
              return CupertinoScrollbar(
                child: GridView.count(
                  childAspectRatio: 1 / 2 + 0.025,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 10.0,
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: List.generate(6, (index) {
                    return ProductCardLoading();
                  }),
                ),
              );

            if (snapshot.data.status == Status.ERROR)
              return Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: _error(snapshot.data.message),
              );

            if (snapshot.data.data != null && snapshot.data.data.isEmpty)
              return Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: _searchError("Товары не найдены"),
              );

            return CupertinoScrollbar(
              child: GridView.count(
                controller: controller,
                childAspectRatio: 1 / 2 + 0.025,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 10.0,
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(snapshot.data.data.length, (index) {
                  return ProductCard(snapshot.data.data[index]);
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}
