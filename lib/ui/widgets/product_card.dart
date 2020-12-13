import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/screen_product_info.dart';
import 'package:Zarin/ui/widgets/product_card_favorite_icon.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard(this.product, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (productBloc.searchFieldFocusNode.hasFocus) {
          await SystemChannels.textInput.invokeMethod('TextInput.hide');
          productBloc.searchFieldFocusNode.unfocus();
          await Future.delayed(Duration(milliseconds: 250));
        }
        pushNewScreen(
          context,
          screen: ProductInfo(product, product.id),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      },
      child: Container(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Hero(
                    tag: product.id,
                    child: Image(
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 3 - 15.0,
                      image: NetworkImage(product.firstImage ?? ""),
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        } else {
                          return frame != null
                              ? child
                              : Shimmer.fromColors(
                                  baseColor: Styles.subBackgroundColor,
                                  highlightColor:
                                      Styles.mainColor.withOpacity(0.5),
                                  period: Duration(milliseconds: 2000),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Styles.subBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height:
                                        MediaQuery.of(context).size.height /
                                                3 -
                                            15.0,
                                  ),
                                );
                        }
                      },
                    ),
                  ),
                ),
                ProductCardFavoriteIcon(
                  product,
                  key: ValueKey(product.id),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.totalPrice.floor().toString() + " сум",
                    style: TextStyle(
                        color: Styles.cardTextColor,
                        fontSize: 16.0,
                        fontFamily: "SegoeUISemiBold"),
                  ),
                  Text(product.id + " " + product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: "SegoeUIBold")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
