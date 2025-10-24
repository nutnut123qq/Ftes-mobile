import 'dart:convert';
import '../../core/network/api_client.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/auth_request_model.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/verify_otp_request_model.dart';
import '../models/verify_otp_response_model.dart';
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
  Future<AuthenticationResponseModel> loginWithGoogle() async {
    try {
      final response = await _apiClient.post(
        AppConstants.googleAuthEndpoint,
        queryParameters: {'id_token': 'dummy_token', 'isAdmin': 'false'},
      );

      if (response.statusCode == 200) {
        return AuthenticationResponseModel.fromJson(response.data['result']);
      } else {
        throw ServerException(response.data['message'] ?? 'Google login failed');
      }
    } catch (e) {
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
}
