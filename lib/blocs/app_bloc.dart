import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc {
  SharedPreferences prefs;
  FlutterSecureStorage storage;

  init(context) async {
    prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    storage = new FlutterSecureStorage();
    bool auth = await userBloc.getUser();
    auth ? productBloc.getUserCartID() : productBloc.getLocalCartID();
    productBloc.getFavoritesIDFromLocal();
    await productBloc.getCategories(context);
  }
}

final AppBloc appBloc = AppBloc();
