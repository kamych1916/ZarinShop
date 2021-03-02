import 'dart:math';

import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/widgets/filter_sheet.dart';
import 'package:Zarin/ui/widgets/product_card.dart';
import 'package:Zarin/ui/widgets/product_card_loading.dart';
import 'package:Zarin/ui/widgets/sort_sheet.dart';
import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductsList extends StatelessWidget {
  static const _indicatorSize = 50.0;
  final Function refresh;

  const ProductsList({Key key, this.refresh}) : super(key: key);

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
          refresh != null
              ? FlatButton(
                  child: Text(
                    "Повторить попытку",
                    style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 12.0,
                        fontFamily: "SegoeUISemiBold"),
                  ),
                  onPressed: refresh,
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _searchError(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontFamily: "SegoeUI"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = size.width / 2 - 40;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      color: Styles.subBackgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (productBloc.searchFieldFocusNode.hasFocus) {
                        await SystemChannels.textInput
                            .invokeMethod('TextInput.hide');
                        productBloc.searchFieldFocusNode.unfocus();
                        await Future.delayed(Duration(milliseconds: 250));
                      }
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0)),
                          ),
                          context: context,
                          builder: (context) => FilterSheet());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                          color: Styles.mainColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: Styles.cardShadows),
                      child: Text(
                        "Фильтр",
                        style: TextStyle(
                            color: Colors.white, fontFamily: "SegoeUISemiBold"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (productBloc.searchFieldFocusNode.hasFocus) {
                        await SystemChannels.textInput
                            .invokeMethod('TextInput.hide');
                        productBloc.searchFieldFocusNode.unfocus();
                        await Future.delayed(Duration(milliseconds: 250));
                      }
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0)),
                          ),
                          context: context,
                          builder: (context) => SortSheet());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                          color: Styles.mainColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: Styles.cardShadows),
                      child: Text(
                        "Сортировка",
                        style: TextStyle(
                            color: Colors.white, fontFamily: "SegoeUISemiBold"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: StreamBuilder(
                stream: productBloc.products.stream,
                builder: (context,
                    AsyncSnapshot<ApiResponse<List<Product>>> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data.status == Status.LOADING)
                    return CupertinoScrollbar(
                      child: GridView.count(
                        childAspectRatio: (itemWidth / itemHeight),
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing: 10.0,
                        padding: EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: List.generate(6, (index) {
                          return ProductCardLoading();
                        }),
                      ),
                    );

                  if (snapshot.data.status == Status.ERROR)
                    return Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: _error(snapshot.data.message),
                    );

                  if (snapshot.data.data.isEmpty)
                    return Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: _searchError("Товары не найдены"),
                    );

                  return CustomRefreshIndicator(
                    offsetToArmed: _indicatorSize,
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));
                      refresh();
                    },
                    child: CupertinoScrollbar(
                      child: GridView.builder(
                        controller: productBloc.productsListScrollController,
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) =>
                            ProductCard(snapshot.data.data[index]),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (itemWidth + 10) / itemHeight,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 10.0,
                        ),
                        padding: EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        physics: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        shrinkWrap: true,
                      ),
                    ),
                    completeStateDuration: const Duration(seconds: 2),
                    builder: (
                      BuildContext context,
                      Widget child,
                      IndicatorController controller,
                    ) {
                      return Stack(
                        children: <Widget>[
                          AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, Widget _) {
                              final containerHeight =
                                  controller.value * _indicatorSize;

                              return controller.value < 0.6
                                  ? Container()
                                  : Container(
                                      alignment: Alignment.center,
                                      height: containerHeight,
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation(
                                              Styles.mainColor),
                                        ),
                                      ),
                                    );
                            },
                          ),
                          AnimatedBuilder(
                            builder: (context, _) {
                              return Transform.translate(
                                offset: Offset(
                                    0.0,
                                    controller.value * _indicatorSize +
                                        controller.value * 20),
                                child: child,
                              );
                            },
                            animation: controller,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
