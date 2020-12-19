import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/models/product.dart';

class Filter {
  double minPrice, maxPrice;
  List<int> colors;
  List<int> sizes;
  bool isSet = false;

  Filter({this.minPrice, this.maxPrice, this.colors, this.sizes});

  clear() {
    isSet = false;
    minPrice = null;
    maxPrice = null;
    colors = null;
    sizes = null;
  }

  filter(List<Product> products) {
    if (products == null || products.isEmpty) return;
  }

  bool check(Product product) {
    if (colors != null && colors.isNotEmpty) {
      bool colorBool = false;
      for (int colorIndex in colors) {
        if (AppBloc.colors[colorIndex] == product.color) colorBool = true;
      }
      if (!colorBool) return false;
    }

    if (sizes != null && sizes.isNotEmpty) {
      bool sizeBool = false;
      List<String> productSizes =
          product.sizes.map((e) => e["size"] as String).toList();
      for (int sizeIndex in sizes) {
        if (productSizes.contains(AppBloc.sizes[sizeIndex])) sizeBool = true;
      }

      if (!sizeBool) return false;
    }

    if (minPrice != null) {
      if (product.totalPrice < minPrice) return false;
    }

    if (maxPrice != null) {
      if (product.totalPrice > maxPrice) return false;
    }

    return true;
  }
}
