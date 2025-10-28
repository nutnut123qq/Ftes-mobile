import 'package:ftes/core/network/api_client.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/error/exceptions.dart';
import 'package:ftes/features/auth/domain/constants/auth_constants.dart';
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
      final requestBody = AuthenticationRequestModel(credential: email, password: password).toJson();
      final response = await _apiClient.post(AppConstants.loginEndpoint, data: requestBody);

      if (response.statusCode == 200) {
        // API response format: { "success": true, "result": { "accessToken": "...", "refreshToken": "...", ... } }
        final result = response.data['result'];
        if (result != null) {
          return AuthenticationResponseModel.fromJson(result);
        } else {
          throw const ServerException(AuthConstants.errorInvalidResponse);
        }
      } else {
        throw ServerException(response.data['message'] ?? AuthConstants.errorLoginFailed);
      }
    } catch (e) {
      throw const ServerException(AuthConstants.errorServer);
    }
  }

  @override
  Future<AuthenticationResponseModel> loginWithGoogle(String authCode, {bool isAdmin = false}) async {
    try {
      final response = await _apiClient.post(
        AppConstants.googleAuthEndpoint,
        queryParameters: {
          'code': authCode,
          'isAdmin': isAdmin.toString(),
        },
      );

      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null) {
          return AuthenticationResponseModel.fromJson(result);
        } else {
          throw const ServerException(AuthConstants.errorInvalidResponse);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? AuthConstants.errorLoginFailed);
      }
    } catch (e) {
      throw const ServerException(AuthConstants.errorServer);
    }
  }


  @override
  Future<UserModel> getMyInfo() async {
    try {
      final response = await _apiClient.get(AppConstants.myInfoEndpoint);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['result']);
      } else {
        throw ServerException(response.data['message'] ?? AuthConstants.errorGetUserInfo);
      }
    } catch (e) {
      throw const ServerException(AuthConstants.errorServer);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(AppConstants.logoutEndpoint);
    } catch (e) {
      // Swallow error: local cleanup vẫn tiếp tục ở repository
    }
  }

  @override
  Future<RegisterResponseModel> register(String username, String email, String password) async {
    try {
      final requestBody = RegisterRequestModel(
        username: username,
        email: email,
        password: password,
      ).toJson();
      final response = await _apiClient.post(AppConstants.registerEndpoint, data: requestBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(response.data['message'] ?? AuthConstants.errorRegisterFailed);
      }
    } catch (e) {
      throw const ServerException(AuthConstants.errorServer);
    }
  }

  @override
  Future<VerifyOTPResponseModel> verifyEmailOTP(String email, int otp) async {
    try {
      final requestBody = VerifyOTPRequestModel(email: email, otp: otp).toJson();
      final response = await _apiClient.post(AppConstants.verifyEmailCodeEndpoint, data: requestBody);

      if (response.statusCode == 200) {
        return VerifyOTPResponseModel.fromJson(response.data);
      } else {
        throw ServerException(response.data['message'] ?? AuthConstants.errorVerifyOTPFailed);
      }
    } catch (e) {
      throw const ServerException(AuthConstants.errorServer);
    }
  }

  @override
  Future<void> resendVerificationCode(String email) async {
    try {
      final requestBody = {'email': email};
      final response = await _apiClient.post(AppConstants.resendVerifyCodeEndpoint, data: requestBody);
      if (response.statusCode != 200) {
        throw ServerException(response.data['message'] ?? AuthConstants.errorResendCodeFailed);
      }
    } catch (e) {
      throw const ServerException(AuthConstants.errorServer);
    }
  }

  @override
  Future<void> sendForgotPasswordEmail(String email) async {
    try {
      final requestBody = forgot_password_req.ForgotPasswordRequestModel(email: email).toJson();
      final response = await _apiClient.post(AppConstants.sendForgotPasswordEmailEndpoint, data: requestBody);
      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(response.data['message'] ?? AuthConstants.errorSendForgotEmailFailed);
      }
    } catch (e) {
      throw const ServerException(AuthConstants.errorServer);
    }
  }

  @override
  Future<VerifyOTPForPasswordResponseModel> verifyForgotPasswordOTP(String email, int otp) async {
    try {
      final requestBody = VerifyOTPRequestModel(email: email, otp: otp).toJson();
      final response = await _apiClient.post(AppConstants.verifyEmailCodeEndpoint, data: requestBody);
      if (response.statusCode == 200) {
        return VerifyOTPForPasswordResponseModel.fromJson(response.data);
      } else {
        throw ServerException(response.data['message'] ?? AuthConstants.errorVerifyForgotOTPFailed);
      }
    } catch (e) {
      throw const ServerException(AuthConstants.errorServer);
    }
  }

  @override
  Future<void> resetPassword(String password, String accessToken) async {
    try {
      final requestBody = ResetPasswordRequestModel(
        password: password,
        accessToken: accessToken,
      ).toJson();
      final response = await _apiClient.post(AppConstants.resetPasswordEndpoint, data: requestBody);
      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(response.data['message'] ?? AuthConstants.errorResetPasswordFailed);
      }
    } catch (e) {
      throw const ServerException(AuthConstants.errorServer);
    }
  }
}
