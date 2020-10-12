import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/models/category.dart';
import 'package:Zarin/models/product.dart';
import 'package:Zarin/resources/product_api_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _productApiProvider = ProductApiProvider();
  final _categoriesSubject = BehaviorSubject<ApiResponse<List<Category>>>();
  final _cartSubject = BehaviorSubject<ApiResponse<List<Product>>>();

  Stream<ApiResponse<List<Category>>> get categoriesStream =>
      _categoriesSubject.stream;

  Stream<ApiResponse<List<Product>>> get cartStream => _cartSubject.stream;

  List<Category> get categories => _categoriesSubject.value.data;
  List<Product> get cart => _cartSubject.value.data;

  init() async {
    await getCategories();
  }

  getCategories() async {
    ApiResponse<List<Category>> categoriesResponse =
        await _productApiProvider.getCategories();
    _categoriesSubject.sink.add(categoriesResponse);
  }

  void dispose() async {
    await _categoriesSubject.drain();
    _categoriesSubject.close();
    await _cartSubject.drain();
    _cartSubject.close();
  }
}

final ProductBloc productBloc = ProductBloc();
