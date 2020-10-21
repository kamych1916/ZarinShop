import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc {
  SharedPreferences prefs;

  init(context) async {
    prefs = await SharedPreferences.getInstance();
    bool auth = userBloc.getUser();
    auth ? productBloc.getLocalCart() : productBloc.getCart();
    productBloc.getFavorites();
    await productBloc.getCategories(context);
  }
}

final AppBloc appBloc = AppBloc();
