import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class SortSheet extends StatelessWidget {
  final List<SortType> sortTypes = productBloc.sort.keys.toList();
  final List<String> sortNames = productBloc.sort.values.toList();

  Widget sortElement(
          SortType sortType, String sortName, BuildContext context) =>
      GestureDetector(
        onTap: () {
          if (productBloc.currentSort == sortType) return;
          productBloc.currentSort = sortType;
          productBloc.sortProducts();
          Navigator.of(context).pop();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          color: Styles.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(sortName)),
              productBloc.currentSort == sortType
                  ? Icon(
                      Icons.check,
                      size: 20.0,
                    )
                  : Container()
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            color: Styles.backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                width: 25.0,
                height: 2.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
              ),
            ),
            Text('Сортировка по:',
                style: TextStyle(color: Colors.black87, fontSize: 16.0)),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                shrinkWrap: true,
                itemCount: sortTypes.length,
                itemBuilder: (context, index) =>
                    sortElement(sortTypes[index], sortNames[index], context)),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
            )
          ],
        ));
  }
}