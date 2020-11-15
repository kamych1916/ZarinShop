import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/widgets/category_card.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  Widget _error(String message, BuildContext context) {
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
            onPressed: () {
              productBloc.getCategories(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build CategoriesScreen");

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
      body: StreamBuilder(
          stream: productBloc.categories.stream,
          builder:
              (context, AsyncSnapshot<ApiResponse<List<Category>>> snapshot) {
            if (snapshot.hasData) if (snapshot.data.status ==
                    Status.COMPLETED &&
                snapshot.data.data?.length != 0)
              return CupertinoScrollbar(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  itemCount: productBloc.categories.value.data.length,
                  itemBuilder: (context, index) =>
                      CategoryCard(productBloc.categories.value.data[index]),
                ),
              );
            else
              return _error(snapshot.data.message, context);
            else
              return Container();
          }),
    );
  }
}
