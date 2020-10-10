import 'package:Zarin/models/api_response_model.dart';
import 'package:Zarin/resources/user_api_provider.dart';

class Repository {
  UserApiProvider _userApiProvider = UserApiProvider();

  Future<ApiResponse<bool>> signIn(String email, String password) =>
      _userApiProvider.signIn(email, password);

  Future<ApiResponse<bool>> resetPassword(String email) =>
      _userApiProvider.resetPassword(email);

  Future<ApiResponse<bool>> signUp(
          String email, String password, firstName, lastName) =>
      _userApiProvider.signUp(email, password, firstName, lastName);
}
