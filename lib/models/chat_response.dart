class ChatResponse {
  final String response;
  final String? conversationId;
  final int? tokensUsed;
  final double? confidence;
  final List<String>? suggestedQuestions;
  final DateTime? timestamp;
  final String? model;
  final ChatMetadata? metadata;

  ChatResponse({
    required this.response,
    this.conversationId,
    this.tokensUsed,
    this.confidence,
    this.suggestedQuestions,
    this.timestamp,
    this.model,
    this.metadata,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] as String,
      conversationId: json['conversationId'] as String?,
      tokensUsed: json['tokensUsed'] as int?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      suggestedQuestions: (json['suggestedQuestions'] as List<dynamic>?)?.cast<String>(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      model: json['model'] as String?,
      metadata: json['metadata'] != null
          ? ChatMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      if (conversationId != null) 'conversationId': conversationId,
      if (tokensUsed != null) 'tokensUsed': tokensUsed,
      if (confidence != null) 'confidence': confidence,
      if (suggestedQuestions != null) 'suggestedQuestions': suggestedQuestions,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      if (model != null) 'model': model,
      if (metadata != null) 'metadata': metadata!.toJson(),
    };
  }
}

class ChatMetadata {
  final double? temperature;
  final int? maxTokens;
  final String? systemMessage;
  final bool? hadContext;
  final int? contextDocuments;

  ChatMetadata({
    this.temperature,
    this.maxTokens,
    this.systemMessage,
    this.hadContext,
    this.contextDocuments,
  });

  factory ChatMetadata.fromJson(Map<String, dynamic> json) {
    return ChatMetadata(
      temperature: (json['temperature'] as num?)?.toDouble(),
      maxTokens: json['maxTokens'] as int?,
      systemMessage: json['systemMessage'] as String?,
      hadContext: json['hadContext'] as bool?,
      contextDocuments: json['contextDocuments'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (temperature != null) 'temperature': temperature,
      if (maxTokens != null) 'maxTokens': maxTokens,
      if (systemMessage != null) 'systemMessage': systemMessage,
      if (hadContext != null) 'hadContext': hadContext,
      if (contextDocuments != null) 'contextDocuments': contextDocuments,
    };
  }
}
