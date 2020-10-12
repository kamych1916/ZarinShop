import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/ui/widgets/cart_icon.dart';
import 'package:Zarin/ui/widgets/category_card.dart';
import 'package:Zarin/ui/widgets/drawer.dart';
import 'package:Zarin/ui/widgets/favorite_icon.dart';
import 'package:Zarin/ui/widgets/slider_menu.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  Widget _error(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            size: 30.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          FlatButton(
            child: Text(
              "Повторить попытку",
              style: TextStyle(color: Colors.blue[600], fontSize: 12.0),
            ),
            onPressed: () {
              productBloc.getCategories();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
        appBarColor: Styles.backgroundColor,
        key: _key,
        sliderOpen: SliderOpen.LEFT_TO_RIGHT,
        sliderMenuOpenOffset: MediaQuery.of(context).size.width - 100,
        appBarHeight: 40,
        sliderMenu: ZarinDrawer(sliderKey: _key),
        drawerIconColor: Colors.black87,
        drawerIconSize: 22.0,
        isShadow: false,
        sliderAnimationTimeInMilliseconds: 500,
        trailing: Container(
          padding: EdgeInsets.only(right: 10.0),
          child: Row(
            children: [
              FavoriteIcon(),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
              CartIcon(),
            ],
          ),
        ),
        sliderMain: Container(
          color: Styles.backgroundColor,
          child: StreamBuilder(
              stream: productBloc.categoriesStream,
              builder: (context,
                  AsyncSnapshot<ApiResponse<List<Category>>> snapshot) {
                if (snapshot.hasData) if (snapshot.data.status ==
                        Status.COMPLETED &&
                    snapshot.data.data?.length != 0)
                  return CupertinoScrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      itemCount: productBloc.categories.length,
                      itemBuilder: (context, index) =>
                          CategoryCard(productBloc.categories[index]),
                    ),
                  );
                else
                  return _error(snapshot.data.message);
                else
                  return Container();
              }),
        ),
      ),
    );
  }
}
