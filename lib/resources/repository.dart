import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/resources/user_api_provider.dart';

class Repository {
  UserApiProvider _userApiProvider = UserApiProvider();

  Future<ApiResponse<bool>> authenticateUser(String email, String password) =>
      _userApiProvider.authenticateUser(email, password);
}
