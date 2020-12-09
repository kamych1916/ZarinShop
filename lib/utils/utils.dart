import 'dart:async';
import 'package:connectivity/connectivity.dart';

class Utils {
  static Future<bool> checkInternetConnection() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  // static Future<ApiResponse> onException(exception) async {
  //   bool internetStatus = await Utils.checkInternetConnection();

  //   return internetStatus
  //       ? exception == SocketException || exception == TimeoutException
  //           ? ApiResponse.error('Сервис недоступен')
  //           : ApiResponse.error('Возникла внутренняя ошибка')
  //       : ApiResponse.error('Отсутствует интернет-соединение');
  // }
}
