import '../models/auth_request_model.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/verify_otp_request_model.dart';
import '../models/verify_otp_response_model.dart';

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

  /// Register new user
  Future<RegisterResponseModel> register(String username, String email, String password);

  /// Verify email OTP
  Future<VerifyOTPResponseModel> verifyEmailOTP(String email, int otp);

  /// Resend verification code
  Future<void> resendVerificationCode(String email);
}
