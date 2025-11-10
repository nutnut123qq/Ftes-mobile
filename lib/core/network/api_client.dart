import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../error/exceptions.dart';
import '../constants/app_constants.dart';

/// API Client using Dio for HTTP requests
class ApiClient {
  final Dio _dio;
  final SharedPreferences _sharedPreferences;
  
  // Expose dio and sharedPreferences for external URL calls (e.g., video stream server)
  Dio get dio => _dio;
  SharedPreferences get sharedPreferences => _sharedPreferences;
  
  ApiClient({required Dio dio, required SharedPreferences sharedPreferences}) 
      : _dio = dio, _sharedPreferences = sharedPreferences {
    _setupDio();
    _setupInterceptors();
  }

  void _setupDio() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = AppConstants.connectTimeout;
    _dio.options.receiveTimeout = AppConstants.receiveTimeout;
    _dio.options.headers['Content-Type'] = 'application/json';
  }
  
  /// Danh sách các endpoint không cần authentication
  static const List<String> _publicEndpoints = [
    '/api/auth/token', // Login
    '/api/users/registration', // Register
    '/api/auth/outbound/authentication', // Google Auth
    '/api/users/mail/forgot-password', // Forgot password
    '/api/users/mail/resend-verify-code', // Resend verify code
    '/api/auth/verify-email-code', // Verify email code
    '/api/users/reset-password', // Reset password
    '/api/users/active-user', // Active user
  ];

  /// Kiểm tra endpoint có cần authentication không
  bool _requiresAuthentication(String path) {
    return !_publicEndpoints.contains(path);
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      // Authentication interceptor
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Chỉ thêm token nếu endpoint yêu cầu authentication
          if (_requiresAuthentication(options.path)) {
            final token = _sharedPreferences.getString(AppConstants.keyAccessToken);
            if (token != null) {
              debugPrint('🔑 Adding Bearer token to request: ${token.substring(0, 20)}...');
              options.headers['Authorization'] = 'Bearer $token';
            } else {
              debugPrint('⚠️ No access token found, making request without authentication');
            }
          } else {
            debugPrint('🔓 Public endpoint, skipping authentication: ${options.path}');
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle token expiration or unauthorized access
            return handler.reject(DioException(
              requestOptions: error.requestOptions,
              error: AuthException('Unauthorized access'),
              response: error.response,
            ));
          }
          return handler.next(error);
        },
      ),
      
      // Logging interceptor
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
      
      // Error handling interceptor
      InterceptorsWrapper(
        onError: (error, handler) {
          // Log chi tiết lỗi để debug
          debugPrint('❌ DioException type: ${error.type}');
          debugPrint('❌ DioException message: ${error.message}');
          debugPrint('❌ Response status: ${error.response?.statusCode}');
          debugPrint('❌ Response data: ${error.response?.data}');
          
          AppException appException;
          
          if (error.response != null) {
            // Handle HTTP errors
            final statusCode = error.response!.statusCode;
            String message = 'Unknown error';
            if (error.response!.data != null) {
              if (error.response!.data['messageDTO'] != null) {
                message = error.response!.data['messageDTO']['message'] ?? 'Unknown error';
              } else if (error.response!.data['message'] != null) {
                message = error.response!.data['message'];
              }
            }
            
            switch (statusCode) {
              case 400:
                appException = ValidationException(message);
                break;
              case 401:
                appException = AuthException('Unauthorized: $message');
                break;
              case 403:
                appException = AuthException('Forbidden: $message');
                break;
              case 404:
                appException = ServerException('Not found: $message');
                break;
              case 500:
                appException = ServerException('Server error: $message');
                break;
              default:
                appException = ServerException('HTTP $statusCode: $message');
            }
          } else {
            // Handle network errors
            String errorMessage;
            if (error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout) {
              errorMessage = 'Connection timeout';
            } else if (error.type == DioExceptionType.connectionError) {
              errorMessage = 'No internet connection';
            } else if (error.type == DioExceptionType.badResponse) {
              errorMessage = 'Bad response from server';
            } else if (error.type == DioExceptionType.cancel) {
              errorMessage = 'Request cancelled';
            } else {
              // Xử lý trường hợp error.message null
              final message = error.message ?? 'Unknown network error';
              errorMessage = 'Network error: $message';
            }
            appException = NetworkException(errorMessage);
          }
          
          // Reject với DioException mới chứa AppException
          return handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: appException,
            response: error.response,
            type: error.type,
          ));
        },
      ),
    ]);
  }
  
  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Handle and convert errors to appropriate exceptions
  Exception _handleError(dynamic error) {
    if (error is AppException) {
      return error;
    } else if (error is DioException) {
      // Nếu DioException.error là AppException, trả về nó
      if (error.error is AppException) {
        return error.error as AppException;
      }
      // Xử lý trường hợp error.message null
      final message = error.message ?? 'Unknown network error';
      return NetworkException('Network error: $message');
    } else {
      return ServerException('Unexpected error: $error');
    }
  }
}
