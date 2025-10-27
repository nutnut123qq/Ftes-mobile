import '../../domain/entities/ai_chat_message.dart';

/// Model for AI Chat Message (extends domain entity)
class AiChatMessageModel extends AiChatMessage {
  const AiChatMessageModel({
    required super.id,
    required super.content,
    required super.timestamp,
    required super.isFromUser,
    super.type,
    super.imageUrl,
  });

  /// Convert from domain entity
  factory AiChatMessageModel.fromEntity(AiChatMessage entity) {
    return AiChatMessageModel(
      id: entity.id,
      content: entity.content,
      timestamp: entity.timestamp,
      isFromUser: entity.isFromUser,
      type: entity.type,
      imageUrl: entity.imageUrl,
    );
  }

  /// Convert from JSON
  factory AiChatMessageModel.fromJson(Map<String, dynamic> json) {
    return AiChatMessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isFromUser: json['isFromUser'] as bool? ?? false,
      type: _parseMessageType(json['type'] as String?),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isFromUser': isFromUser,
      'type': type.name,
      'imageUrl': imageUrl,
    };
  }

  static AiMessageType _parseMessageType(String? typeStr) {
    if (typeStr == null) return AiMessageType.text;
    
    try {
      return AiMessageType.values.firstWhere(
        (e) => e.name == typeStr,
        orElse: () => AiMessageType.text,
      );
    } catch (_) {
      return AiMessageType.text;
    }
  }
}

