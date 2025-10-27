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
    // Handle both old format (data field) and new format (result field)
    final dataJson = json['data'] ?? json['result'];
    
    return AiChatResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataJson != null
          ? AiChatDataModel.fromJson(dataJson as Map<String, dynamic>)
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
      if (data != null && data!.result != null) 'result': data!.result,
    };
  }

  /// Get the answer text from structured response
  String? getAnswer() {
    // Check result field first (new API structure)
    if (data?.result != null) {
      final result = data!.result;
      if (result is Map<String, dynamic> && result['response'] != null) {
        return result['response'] as String?;
      }
    }
    
    // Check data.response field
    if (data?.response != null) {
      return data!.response;
    }
    
    // Check structured_response field (old format)
    if (data?.structuredResponse != null) {
      return data!.structuredResponse!['answer'] as String?;
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
  final Map<String, dynamic>? result; // Add result field for new API structure

  const AiChatDataModel({
    this.structuredResponse,
    this.response,
    this.videoId,
    this.sessionId,
    required this.format,
    this.result,
  });

  factory AiChatDataModel.fromJson(Map<String, dynamic> json) {
    return AiChatDataModel(
      structuredResponse: json['structured_response'] as Map<String, dynamic>?,
      response: json['response'] as String?,
      videoId: json['video_id'] as String?,
      sessionId: json['session_id'] as String?,
      format: json['format'] as String? ?? 'raw',
      result: json['result'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (structuredResponse != null) 'structured_response': structuredResponse,
      if (response != null) 'response': response,
      if (videoId != null) 'video_id': videoId,
      if (sessionId != null) 'session_id': sessionId,
      'format': format,
      if (result != null) 'result': result,
    };
  }

  @override
  String toString() {
    return 'AiChatDataModel(videoId: $videoId, sessionId: $sessionId, format: $format)';
  }
}

