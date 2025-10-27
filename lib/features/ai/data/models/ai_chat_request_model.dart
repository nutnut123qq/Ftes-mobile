/// Request model for AI Chat API
class AiChatRequestModel {
  final String message;
  final String videoId;
  final String lessonTitle;
  final String sessionId;
  final String prompt; // Add prompt field for API

  const AiChatRequestModel({
    required this.message,
    required this.videoId,
    required this.lessonTitle,
    required this.sessionId,
    required this.prompt,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'video_id': videoId,
      'session_id': sessionId,
      'lesson_title': lessonTitle,
      'prompt': prompt,
    };
  }

  /// Create from JSON
  factory AiChatRequestModel.fromJson(Map<String, dynamic> json) {
    return AiChatRequestModel(
      message: json['message'] as String,
      videoId: json['video_id'] as String,
      lessonTitle: json['lesson_title'] as String,
      sessionId: json['session_id'] as String,
      prompt: json['prompt'] as String,
    );
  }

  @override
  String toString() {
    return 'AiChatRequestModel(message: $message, videoId: $videoId, lessonTitle: $lessonTitle, sessionId: $sessionId)';
  }
}

