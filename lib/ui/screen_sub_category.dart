import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/widgets/cart_icon.dart';
import 'package:Zarin/ui/widgets/product_card.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubCategoryScreen extends StatelessWidget {
  final Category category;

  const SubCategoryScreen({Key key, this.category}) : super(key: key);

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
            category.name,
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            GestureDetector(
              child: Container(
                  padding: EdgeInsets.only(right: 10.0), child: CartIcon()),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            category.subcategories.isNotEmpty
                ? Container(
                    height: 45,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0, top: 20.0),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: category.subcategories.length,
                      itemBuilder: (context, index) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Navigator.of(context).push(FadePageRoute(
                          fullscreenDialog: true,
                          builder: (context) => SubCategoryScreen(
                              category: category.subcategories[index]),
                        )),
                        child: Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Text(category.subcategories[index].name),
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
                          suffixIcon: Icon(Icons.search),
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
                              child: Text("Фильтр"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: Text("Сортировка"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: CupertinoScrollbar(
                          child: GridView.count(
                            childAspectRatio: 1 / 2,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 30.0,
                            padding: EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: List.generate(100, (index) {
                              return ProductCard();
                            }),
                          ),
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
