/// Response model for AI Chat Service (Python FastAPI)
/// 
/// API Response format:
/// {
///   "success": true,
///   "message": "Success message",
///   "data": {
///     "structured_response": { "answer": "...", ... },
///     "video_id": "...",
///     "session_id": "...",
///     "format": "json" or "raw"
///   },
///   "error": null
/// }
/// 
/// DEPRECATED: This model has been moved to lib/features/ai
/// Please use AiChatResponseModel instead
@Deprecated('Use lib/features/ai/data/models/ai_chat_response_model.dart instead')
class AIChatResponse {
  final bool success;
  final String message;
  final AIChatData? data;
  final String? error;

  AIChatResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory AIChatResponse.fromJson(Map<String, dynamic> json) {
    return AIChatResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? AIChatData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
      if (error != null) 'error': error,
    };
  }

  /// Get the answer text from structured response
  String? getAnswer() {
    if (data?.structuredResponse != null) {
      return data!.structuredResponse!['answer'] as String?;
    }
    if (data?.response != null) {
      return data!.response;
    }
    return null;
  }

  @override
  String toString() {
    return 'AIChatResponse(success: $success, message: $message, answer: ${getAnswer()})';
  }
}

class AIChatData {
  final Map<String, dynamic>? structuredResponse;
  final String? response;
  final String? videoId;
  final String? sessionId;
  final String format;

  AIChatData({
    this.structuredResponse,
    this.response,
    this.videoId,
    this.sessionId,
    required this.format,
  });

  factory AIChatData.fromJson(Map<String, dynamic> json) {
    return AIChatData(
      structuredResponse: json['structured_response'] as Map<String, dynamic>?,
      response: json['response'] as String?,
      videoId: json['video_id'] as String?,
      sessionId: json['session_id'] as String?,
      format: json['format'] as String? ?? 'raw',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (structuredResponse != null) 'structured_response': structuredResponse,
      if (response != null) 'response': response,
      if (videoId != null) 'video_id': videoId,
      if (sessionId != null) 'session_id': sessionId,
      'format': format,
    };
  }
}

