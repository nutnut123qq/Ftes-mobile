import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

/// Singleton service to validate tokens using Introspect API
/// Implements debouncing and caching to avoid excessive API calls
class TokenValidator {
  static TokenValidator? _instance;
  final Dio _dio;
  
  // Cache
  DateTime? _lastCheckTime;
  bool? _lastValidationResult;
  String? _lastCheckedToken;
  static const Duration _cacheDuration = Duration(minutes: 5);
  
  // Debounce
  Future<bool>? _pendingValidation;
  Timer? _debounceTimer;
  
  // Lock to prevent concurrent validations
  bool _isValidating = false;

  TokenValidator._(this._dio);

  factory TokenValidator.getInstance(Dio? dio) {
    if (_instance == null && dio != null) {
      _instance = TokenValidator._(dio);
    }
    if (_instance == null) {
      throw StateError('TokenValidator not initialized. Call getInstance with Dio first.');
    }
    return _instance!;
  }

  /// Validate token using Introspect API
  /// Returns true if token is valid, false otherwise
  /// Uses caching and debouncing to optimize performance
  Future<bool> validateToken(String token) async {
    // Check cache first
    if (_isTokenCached(token)) {
      debugPrint('📦 Using cached token validation: $_lastValidationResult');
      return _lastValidationResult!;
    }

    // If there's a pending validation for the same token, wait for it
    if (_pendingValidation != null && _lastCheckedToken == token) {
      debugPrint('⏳ Waiting for pending token validation...');
      return await _pendingValidation!;
    }

    // Debounce: cancel previous timer and start new one
    _debounceTimer?.cancel();
    
    // Create new validation future
    _pendingValidation = _performValidation(token);
    final result = await _pendingValidation!;
    _pendingValidation = null;
    
    return result;
  }

  /// Check if token is cached and still valid
  bool _isTokenCached(String token) {
    if (_lastCheckedToken != token) return false;
    if (_lastCheckTime == null || _lastValidationResult == null) return false;
    
    final now = DateTime.now();
    final isCacheValid = now.difference(_lastCheckTime!) < _cacheDuration;
    
    if (!isCacheValid) {
      // Clear expired cache
      _lastCheckTime = null;
      _lastValidationResult = null;
      _lastCheckedToken = null;
    }
    
    return isCacheValid;
  }

  /// Perform actual token validation
  Future<bool> _performValidation(String token) async {
    // Prevent concurrent validations
    if (_isValidating) {
      debugPrint('⏳ Token validation already in progress, waiting...');
      // Wait a bit and retry
      await Future.delayed(const Duration(milliseconds: 500));
      if (_isValidating) {
        // Still validating, return cached result if available
        return _lastValidationResult ?? false;
      }
    }

    _isValidating = true;
    
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.introspectEndpoint}';
      debugPrint('🔍 Validating token: ${token.substring(0, 20)}...');

      final response = await _dio.post(
        url,
        data: token, // Send token as raw string in body
        options: Options(
          headers: {
            'Content-Type': 'text/plain',
          },
          validateStatus: (status) => status != null && status < 500,
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      debugPrint('📥 Introspect response status: ${response.statusCode}');

      bool isValid = false;
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final result = data['result'];
          if (result is Map<String, dynamic>) {
            isValid = result['valid'] as bool? ?? false;
          }
        }
      }

      // Update cache
      _lastCheckTime = DateTime.now();
      _lastValidationResult = isValid;
      _lastCheckedToken = token;

      debugPrint('✅ Token validation result: $isValid');
      return isValid;
      
    } on DioException catch (e) {
      debugPrint('❌ Introspect error: ${e.message}');
      
      // On network errors, don't invalidate token
      // Let the actual API request fail with 401 if token is invalid
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        debugPrint('⚠️ Network error during validation, returning true to allow request');
        // Don't update cache on network error
        return true;
      }
      
      // For other errors, assume invalid
      _lastCheckTime = DateTime.now();
      _lastValidationResult = false;
      _lastCheckedToken = token;
      return false;
      
    } catch (e) {
      debugPrint('❌ Unexpected validation error: $e');
      // On unexpected errors, don't invalidate token
      return true;
    } finally {
      _isValidating = false;
    }
  }

  /// Clear validation cache (useful after logout or token refresh)
  void clearCache() {
    _lastCheckTime = null;
    _lastValidationResult = null;
    _lastCheckedToken = null;
    _pendingValidation = null;
    _debounceTimer?.cancel();
    _isValidating = false;
    debugPrint('🗑️ Token validation cache cleared');
  }
}

