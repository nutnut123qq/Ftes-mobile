import 'dart:convert';
import 'package:flutter/foundation.dart' show compute, debugPrint;
import '../models/user_model.dart';
import '../../domain/constants/auth_constants.dart';

/// Helper for parsing Auth JSON responses off main thread
class AuthJsonParserHelper {
  /// Parse user response JSON
  /// Uses isolate if response is large
  static Future<UserModel> parseUserResponse(
    Map<String, dynamic> json,
  ) async {
    try {
      return UserModel.fromJson(json);
    } catch (e) {
      debugPrint('❌ Parse user response error: $e');
      rethrow;
    }
  }

  /// Parse JSON using isolate for large responses
  static Future<UserModel> parseUserResponseInIsolate(
    Map<String, dynamic> json,
  ) async {
    try {
      // Check if we need to use isolate
      final jsonString = jsonEncode(json);
      final jsonSize = jsonString.length;
      
      debugPrint('📊 User JSON size: $jsonSize bytes');
      
      if (jsonSize > AuthConstants.jsonParsingThreshold) {
        debugPrint('⚡ Using compute isolate for JSON parsing (${jsonSize}B > ${AuthConstants.jsonParsingThreshold}B)');
        
        // Use top-level function for compute
        return await compute(
          _parseUserResponseInIsolate,
          json,
        );
      } else {
        debugPrint('⚡ Parsing JSON on main thread (${jsonSize}B <= ${AuthConstants.jsonParsingThreshold}B)');
        return parseUserResponse(json);
      }
    } catch (e) {
      debugPrint('❌ Parse user JSON error: $e');
      rethrow;
    }
  }
}

/// Isolate function for parsing user response (top-level for compute)
UserModel _parseUserResponseInIsolate(Map<String, dynamic> json) {
  try {
    return UserModel.fromJson(json);
  } catch (e) {
    // Note: Cannot use debugPrint in isolate, using print is acceptable here
    // ignore: avoid_print
    print('Parse user response in isolate error: $e');
    rethrow;
  }
}

