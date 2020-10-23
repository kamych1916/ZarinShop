import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/widgets/cart_icon.dart';
import 'package:Zarin/ui/widgets/favorite_icon.dart';
import 'package:Zarin/ui/widgets/product_card.dart';
import 'package:Zarin/ui/widgets/product_card_loading.dart';
import 'package:Zarin/ui/widgets/sort_sheet.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubCategoryScreen extends StatefulWidget {
  final Category category;
  final Function callback;

  const SubCategoryScreen({Key key, this.category, this.callback})
      : super(key: key);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  void initState() {
    productBloc.getProductsByCategoryId(widget.category.id, context);
    super.initState();
  }

  refresh() => productBloc.getProductsByCategoryId(widget.category.id, context);

  Widget _error(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.error_outline,
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
          title: Text(
            widget.category.name,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 18),
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Row(
                children: [
                  FavoriteIcon(),
                  CartIcon(),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            widget.category.subcategories.isNotEmpty
                ? Container(
                    height: 35,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0, top: 8.0),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: widget.category.subcategories.length,
                      itemBuilder: (context, index) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          await Navigator.of(context).push(FadePageRoute(
                            fullscreenDialog: true,
                            builder: (context) => SubCategoryScreen(
                                category: widget.category.subcategories[index]),
                          ));
                          refresh();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Text(
                            widget.category.subcategories[index].name,
                            style:
                                TextStyle(fontFamily: "SegoeUI", fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20.0),
                color: Styles.subBackgroundColor,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      width: double.infinity,
                      height: 30,
                      child: TextField(
                        cursorColor: Colors.black87,
                        maxLines: 1,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            decorationColor: Colors.white.withOpacity(0)),
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            AppIcons.magnifier,
                            size: 16.0,
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 15, right: 15, top: 5),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Поиск",
                          hintMaxLines: 1,
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(134, 145, 173, 1),
                              fontSize: 14.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: Text(
                                "Фильтр",
                                style: TextStyle(fontFamily: "SegoeUI"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25.0)),
                                child: Text(
                                  "Сортировка",
                                  style: TextStyle(fontFamily: "SegoeUI"),
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
                          stream: productBloc.productsStream,
                          builder: (context,
                              AsyncSnapshot<ApiResponse<List<Product>>>
                                  snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.data.status == Status.LOADING)
                              return CupertinoScrollbar(
                                child: GridView.count(
                                  childAspectRatio: 1 / 2,
                                  mainAxisSpacing: 0.0,
                                  crossAxisSpacing: 30.0,
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
                            return CupertinoScrollbar(
                              child: GridView.count(
                                childAspectRatio: 1 / 2,
                                mainAxisSpacing: 0.0,
                                crossAxisSpacing: 30.0,
                                padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                ),
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                children: List.generate(
                                    productBloc.products.length, (index) {
                                  return ProductCard(
                                      productBloc.products[index]);
                                }),
                              ),
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
