import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class SubCategoriesList extends StatefulWidget {
  final Category category;
  final Function(int) callback;

  const SubCategoriesList(this.category, this.callback, {Key key})
      : super(key: key);

  @override
  _SubCategoriesListState createState() => _SubCategoriesListState();
}

class _SubCategoriesListState extends State<SubCategoriesList> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = -1;
    super.initState();
  }

  changeCategory(int index) {
    if (currentIndex == index) {
      setState(() => currentIndex = -1);
      widget.callback(currentIndex);
    } else {
      setState(() => currentIndex = index);
      widget.callback(currentIndex);
      productBloc.getProductsByCategoryId(
          widget.category.subcategories[index].id, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(bottom: 5.0),
      alignment: Alignment.topLeft,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 10.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.category.subcategories.length,
        itemBuilder: (context, index) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => changeCategory(index),
          child: Container(
            decoration: BoxDecoration(
                color: currentIndex == index ? Styles.mainColor : Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: Styles.cardShadows),
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            padding: EdgeInsets.only(bottom: 2.0, left: 20.0, right: 20.0),
            child: Center(
              child: Text(
                widget.category.subcategories[index].name,
                style: TextStyle(fontFamily: "SegoeUI", fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
