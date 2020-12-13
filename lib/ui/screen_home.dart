import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/screen_product_info.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    productBloc.getHomeProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width / 2 - 40;
    return Scaffold(
      backgroundColor: Styles.subBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Styles.subBackgroundColor,
          brightness: Brightness.light,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Zarin Shop",
            style: TextStyle(fontSize: 18.0, fontFamily: "SegoeUIBold"),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Специальное предложение",
              style: TextStyle(fontFamily: "SegoeUIBold"),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: productBloc.productsOffers.stream,
                  builder: (context,
                      AsyncSnapshot<ApiResponse<List<Product>>> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.status != Status.COMPLETED)
                      return ListView.separated(
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        shrinkWrap: false,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => Container(
                          width: cardWidth,
                          height: cardWidth * 2,
                          child: Shimmer.fromColors(
                            baseColor: Styles.subBackgroundColor,
                            highlightColor: Styles.mainColor.withOpacity(0.5),
                            period: Duration(milliseconds: 2000),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Styles.subBackgroundColor,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      );

                    return ListView.separated(
                        separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsets.all(5),
                            ),
                        shrinkWrap: false,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: ProductInfo(snapshot.data.data[index],
                                      "offers" + snapshot.data.data[index].id),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade,
                                );
                              },
                              child: Container(
                                width: cardWidth,
                                height: cardWidth * 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Hero(
                                    tag: "offers" + snapshot.data.data[index].id,
                                    child: Image(
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(snapshot
                                              .data.data[index].firstImage ??
                                          ""),
                                      frameBuilder: (context, child, frame,
                                          wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        } else {
                                          return frame != null
                                              ? child
                                              : Shimmer.fromColors(
                                                  baseColor:
                                                      Styles.subBackgroundColor,
                                                  highlightColor: Styles
                                                      .mainColor
                                                      .withOpacity(0.5),
                                                  period: Duration(
                                                      milliseconds: 2000),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Styles
                                                            .subBackgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                  ),
                                                );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ));
                  }),
            ),
            Text(
              "Скидки",
              style: TextStyle(fontFamily: "SegoeUIBold"),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: productBloc.productsSales.stream,
                  builder: (context,
                      AsyncSnapshot<ApiResponse<List<Product>>> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.status != Status.COMPLETED)
                      return ListView.separated(
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        shrinkWrap: false,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => Container(
                          width: cardWidth,
                          height: cardWidth * 2,
                          child: Shimmer.fromColors(
                            baseColor: Styles.subBackgroundColor,
                            highlightColor: Styles.mainColor.withOpacity(0.5),
                            period: Duration(milliseconds: 2000),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Styles.subBackgroundColor,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      );

                    return ListView.separated(
                        separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsets.all(5),
                            ),
                        shrinkWrap: false,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: ProductInfo(snapshot.data.data[index],
                                      "sales" + snapshot.data.data[index].id),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade,
                                );
                              },
                              child: Container(
                                width: cardWidth,
                                height: cardWidth * 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Hero(
                                    tag: "sales"+snapshot.data.data[index].id,
                                    child: Image(
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(snapshot
                                              .data.data[index].firstImage ??
                                          ""),
                                      frameBuilder: (context, child, frame,
                                          wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        } else {
                                          return frame != null
                                              ? child
                                              : Shimmer.fromColors(
                                                  baseColor:
                                                      Styles.subBackgroundColor,
                                                  highlightColor: Styles
                                                      .mainColor
                                                      .withOpacity(0.5),
                                                  period: Duration(
                                                      milliseconds: 2000),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Styles
                                                            .subBackgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                  ),
                                                );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ));
                  }),
            )
          ],
        ),
      ),
      // body: StreamBuilder(
      //     stream: productBloc.categories.stream,
      //     builder:
      //         (context, AsyncSnapshot<ApiResponse<List<Category>>> snapshot) {
      //       if (snapshot.hasData) if (snapshot.data.status ==
      //               Status.COMPLETED &&
      //           snapshot.data.data?.length != 0)
      //         return CupertinoScrollbar(
      //           child: ListView.builder(
      //             padding: EdgeInsets.zero,
      //             physics: BouncingScrollPhysics(),
      //             itemCount: productBloc.categories.value.data.length,
      //             itemBuilder: (context, index) =>
      //                 CategoryCard(productBloc.categories.value.data[index]),
      //           ),
      //         );
      //       else
      //         return _error(snapshot.data.message, context);
      //       else
      //         return Container();
      //     }),
    );
  }
}
