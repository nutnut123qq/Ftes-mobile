import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import '../constants/app_constants.dart';
import '../utils/retry_helper.dart';

/// AI API Client using Dio for AI service requests
class AiApiClient {
  final Dio _dio;
  
  AiApiClient({required Dio dio}) : _dio = dio {
    _setupDio();
    _setupInterceptors();
  }

  void _setupDio() {
    _dio.options.baseUrl = AppConstants.aiBaseUrl;
    _dio.options.connectTimeout = AppConstants.aiApiTimeout;
    _dio.options.receiveTimeout = AppConstants.aiApiTimeout;
    _dio.options.headers['Content-Type'] = 'application/json';
  }
  
  void _setupInterceptors() {
    _dio.interceptors.addAll([
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
              if (error.response!.data['message'] != null) {
                message = error.response!.data['message'];
              } else if (error.response!.data['error'] != null) {
                message = error.response!.data['error']['details'] ?? 
                         error.response!.data['error']['code'] ?? 
                         'Unknown error';
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
  
  /// POST request to AI service
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool enableRetry = true,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 2),
  }) async {
    try {
      if (enableRetry) {
        return await retryWithBackoff<Response>(
          operation: () => _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          ),
          maxRetries: maxRetries,
          initialDelay: initialDelay,
        );
      } else {
        return await _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
      }
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
