/// Request model for AI Chat Service (Python FastAPI)
/// 
/// API Endpoint: POST /api/ai/chat
/// 
/// This model matches the Python ChatRequest schema:
/// - message: User's question
/// - video_id: Lesson ID for context
/// - lesson_title: Title of the lesson
/// - session_id: Chat session identifier
/// 
/// DEPRECATED: This model has been moved to lib/features/ai
/// Please use AiChatRequestModel instead
@Deprecated('Use lib/features/ai/data/models/ai_chat_request_model.dart instead')
class AIChatRequest {
  final String message;
  final String videoId;
  final String lessonTitle;
  final String sessionId;

  AIChatRequest({
    required this.message,
    required this.videoId,
    required this.lessonTitle,
    required this.sessionId,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'video_id': videoId,
      'lesson_title': lessonTitle,
      'session_id': sessionId,
    };
  }

  /// Create from JSON
  factory AIChatRequest.fromJson(Map<String, dynamic> json) {
    return AIChatRequest(
      message: json['message'] as String,
      videoId: json['video_id'] as String,
      lessonTitle: json['lesson_title'] as String,
      sessionId: json['session_id'] as String,
    );
  }

  /// Create session ID format: user_${userId}_lesson_${lessonId}
  static String createSessionId(String userId, String lessonId) {
    return 'user_${userId}_lesson_$lessonId';
  }

  @override
  String toString() {
    return 'AIChatRequest(message: $message, videoId: $videoId, lessonTitle: $lessonTitle, sessionId: $sessionId)';
  }
}

