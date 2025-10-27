/// Response model for AI Chat API
class AiChatResponseModel {
  final bool success;
  final String message;
  final AiChatDataModel? data;
  final String? error;

  const AiChatResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory AiChatResponseModel.fromJson(Map<String, dynamic> json) {
    return AiChatResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? AiChatDataModel.fromJson(json['data'] as Map<String, dynamic>)
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
    return 'AiChatResponseModel(success: $success, message: $message, answer: ${getAnswer()})';
  }
}

/// Data model for AI Chat response
class AiChatDataModel {
  final Map<String, dynamic>? structuredResponse;
  final String? response;
  final String? videoId;
  final String? sessionId;
  final String format;

  const AiChatDataModel({
    this.structuredResponse,
    this.response,
    this.videoId,
    this.sessionId,
    required this.format,
  });

  factory AiChatDataModel.fromJson(Map<String, dynamic> json) {
    return AiChatDataModel(
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

  @override
  String toString() {
    return 'AiChatDataModel(videoId: $videoId, sessionId: $sessionId, format: $format)';
  }
}

