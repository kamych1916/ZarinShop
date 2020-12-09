import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
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
