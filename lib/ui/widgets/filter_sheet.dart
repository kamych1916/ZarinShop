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

  List<int> activeColors = [];
  List<int> activeSizes = [];
  double minPrice, maxPrice;

  @override
  void initState() {
    if (productBloc.filter.colors != null)
      activeColors = productBloc.filter.colors;
    if (productBloc.filter.minPrice != null)
      minPrice = productBloc.filter.minPrice;
    if (productBloc.filter.maxPrice != null)
      maxPrice = productBloc.filter.maxPrice;
    if (productBloc.filter.sizes != null) {
      activeSizes = productBloc.filter.sizes;
      sizesSubject.sink.add(activeSizes);
    }

    sizesSubject.listen((value) {
      print(value);
      this.activeSizes = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    sizesSubject.close();
    super.dispose();
  }

  colorCallback(List<int> activeColors) => this.activeColors = activeColors;

  minValueCallback(double value) => this.minPrice = value;
  maxValueCallback(double value) => this.maxPrice = value;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            color: Styles.subBackgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                width: 25.0,
                height: 2.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Фильтр',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.0,
                        fontFamily: "SegoeUIBold")),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    productBloc.filter.clear();
                    productBloc.cancelFilter();
                    Navigator.of(context).pop();
                  },
                  child: Text('Сбросить',
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 15.0,
                          fontFamily: "SegoeUIBold")),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            Text('Цвет',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontFamily: "SegoeUIBold")),
            Padding(padding: EdgeInsets.symmetric(vertical: 2.5)),
            ColorPicker(activeColors, colorCallback),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            Text('Цена',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontFamily: "SegoeUIBold")),
            Padding(padding: EdgeInsets.symmetric(vertical: 2.5)),
            ZarinRangeSlider(
                minPrice, maxPrice, minValueCallback, maxValueCallback),
            Padding(padding: EdgeInsets.symmetric(vertical: 2.5)),
            Sizes(AppBloc.sizes, sizesSubject),
            Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            GestureDetector(
              onTap: () {
                productBloc.filter.colors = activeColors;
                productBloc.filter.minPrice = minPrice;
                productBloc.filter.maxPrice = maxPrice;
                productBloc.filter.sizes = activeSizes;
                Navigator.of(context).pop();
                productBloc.filterProducts();
              },
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
              padding: EdgeInsets.only(bottom: 10.0),
            )
          ],
        ));
  }
}

class ColorPicker extends StatefulWidget {
  final Function(List<int>) callback;
  final List<int> initColors;
  const ColorPicker(this.initColors, this.callback, {Key key})
      : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  List<int> activeColors = [];

  @override
  void initState() {
    if (widget.initColors != null) activeColors = widget.initColors;
    super.initState();
  }

  void colorTap(int index) {
    if (activeColors.contains(index))
      activeColors.remove(index);
    else
      activeColors.add(index);

    widget.callback(activeColors);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
          AppBloc.colors.length,
          (index) => ColorPickerCircle(AppBloc.colors[index], colorTap, index,
              activeColors.contains(index))),
    );
  }
}

class ColorPickerCircle extends StatefulWidget {
  final String color;
  final int index;
  final Function(int) callback;
  final bool isActive;

  const ColorPickerCircle(this.color, this.callback, this.index, this.isActive,
      {Key key})
      : super(key: key);

  @override
  _ColorPickerCircleState createState() => _ColorPickerCircleState();
}

class _ColorPickerCircleState extends State<ColorPickerCircle> {
  bool isActive;

  @override
  void initState() {
    isActive = widget.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callback(widget.index);
        setState(() => isActive = !isActive);
      },
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
  final double initMinPrice;
  final double initMaxPrice;
  final Function(double) minValueCallback;
  final Function(double) maxValueCallback;

  const ZarinRangeSlider(this.initMinPrice, this.initMaxPrice,
      this.minValueCallback, this.maxValueCallback,
      {Key key})
      : super(key: key);

  @override
  _ZarinRangeSliderState createState() => _ZarinRangeSliderState();
}

class _ZarinRangeSliderState extends State<ZarinRangeSlider> {
  double min;
  double max;
  RangeValues _currentRangeValues;

  @override
  void initState() {
    if (productBloc.minFilterPrice == null ||
        productBloc.maxFilterPrice == null) {
      min = 0;
      max = 50000;
    } else {
      min = productBloc.minFilterPrice;
      max = productBloc.maxFilterPrice;
    }

    double minTemp, maxTemp;

    if (widget.initMinPrice != null)
      minTemp = widget.initMinPrice;
    else
      minTemp = min;

    if (widget.initMaxPrice != null)
      maxTemp = widget.initMaxPrice;
    else
      maxTemp = max;

    _currentRangeValues = RangeValues(minTemp, maxTemp);

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
        if (values.start != _currentRangeValues.start)
          widget.minValueCallback(values.start);

        if (values.end != _currentRangeValues.end)
          widget.maxValueCallback(values.end);

        setState(() {
          _currentRangeValues = values;
        });
      },
    );
  }
}
