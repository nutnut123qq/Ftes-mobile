import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../error/exceptions.dart';
import '../constants/app_constants.dart';

/// API Client using Dio for HTTP requests
class ApiClient {
  final Dio _dio;
  final SharedPreferences _sharedPreferences;
  
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
  
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      // Authentication interceptor
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _sharedPreferences.getString(AppConstants.keyAccessToken);
          if (token != null) {
            print('🔑 Adding Bearer token to request: ${token.substring(0, 20)}...');
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            print('⚠️ No access token found, making request without authentication');
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
                throw ValidationException(message);
              case 401:
                throw AuthException('Unauthorized: $message');
              case 403:
                throw AuthException('Forbidden: $message');
              case 404:
                throw ServerException('Not found: $message');
              case 500:
                throw ServerException('Server error: $message');
              default:
                throw ServerException('HTTP $statusCode: $message');
            }
          } else {
            // Handle network errors
            if (error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout) {
              throw NetworkException('Connection timeout');
            } else if (error.type == DioExceptionType.connectionError) {
              throw NetworkException('No internet connection');
            } else {
              throw NetworkException('Network error: ${error.message}');
            }
          }
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
      return NetworkException('Network error: ${error.message}');
    } else {
      return ServerException('Unexpected error: $error');
    }
  }
}
