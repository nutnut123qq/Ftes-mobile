import 'package:ftes/core/network/api_client.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/error/exceptions.dart';
import '../models/auth_request_model.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/verify_otp_request_model.dart';
import '../models/verify_otp_response_model.dart';
import '../models/forgot_password_request_model.dart' as forgot_password_req;
import '../models/verify_otp_for_password_response_model.dart';
import '../models/reset_password_request_model.dart';
import 'auth_remote_datasource.dart';

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<AuthenticationResponseModel> login(String email, String password) async {
    try {
      print('🔐 Attempting login to: ${AppConstants.baseUrl}${AppConstants.loginEndpoint}');
      print('📧 Email: $email');
      
      final requestBody = AuthenticationRequestModel(credential: email, password: password).toJson();
      print('📤 Request body: $requestBody');
      
      final response = await _apiClient.post(AppConstants.loginEndpoint, data: requestBody);
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        // API response format: { "success": true, "result": { "accessToken": "...", "refreshToken": "...", ... } }
        final result = response.data['result'];
        if (result != null) {
          return AuthenticationResponseModel.fromJson(result);
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('❌ Login error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthenticationResponseModel> loginWithGoogle(String authCode, {bool isAdmin = false}) async {
    try {
      print('🔐 Attempting Google OAuth to: ${AppConstants.baseUrl}${AppConstants.googleAuthEndpoint}');
      print('🔑 Auth code: ${authCode.substring(0, 20)}...');
      
      final response = await _apiClient.post(
        AppConstants.googleAuthEndpoint,
        queryParameters: {
          'code': authCode,
          'isAdmin': isAdmin.toString(),
        },
      );
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null) {
          return AuthenticationResponseModel.fromJson(result);
        } else {
          throw ServerException('Invalid response format');
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 'Google login failed');
      }
    } catch (e) {
      print('❌ Google login error: $e');
      throw ServerException(e.toString());
    }
  }


  @override
  Future<UserModel> getMyInfo() async {
    try {
      final response = await _apiClient.get(AppConstants.myInfoEndpoint);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['result']);
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to get user info');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(AppConstants.logoutEndpoint);
    } catch (e) {
      // Log error but don't rethrow, as local cleanup is more important
      print('Logout remote error: $e');
    }
  }

  @override
  Future<RegisterResponseModel> register(String username, String email, String password) async {
    try {
      print('📝 Attempting register to: ${AppConstants.baseUrl}${AppConstants.registerEndpoint}');
      print('👤 Username: $username');
      print('📧 Email: $email');
      
      final requestBody = RegisterRequestModel(
        username: username,
        email: email,
        password: password,
      ).toJson();
      print('📤 Request body: $requestBody');
      
      final response = await _apiClient.post(AppConstants.registerEndpoint, data: requestBody);
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('❌ Register error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<VerifyOTPResponseModel> verifyEmailOTP(String email, int otp) async {
    try {
      print('🔐 Attempting verify OTP to: ${AppConstants.baseUrl}${AppConstants.verifyEmailCodeEndpoint}');
      print('📧 Email: $email');
      print('🔢 OTP: $otp');
      
      final requestBody = VerifyOTPRequestModel(email: email, otp: otp).toJson();
      print('📤 Request body: $requestBody');
      
      final response = await _apiClient.post(AppConstants.verifyEmailCodeEndpoint, data: requestBody);
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        return VerifyOTPResponseModel.fromJson(response.data);
      } else {
        throw ServerException(response.data['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      print('❌ Verify OTP error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resendVerificationCode(String email) async {
    try {
      print('📧 Attempting resend code to: ${AppConstants.baseUrl}${AppConstants.resendVerifyCodeEndpoint}');
      print('📧 Email: $email');
      
      final requestBody = {'email': email};
      print('📤 Request body: $requestBody');
      
      final response = await _apiClient.post(AppConstants.resendVerifyCodeEndpoint, data: requestBody);
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode != 200) {
        throw ServerException(response.data['message'] ?? 'Resend code failed');
      }
    } catch (e) {
      print('❌ Resend code error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendForgotPasswordEmail(String email) async {
    try {
      print('🔐 Attempting send forgot password email to: ${AppConstants.baseUrl}${AppConstants.sendForgotPasswordEmailEndpoint}');
      print('📧 Email: $email');

      final requestBody = forgot_password_req.ForgotPasswordRequestModel(email: email).toJson();
      print('📤 Request body: $requestBody');

      final response = await _apiClient.post(AppConstants.sendForgotPasswordEmailEndpoint, data: requestBody);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ Forgot password email sent successfully');
        return;
      } else {
        throw ServerException(response.data['message'] ?? 'Send forgot password email failed');
      }
    } catch (e) {
      print('❌ Send forgot password email error: $e');
      if (e.toString().contains('401')) {
        throw ServerException('API server requires authentication for forgot password endpoint');
      } else if (e.toString().contains('NetworkException')) {
        throw ServerException('Network error: Please check your internet connection');
      } else {
        throw ServerException('Failed to send forgot password email: ${e.toString()}');
      }
    }
  }

  @override
  Future<VerifyOTPForPasswordResponseModel> verifyForgotPasswordOTP(String email, int otp) async {
    try {
      print('🔐 Attempting verify forgot password OTP to: ${AppConstants.baseUrl}${AppConstants.verifyEmailCodeEndpoint}');
      print('📧 Email: $email');
      print('🔢 OTP: $otp');

      final requestBody = VerifyOTPRequestModel(email: email, otp: otp).toJson();
      print('📤 Request body: $requestBody');

      final response = await _apiClient.post(AppConstants.verifyEmailCodeEndpoint, data: requestBody);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      if (response.statusCode == 200) {
        return VerifyOTPForPasswordResponseModel.fromJson(response.data);
      } else {
        throw ServerException(response.data['message'] ?? 'Verify forgot password OTP failed');
      }
    } catch (e) {
      print('❌ Verify forgot password OTP error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String password, String accessToken) async {
    try {
      print('🔐 Attempting reset password to: ${AppConstants.baseUrl}${AppConstants.resetPasswordEndpoint}');
      print('🔑 AccessToken: ${accessToken.substring(0, 10)}...');

      final requestBody = ResetPasswordRequestModel(
        password: password,
        accessToken: accessToken,
      ).toJson();
      print('📤 Request body: [Password hidden for security]');

      final response = await _apiClient.post(AppConstants.resetPasswordEndpoint, data: requestBody);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ Password reset successfully');
        return;
      } else {
        throw ServerException(response.data['message'] ?? 'Reset password failed');
      }
    } catch (e) {
      print('❌ Reset password error: $e');
      throw ServerException(e.toString());
    }
  }
}
