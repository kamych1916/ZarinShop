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
import 'package:Zarin/ui/widgets/sub_categories_list.dart';
import 'package:Zarin/utils/styles.dart';
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
  int currentSubCategoryId = -1;

  @override
  void initState() {
    productBloc.getProductsByCategoryId(widget.category.id, context);
    super.initState();
  }

  changeCurrentSubCategory(int index) {
    currentSubCategoryId = index;
    if (index == -1)
      productBloc.getProductsByCategoryId(widget.category.id, context);
  }

  refresh() => productBloc.getProductsByCategoryId(
      currentSubCategoryId == -1
          ? widget.category.id
          : widget.category.subcategories[currentSubCategoryId].id,
      context);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.backgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          centerTitle: true,
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
            widget.category.subcategories.isNotEmpty &&
                    widget.isSubCategoryShowing
                ? SubCategoriesList(widget.category, changeCurrentSubCategory)
                : Container(),
            Container(
                width: double.infinity,
                height: 0.5,
                color: Colors.grey.withOpacity(1)),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20.0),
                color: Styles.subBackgroundColor,
                child: Column(
                  children: [
                    SearchField(),
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
                                  boxShadow: Styles.cardShadows,
                                  borderRadius: BorderRadius.circular(10.0)),
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
                                    boxShadow: Styles.cardShadows,
                                    borderRadius: BorderRadius.circular(10.0)),
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

                            if (snapshot.data.data != null &&
                                snapshot.data.data.isEmpty)
                              return Padding(
                                padding: EdgeInsets.only(bottom: 50.0),
                                child: _searchError("Товары не найдены"),
                              );

                            return RefreshIndicator(
                              onRefresh: () {},
                              child: CupertinoScrollbar(
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

    textEditingController.addListener(() {
      if (textEditingController.text.length == 0 && isSearching) {
        setState(() => isSearching = false);
        productBloc.unSearch();
        return;
      }

      if (textEditingController.text.length != 0 && !isSearching) {
        setState(() => isSearching = true);
        productBloc.searchInit();
      }

      if (textEditingController.text.length > 3) {
        if (textEditingController.text != prevText) {
          prevText = textEditingController.text;
          productBloc.search(textEditingController.text);
        }
      }
    });

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
