import 'package:Zarin/ui/widgets/products_list.dart';
import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/category.dart';
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
  @override
  void initState() {
    productBloc.getProductsByCategoryId(widget.category.id, context);
    super.initState();
  }

  refresh() async =>
      await productBloc.getProductsByCategoryId(widget.category.id, context);

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
                  color: Colors.black87,
                  fontFamily: "SegoeUIBold",
                  fontSize: 18),
            ),
          ),
        ),
        body: ProductsList(
          refresh: refresh,
        ));
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
