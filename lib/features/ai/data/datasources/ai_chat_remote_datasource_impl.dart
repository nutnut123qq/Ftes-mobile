import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/retry_helper.dart';
import '../models/ai_chat_request_model.dart';
import '../models/video_knowledge_model.dart';
import '../helpers/ai_json_parser_helper.dart';
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
      final url = AppConstants.aiCheckVideoKnowledgeEndpoint;
      debugPrint('🔗 Full URL: $url');
      
      // Use POST request with body containing video_id (snake_case)
      try {
        final client = http.Client();
        try {
          final request = http.Request('POST', Uri.parse(url));
          request.headers.addAll({
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });
          request.body = json.encode({
            'video_id': videoId, // Use snake_case as per API spec
          });

          // Follow redirects manually
          final streamedResponse = await client.send(request).timeout(
            const Duration(seconds: 30),
          );
          
          // Handle redirects (307, 301, 302)
          var currentResponse = await http.Response.fromStream(streamedResponse);
          var redirectCount = 0;
          var currentUrl = Uri.parse(url);
          
          while (currentResponse.statusCode >= 300 && 
                 currentResponse.statusCode < 400 && 
                 redirectCount < 5) {
            final location = currentResponse.headers['location'];
            if (location != null) {
              // Handle relative URLs
              final redirectUri = location.startsWith('http') 
                  ? Uri.parse(location)
                  : currentUrl.resolve(location);
              
              debugPrint('🔄 Following redirect ${redirectCount + 1} to: $redirectUri');
              final redirectRequest = http.Request('POST', redirectUri);
              redirectRequest.headers.addAll({
                if (token != null) 'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              });
              redirectRequest.body = json.encode({
                'video_id': videoId,
              });
              final redirectStream = await client.send(redirectRequest).timeout(
                const Duration(seconds: 30),
              );
              currentResponse = await http.Response.fromStream(redirectStream);
              currentUrl = redirectUri;
              redirectCount++;
            } else {
              break;
            }
          }

          debugPrint('📥 Check knowledge response status: ${currentResponse.statusCode}');
          debugPrint('📥 Check knowledge response data: ${currentResponse.body}');

          if (currentResponse.statusCode == 200) {
            final jsonData = json.decode(currentResponse.body) as Map<String, dynamic>;
            final model = VideoKnowledgeModel.fromJson(jsonData);
            return model.toEntity();
          } else {
            // If API fails, return true to allow chat
            debugPrint('⚠️ API returned ${currentResponse.statusCode}, allowing chat by default');
            return const VideoKnowledge(
              hasKnowledge: true,
              status: 'error',
              message: 'API error, allowing chat',
            );
          }
        } finally {
          client.close();
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
    required String videoId,
    required String lessonTitle,
    required String sessionId,
  }) async {
    try {
      debugPrint('🤖 Sending message to AI: $message');
      debugPrint('📚 Lesson: $lessonTitle');
      debugPrint('🎬 Video ID: $videoId');
      debugPrint('🔗 Session: $sessionId');

      // Create request model
      final request = AiChatRequestModel(
        message: message,
        videoId: videoId,
        lessonTitle: lessonTitle,
        sessionId: sessionId,
      );

      // Use full URL for AI API (external service)
      final url = '${AppConstants.aiChatBaseUrl}${AppConstants.aiChatEndpoint}';
      debugPrint('🔗 Full AI URL: $url');
      debugPrint('📤 Request body: ${request.toJson()}');

      // Send POST request using Dio directly
      final dio = _apiClient.dio;
      final token = await _getAccessToken();
      
      // Use retry with exponential backoff
      final response = await retryWithBackoff(
        operation: () => dio.post(
          url,
          data: request.toJson(),
          options: Options(
            headers: token != null ? {'Authorization': 'Bearer $token'} : null,
            receiveTimeout: const Duration(seconds: 60), // AI can take time
            sendTimeout: const Duration(seconds: 30),
          ),
        ),
        maxRetries: 3,
        initialDelay: const Duration(seconds: 2),
      );

      debugPrint('📥 AI response status: ${response.statusCode}');
      debugPrint('📥 AI response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Parse in isolate using helper
        final aiMessage = await AiJsonParserHelper.parseAiChatResponseInIsolate(
          responseData,
        );
        
        debugPrint('✅ AI response received');
        return aiMessage;
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
