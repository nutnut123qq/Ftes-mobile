import 'package:equatable/equatable.dart';

/// AI Chat Message entity
enum AiMessageType {
  text,
  image,
  loading,
  error,
}

/// AI Chat Message entity representing a message in the chat
class AiChatMessage extends Equatable {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isFromUser;
  final AiMessageType type;
  final String? imageUrl;

  const AiChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFromUser,
    this.type = AiMessageType.text,
    this.imageUrl,
  });

  /// Create welcome message
  factory AiChatMessage.welcome(String lessonTitle) {
    return AiChatMessage(
      id: 'welcome',
      content: 'Xin chào! Tôi là AI trợ giảng của bạn cho bài học "$lessonTitle". Hãy hỏi tôi bất cứ điều gì về bài học này nhé! 😊',
      timestamp: DateTime.now(),
      isFromUser: false,
      type: AiMessageType.text,
    );
  }

  /// Create loading message
  factory AiChatMessage.loading() {
    return AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '',
      timestamp: DateTime.now(),
      isFromUser: false,
      type: AiMessageType.loading,
    );
  }

  /// Create error message
  factory AiChatMessage.error(String error) {
    return AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: error,
      timestamp: DateTime.now(),
      isFromUser: false,
      type: AiMessageType.error,
    );
  }

  /// Create user message
  factory AiChatMessage.user(String content) {
    return AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      isFromUser: true,
      type: AiMessageType.text,
    );
  }

  /// Create AI response message
  factory AiChatMessage.ai(String content) {
    return AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      isFromUser: false,
      type: AiMessageType.text,
    );
  }

  @override
  List<Object?> get props => [
        id,
        content,
        timestamp,
        isFromUser,
        type,
        imageUrl,
      ];
}

