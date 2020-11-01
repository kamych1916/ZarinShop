import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/screen_products.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class SubCategoryCard extends StatelessWidget {
  final Category category;

  const SubCategoryCard(this.category, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(FadePageRoute(
          builder: (context) => ProductsScreen(category),
        ));
      },
      child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width / 4 - 20,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: productBloc.categories[0].img),
              borderRadius: BorderRadius.circular(10),
              boxShadow: Styles.cardShadows),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 8.0, left: 25.0, right: 25.0),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                category.name,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "SegoeUISemiBold",
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          )),
    );
  }
}
