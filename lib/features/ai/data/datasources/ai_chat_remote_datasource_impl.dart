import 'dart:convert';
import 'package:http/http.dart' as http;
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
      print('📚 Checking video knowledge: $videoId');
      
      // For now, always return true to allow chat
      // TODO: Implement actual API call when backend supports CORS
      return const VideoKnowledge(
        hasKnowledge: true,
        status: 'available',
        message: 'Knowledge available',
      );
    } catch (e) {
      print('❌ Check video knowledge error: $e');
      // Return true as default to allow chat
      return const VideoKnowledge(
        hasKnowledge: true,
        status: 'unknown',
        message: 'Unknown status',
      );
    }
  }


  /// Get access token from SharedPreferences
  Future<String?> _getAccessToken() async {
    try {
      final prefs = _apiClient.sharedPreferences;
      return prefs.getString(AppConstants.keyAccessToken);
    } catch (e) {
      print('⚠️ Failed to get access token: $e');
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
      print('🤖 Sending message to AI: $message');
      print('📚 Lesson: $lessonTitle');
      print('🔗 Session: $sessionId');

      // Create request model
      final request = AiChatRequestModel(
        message: message,
        videoId: lessonId,
        lessonTitle: lessonTitle,
        sessionId: sessionId,
      );

      // Send POST request
      final response = await _apiClient.post(
        AppConstants.aiChatEndpoint,
        data: request.toJson(),
      );

      print('📥 AI response status: ${response.statusCode}');
      print('📥 AI response data: ${response.data}');

      if (response.statusCode == 200) {
        // Parse response off main thread if large
        final responseData = response.data as Map<String, dynamic>;
        final aiResponse = AiChatResponseModel.fromJson(responseData);

        if (aiResponse.success) {
          final answer = aiResponse.getAnswer();

          if (answer != null && answer.isNotEmpty) {
            print('✅ AI response received: ${answer.substring(0, answer.length > 50 ? 50 : answer.length)}...');
            
            // Create AI message from response
            return AiChatMessage.ai(answer);
          } else {
            throw ServerException(AiConstants.errorEmptyResponse);
          }
        } else {
          final errorMsg = aiResponse.error ?? aiResponse.message ?? AiConstants.errorSendMessageFailed;
          throw ServerException(errorMsg);
        }
      } else {
        throw ServerException(
          response.data?['messageDTO']?['message'] ??
              AiConstants.errorSendMessageFailed,
        );
      }
    } catch (e) {
      print('❌ Send message error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${AiConstants.errorSendMessageFailed}: ${e.toString()}');
    }
  }
}
