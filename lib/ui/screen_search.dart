import 'dart:math';

import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/screen_products.dart';
import 'package:Zarin/ui/screen_sub_categories.dart';
import 'package:Zarin/ui/widgets/products_list.dart';
import 'package:Zarin/ui/widgets/search_bar.dart';
import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<int> randomLoadingLinesSize;

  @override
  void initState() {
    var random = new Random();
    randomLoadingLinesSize = List.generate(10, (index) => random.nextInt(100));

    productBloc.getCategories();

    super.initState();
  }

  refreshCategories() async => await productBloc.getCategories();

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
            onPressed: refreshCategories,
          ),
        ],
      ),
    );
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
          title: SearchBar()),
      body: StreamBuilder(
          stream: productBloc.searchEvent.stream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData || !snapshot.data)
              return Container(
                margin: EdgeInsets.only(top: 20.0),
                child: StreamBuilder(
                    stream: productBloc.categories.stream,
                    builder: (context,
                        AsyncSnapshot<ApiResponse<List<Category>>> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.data.status == Status.LOADING) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(),
                              padding: EdgeInsets.zero,
                              physics: BouncingScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (context, index) => Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7.5, horizontal: 5.0),
                                    margin: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                randomLoadingLinesSize[index]),
                                    child: Shimmer.fromColors(
                                      baseColor: Styles.subBackgroundColor,
                                      highlightColor:
                                          Styles.mainColor.withOpacity(0.5),
                                      period: Duration(milliseconds: 2000),
                                      child: Container(
                                        height: 15,
                                        decoration: BoxDecoration(
                                            color: Styles.subBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )),
                        );
                      }

                      if (snapshot.data.status == Status.ERROR)
                        return _error(snapshot.data.message);

                      if (snapshot.data.status == Status.COMPLETED)
                        return CupertinoScrollbar(
                            child: Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(),
                              padding: EdgeInsets.zero,
                              itemCount: snapshot.data.data.length,
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () => snapshot.data.data[index]
                                                    .subcategories !=
                                                null &&
                                            snapshot.data.data[index]
                                                .subcategories.isNotEmpty
                                        ? pushNewScreen(
                                            context,
                                            screen: SubCategoriesScreen(
                                                snapshot.data.data[index]),
                                            withNavBar: true,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.fade,
                                          )
                                        : pushNewScreen(
                                            context,
                                            screen: ProductsScreen(
                                                snapshot.data.data[index]),
                                            withNavBar: true,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.fade,
                                          ),
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                snapshot.data.data[index].name,
                                                style: TextStyle(
                                                    fontFamily:
                                                        "SegoeUISemiBold",
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: snapshot.data.data[index]
                                                        .count !=
                                                    null
                                                ? Text(
                                                    snapshot
                                                        .data.data[index].count
                                                        .toString(),
                                                  )
                                                : Container(),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 10,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                        ));

                      return Container();
                    }),
              );

            return ProductsList();
          }),
    );
  }
}
