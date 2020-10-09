import 'package:connectivity/connectivity.dart';

Future<bool> checkInternetConnection() async {
  ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();

  return connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi;
}
