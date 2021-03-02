import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/widgets/product_card.dart';
import 'package:Zarin/ui/widgets/product_card_loading.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Специальное предложение",
                style: TextStyle(fontFamily: "SegoeUIBold"),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height - kToolbarHeight) / 2,
              child: StreamBuilder(
                  stream: productBloc.productsOffers.stream,
                  builder: (context,
                      AsyncSnapshot<ApiResponse<List<Product>>> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.status != Status.COMPLETED)
                      return ListView.separated(
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        shrinkWrap: false,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => ProductCardLoading(),
                      );

                    return ListView.separated(
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      shrinkWrap: false,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) =>
                          ProductCard(snapshot.data.data[index], tag: "offers"),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Скидки",
                style: TextStyle(fontFamily: "SegoeUIBold"),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height - kToolbarHeight) / 2,
              child: StreamBuilder(
                  stream: productBloc.productsSales.stream,
                  builder: (context,
                      AsyncSnapshot<ApiResponse<List<Product>>> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.status != Status.COMPLETED)
                      return ListView.separated(
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        shrinkWrap: false,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => ProductCardLoading(),
                      );

                    return ListView.separated(
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      shrinkWrap: false,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) => ProductCard(
                        snapshot.data.data[index],
                        tag: "sales",
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
