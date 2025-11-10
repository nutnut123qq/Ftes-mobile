import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../models/ai_chat_response_model.dart';
import '../../domain/constants/ai_constants.dart';

/// Helper for parsing AI chat JSON responses off main thread
class AiJsonParserHelper {
  /// Parse AI chat response JSON
  /// Uses isolate if response is large
  static Future<AiChatMessage> parseAiChatResponse(
    Map<String, dynamic> json,
  ) async {
    try {
      final response = AiChatResponseModel.fromJson(json);
      
      if (response.success) {
        final answer = response.getAnswer();
        
        if (answer != null && answer.isNotEmpty) {
          return AiChatMessage.ai(answer);
        } else {
          throw Exception(AiConstants.errorEmptyResponse);
        }
      } else {
        final errorMsg = (response.error?.isNotEmpty == true)
            ? response.error!
            : (response.message.isNotEmpty
                ? response.message
                : AiConstants.errorSendMessageFailed);
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('❌ Parse AI response error: $e');
      rethrow;
    }
  }

  /// Parse JSON using isolate for large responses
  static Future<AiChatMessage> parseAiChatResponseInIsolate(
    Map<String, dynamic> json,
  ) async {
    try {
      // Check if we need to use isolate
      final jsonString = jsonEncode(json);
      final jsonSize = jsonString.length;
      
      print('📊 JSON size: $jsonSize bytes');
      
      if (jsonSize > AiConstants.jsonParsingThreshold) {
        print('⚡ Using compute isolate for JSON parsing (${jsonSize}B > ${AiConstants.jsonParsingThreshold}B)');
        
        // Use top-level function for compute
        return await compute(
          _parseAiChatResponseInIsolate,
          json,
        );
      } else {
        print('⚡ Parsing JSON on main thread (${jsonSize}B <= ${AiConstants.jsonParsingThreshold}B)');
        return parseAiChatResponse(json);
      }
    } catch (e) {
      print('❌ Parse JSON error: $e');
      rethrow;
    }
  }
}

/// Isolate function for parsing AI response (top-level for compute)
AiChatMessage _parseAiChatResponseInIsolate(Map<String, dynamic> json) {
  try {
    final response = AiChatResponseModel.fromJson(json);
    
    if (response.success) {
      final answer = response.getAnswer();
      
      if (answer != null && answer.isNotEmpty) {
        return AiChatMessage.ai(answer);
      } else {
        throw Exception(AiConstants.errorEmptyResponse);
      }
    } else {
      final errorMsg = (response.error?.isNotEmpty == true)
          ? response.error!
          : (response.message.isNotEmpty
              ? response.message
              : AiConstants.errorSendMessageFailed);
      throw Exception(errorMsg);
    }
  } catch (e) {
    print('Parse AI response in isolate error: $e');
    rethrow;
  }
}
