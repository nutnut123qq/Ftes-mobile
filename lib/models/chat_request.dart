class ChatRequest {
  final String prompt;
  final String? systemMessage;
  final double? temperature;
  final int? maxTokens;
  final String? conversationId;
  final List<String>? context;
  final bool? includeHistory;

  ChatRequest({
    required this.prompt,
    this.systemMessage,
    this.temperature = 0.7,
    this.maxTokens = 1000,
    this.conversationId,
    this.context,
    this.includeHistory = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      if (systemMessage != null) 'systemMessage': systemMessage,
      'temperature': temperature,
      'maxTokens': maxTokens,
      if (conversationId != null) 'conversationId': conversationId,
      if (context != null) 'context': context,
      'includeHistory': includeHistory,
    };
  }

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      prompt: json['prompt'] as String,
      systemMessage: json['systemMessage'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      maxTokens: json['maxTokens'] as int? ?? 1000,
      conversationId: json['conversationId'] as String?,
      context: (json['context'] as List<dynamic>?)?.cast<String>(),
      includeHistory: json['includeHistory'] as bool? ?? false,
    );
  }
}
