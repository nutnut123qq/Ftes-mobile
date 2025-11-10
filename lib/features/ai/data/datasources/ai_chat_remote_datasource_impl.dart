import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/ai_chat_request_model.dart';
import '../models/ai_chat_response_model.dart';
import '../models/video_knowledge_model.dart';
import '../../domain/constants/ai_constants.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/video_knowledge.dart';
import 'ai_chat_remote_datasource.dart';

/// Remote data source implementation for AI Chat
class AiChatRemoteDataSourceImpl implements AiChatRemoteDataSource {
  final ApiClient _apiClient;

  AiChatRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<VideoKnowledge> checkVideoKnowledge(String videoId) async {
    try {
      debugPrint('📚 Checking video knowledge: $videoId');
      
      final token = await _getAccessToken();
      final url = '${AppConstants.aiCheckVideoKnowledgeEndpoint}/$videoId';
      debugPrint('🔗 Full URL: $url');
      
      // Use http package for external API
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        );

        debugPrint('📥 Check knowledge response status: ${response.statusCode}');
        debugPrint('📥 Check knowledge response data: ${response.body}');

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          final model = VideoKnowledgeModel.fromJson(jsonData);
          return model.toEntity();
        } else {
          // If API fails, return true to allow chat
          debugPrint('⚠️ API returned ${response.statusCode}, allowing chat by default');
          return const VideoKnowledge(
            hasKnowledge: true,
            status: 'error',
            message: 'API error, allowing chat',
          );
        }
      } on Exception catch (e) {
        // If network/CORS error, allow chat by default
        debugPrint('⚠️ Network error checking knowledge: $e');
        debugPrint('✅ Allowing chat by default due to network error');
        return const VideoKnowledge(
          hasKnowledge: true,
          status: 'network_error',
          message: 'Network error, allowing chat',
        );
      }
    } catch (e) {
      debugPrint('❌ Check video knowledge error: $e');
      // Return true as default to allow chat on error
      return const VideoKnowledge(
        hasKnowledge: true,
        status: 'unknown',
        message: 'Error checking, allowing chat',
      );
    }
  }


  /// Get access token from SharedPreferences
  Future<String?> _getAccessToken() async {
    try {
      final prefs = _apiClient.sharedPreferences;
      return prefs.getString(AppConstants.keyAccessToken);
    } catch (e) {
      debugPrint('⚠️ Failed to get access token: $e');
      return null;
    }
  }

  @override
  Future<AiChatMessage> sendMessage({
    required String message,
    required String lessonId,
    required String lessonTitle,
    required String sessionId,
  }) async {
    try {
      debugPrint('🤖 Sending message to AI: $message');
      debugPrint('📚 Lesson: $lessonTitle');
      debugPrint('🔗 Session: $sessionId');

      // Create request model
      final request = AiChatRequestModel(
        message: message,
        videoId: lessonId,
        lessonTitle: lessonTitle,
        sessionId: sessionId,
        prompt: message, // Use message as prompt
      );

      // Use full URL for AI API (external service)
      final url = '${AppConstants.aiChatBaseUrl}${AppConstants.aiChatEndpoint}';
      debugPrint('🔗 Full AI URL: $url');
      debugPrint('📤 Request body: ${request.toJson()}');

      // Send POST request using Dio directly
      final dio = _apiClient.dio;
      final token = await _getAccessToken();
      
      final response = await dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      debugPrint('📥 AI response status: ${response.statusCode}');
      debugPrint('📥 AI response data: ${response.data}');

      if (response.statusCode == 200) {
        // Parse response off main thread if large
        final responseData = response.data as Map<String, dynamic>;
        final aiResponse = AiChatResponseModel.fromJson(responseData);

        if (aiResponse.success) {
          final answer = aiResponse.getAnswer();

          if (answer != null && answer.isNotEmpty) {
            debugPrint('✅ AI response received: ${answer.substring(0, answer.length > 50 ? 50 : answer.length)}...');
            
            // Create AI message from response
            return AiChatMessage.ai(answer);
          } else {
            throw ServerException(AiConstants.errorEmptyResponse);
          }
        } else {
          final errorMsg = (aiResponse.error?.isNotEmpty == true)
              ? aiResponse.error!
              : (aiResponse.message.isNotEmpty
                  ? aiResponse.message
                  : AiConstants.errorSendMessageFailed);
          throw ServerException(errorMsg);
        }
      } else {
        throw ServerException(
          response.data?['messageDTO']?['message'] ??
              AiConstants.errorSendMessageFailed,
        );
      }
    } catch (e) {
      debugPrint('❌ Send message error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${AiConstants.errorSendMessageFailed}: ${e.toString()}');
    }
  }
}
