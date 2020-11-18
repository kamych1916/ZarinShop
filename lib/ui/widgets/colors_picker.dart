import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/ui/screen_product_info.dart';
import 'package:Zarin/ui/widgets/filter_sheet.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

class ColorsPicker extends StatelessWidget {
  final List<Map<String, dynamic>> linkedProducts;
  final String currentColor;

  ColorsPicker(this.linkedProducts, this.currentColor, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> colors = [];
    int activeIndex;

    for (String mainColor in AppBloc.colors) {
      if (mainColor == currentColor) activeIndex = colors.length;
      for (Map<String, dynamic> linkColor in linkedProducts) {
        if (mainColor == linkColor["color"]) colors.add(mainColor);
      }
    }

    return linkedProducts == null || linkedProducts.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.5),
              ),
              Text(
                "Цвет",
                style: TextStyle(fontFamily: "SegoeUIBold"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 20.0,
                  spacing: 10.0,
                  children: List.generate(colors.length, (index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (index != activeIndex) {
                          for (Map<String, dynamic> linkColor
                              in linkedProducts) {
                            if (colors[index] == linkColor["color"]) {
                              Product product = productBloc.products.value.data
                                  .firstWhere((element) =>
                                      element.id == linkColor["id"].toString());
                              Navigator.of(context)
                                  .pushReplacement(FadePageRoute(
                                builder: (context) =>
                                    ProductInfo(product, product.id),
                              ));
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 32,
                        width: 25,
                        child: Stack(
                          alignment: Alignment(0, 0.9),
                          children: [
                            index == activeIndex
                                ? Positioned(
                                    bottom: 25,
                                    child: Container(
                                      width: 5,
                                      height: 5,
                                      decoration: ShapeDecoration(
                                        shape: CircleBorder(),
                                        color: Styles.mainColor,
                                      ),
                                    ),
                                  )
                                : Container(),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: ShapeDecoration(
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    spreadRadius: 0,
                                    blurRadius: 1,
                                  )
                                ],
                                color: HexColor.fromHex(colors[index]),
                                shape: SuperellipseShape(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
  }
}
