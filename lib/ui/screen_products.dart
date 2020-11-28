import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/widgets/filter_sheet.dart';
import 'package:Zarin/ui/widgets/product_card.dart';
import 'package:Zarin/ui/widgets/product_card_loading.dart';
import 'package:Zarin/ui/widgets/sort_sheet.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  final Category category;
  final bool isSubCategoryShowing;

  const ProductsScreen(this.category,
      {Key key, this.isSubCategoryShowing = true})
      : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  static const _indicatorSize = 50.0;

  @override
  void initState() {
    productBloc.getProductsByCategoryId(widget.category.id, context);
    super.initState();
  }

  refresh() async =>
      await productBloc.getProductsByCategoryId(widget.category.id, context);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.subBackgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.translucent,
            child: Container(
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
          ),
          title: Text(
            widget.category.name,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 18),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                color: Styles.subBackgroundColor,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0)),
                                  ),
                                  context: context,
                                  builder: (context) => FilterSheet()),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15.0),
                                decoration: BoxDecoration(
                                    color: Styles.mainColor.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: Styles.cardShadows),
                                child: Text(
                                  "Фильтр",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "SegoeUISemiBold"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0)),
                                  ),
                                  context: context,
                                  builder: (context) => SortSheet()),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15.0),
                                decoration: BoxDecoration(
                                    color: Styles.mainColor.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: Styles.cardShadows),
                                child: Text(
                                  "Сортировка",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "SegoeUISemiBold"),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: StreamBuilder(
                          stream: productBloc.products.stream,
                          builder: (context,
                              AsyncSnapshot<ApiResponse<List<Product>>>
                                  snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.data.status == Status.LOADING)
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

                            return CustomRefreshIndicator(
                              offsetToArmed: _indicatorSize,
                              onRefresh: () async {
                                await Future.delayed(Duration(seconds: 1));
                                refresh();
                              },
                              child: CupertinoScrollbar(
                                child: GridView.builder(
                                  itemCount: snapshot.data.data.length,
                                  itemBuilder: (context, index) =>
                                      ProductCard(snapshot.data.data[index]),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1 / 2 + 0.025,
                                    mainAxisSpacing: 0.0,
                                    crossAxisSpacing: 10.0,
                                  ),
                                  padding: EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  physics: AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  shrinkWrap: true,
                                ),
                              ),
                              completeStateDuration: const Duration(seconds: 2),
                              builder: (
                                BuildContext context,
                                Widget child,
                                IndicatorController controller,
                              ) {
                                return Stack(
                                  children: <Widget>[
                                    AnimatedBuilder(
                                      animation: controller,
                                      builder:
                                          (BuildContext context, Widget _) {
                                        final containerHeight =
                                            controller.value * _indicatorSize;

                                        return controller.value < 0.6
                                            ? Container()
                                            : Container(
                                                alignment: Alignment.center,
                                                height: containerHeight,
                                                child: SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Styles.mainColor),
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                                    AnimatedBuilder(
                                      builder: (context, _) {
                                        return Transform.translate(
                                          offset: Offset(
                                              0.0,
                                              controller.value *
                                                      _indicatorSize +
                                                  controller.value * 20),
                                          child: child,
                                        );
                                      },
                                      animation: controller,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController textEditingController;
  FocusNode focusNode;
  bool isSearching = false;
  String prevText = "";

  @override
  void initState() {
    textEditingController = TextEditingController();

    // textEditingController.addListener(() {
    //   if (textEditingController.text.length == 0 && isSearching) {
    //     setState(() => isSearching = false);
    //     productBloc.unSearch();
    //     return;
    //   }

    //   if (textEditingController.text.length != 0 && !isSearching) {
    //     setState(() => isSearching = true);
    //     productBloc.searchInit();
    //   }

    //   if (textEditingController.text.length > 3) {
    //     if (textEditingController.text != prevText) {
    //       prevText = textEditingController.text;
    //       productBloc.search(textEditingController.text);
    //     }
    //   }
    // });

    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
          boxShadow: Styles.cardShadows,
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: textEditingController,
        focusNode: focusNode,
        cursorColor: Colors.black87,
        maxLines: 1,
        style: TextStyle(
            decoration: TextDecoration.none,
            decorationColor: Colors.white.withOpacity(0)),
        decoration: InputDecoration(
          prefixIcon:
              Icon(AppIcons.magnifier, size: 16.0, color: Colors.black87),
          suffixIcon: isSearching
              ? Icon(Icons.close, size: 16, color: Colors.black87)
              : null,
          contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
          filled: true,
          fillColor: Colors.white,
          hintText: "Поиск",
          hintMaxLines: 1,
          hintStyle: TextStyle(
              color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 0, style: BorderStyle.none)),
        ),
      ),
    );
  }
}
