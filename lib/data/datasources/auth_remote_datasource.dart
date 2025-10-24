import '../models/auth_request_model.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Abstract remote data source for authentication operations
abstract class AuthRemoteDataSource {
  /// Login with email and password
  Future<AuthenticationResponseModel> login(String email, String password);

  /// Login with Google OAuth
  Future<AuthenticationResponseModel> loginWithGoogle();

  /// Get current user info
  Future<UserModel> getMyInfo();

  /// Logout
  Future<void> logout();
}
