import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_chat_request.dart';
import '../models/ai_chat_response.dart';
import '../core/constants/app_constants.dart';
import 'http_client.dart';

/// AI Chat Service - Connects to Python FastAPI AI Service
/// 
/// Base URL: ${AppConstants.baseUrl}/api/ai
/// Endpoint: POST /chat
class AIChatService {
  final String baseUrl = '${AppConstants.baseUrl}/api/ai';
  final HttpClient _httpClient = HttpClient();

  /// Chat with AI about a lesson
  /// 
  /// This method calls the Python AI service endpoint: POST /api/ai/chat
  /// 
  /// Args:
  ///   - message: User's question
  ///   - lessonId: ID of the lesson (used as video_id in API)
  ///   - lessonTitle: Title of the lesson
  ///   - userId: User ID for session tracking
  /// 
  /// Returns:
  ///   - AIChatResponse with structured answer
  Future<AIChatResponse> chatWithLesson({
    required String message,
    required String lessonId,
    required String lessonTitle,
    required String userId,
  }) async {
    try {
      // Create session ID: user_${userId}_lesson_${lessonId}
      final sessionId = AIChatRequest.createSessionId(userId, lessonId);
      
      // Get authentication token
      final token = await _httpClient.getAccessToken();
      
      // Create request
      final request = AIChatRequest(
        message: message,
        videoId: lessonId,
        lessonTitle: lessonTitle,
        sessionId: sessionId,
      );
      
      final requestBody = jsonEncode(request.toJson());
      
      // Send POST request
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final aiResponse = AIChatResponse.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)),
        );
        
        if (aiResponse.success) {
          return aiResponse;
        } else {
          final errorMsg = aiResponse.error ?? aiResponse.message;
          throw Exception(errorMsg);
        }
      } else {
        throw Exception('Failed to chat with lesson: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error chatting with lesson: $e');
    }
  }
}
