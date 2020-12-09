import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/ui/widgets/sizes.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

class FilterSheet extends StatefulWidget {
  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final BehaviorSubject<List<int>> sizesSubject =
      new BehaviorSubject<List<int>>()..sink.add([]);

  @override
  void dispose() {
    sizesSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            color: Colors.white),
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
            Text('Фильтр',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontFamily: "SegoeUIBold")),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            Text('Цвет',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontFamily: "SegoeUIBold")),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            ColorPicker(),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            Text('Цена',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontFamily: "SegoeUIBold")),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            ZarinRangeSlider(),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            Sizes(["XS", "S", "M", "L", "XL"], sizesSubject),
            Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            GestureDetector(
              onTap: Navigator.of(context).pop,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                decoration: BoxDecoration(
                    color: Styles.mainColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: Styles.cardShadows),
                child: Text(
                  "Применить",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "SegoeUISemiBold"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
            )
          ],
        ));
  }
}

class ColorPicker extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(AppBloc.colors.length,
          (index) => ColorPickerCircle(AppBloc.colors[index])),
    );
  }
}

class ColorPickerCircle extends StatefulWidget {
  final String color;

  const ColorPickerCircle(this.color, {Key key}) : super(key: key);

  @override
  _ColorPickerCircleState createState() => _ColorPickerCircleState();
}

class _ColorPickerCircleState extends State<ColorPickerCircle> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isActive = !isActive),
      child: Container(
        height: 32,
        width: 25,
        child: Stack(
          alignment: Alignment(0, 0.9),
          children: [
            AnimatedPositioned(
              bottom: isActive ? 25 : 15,
              duration: Duration(milliseconds: 250),
              child: Container(
                width: 5,
                height: 5,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Styles.mainColor,
                ),
              ),
            ),
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
                color: HexColor.fromHex(widget.color),
                shape: SuperellipseShape(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class ZarinRangeSlider extends StatefulWidget {
  @override
  _ZarinRangeSliderState createState() => _ZarinRangeSliderState();
}

class _ZarinRangeSliderState extends State<ZarinRangeSlider> {
  double min;
  double max;
  RangeValues _currentRangeValues;

  @override
  void initState() {
    if (productBloc.products.value == null ||
        productBloc.products.value.data == null ||
        productBloc.products.value.data.isEmpty) {
      min = 0;
      max = 50000;
    } else {
      min = productBloc.getProductsMinPrice();
      max = productBloc.getProductsMaxPrice();
    }
    _currentRangeValues = RangeValues(min, max);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      activeColor: Styles.mainColor,
      values: _currentRangeValues,
      min: min,
      max: max,
      divisions: 100,
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
        });
      },
    );
  }
}
