import 'package:equatable/equatable.dart';
import 'ai_chat_message.dart';

/// AI Chat Session entity representing a chat session for a lesson
class AiChatSession extends Equatable {
  final String sessionId;
  final String lessonId;
  final String lessonTitle;
  final String userId;
  final List<AiChatMessage> messages;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  const AiChatSession({
    required this.sessionId,
    required this.lessonId,
    required this.lessonTitle,
    required this.userId,
    required this.messages,
    required this.createdAt,
    this.lastActiveAt,
  });

  /// Create session ID format: user_{userId}_lesson_{lessonId}
  static String createSessionId(String userId, String lessonId) {
    return 'user_${userId}_lesson_$lessonId';
  }

  /// Create new session
  factory AiChatSession.create({
    required String userId,
    required String lessonId,
    required String lessonTitle,
  }) {
    final sessionId = createSessionId(userId, lessonId);
    final now = DateTime.now();
    
    return AiChatSession(
      sessionId: sessionId,
      lessonId: lessonId,
      lessonTitle: lessonTitle,
      userId: userId,
      messages: [AiChatMessage.welcome(lessonTitle)],
      createdAt: now,
      lastActiveAt: now,
    );
  }

  /// Add message to session
  AiChatSession addMessage(AiChatMessage message) {
    return AiChatSession(
      sessionId: sessionId,
      lessonId: lessonId,
      lessonTitle: lessonTitle,
      userId: userId,
      messages: [...messages, message],
      createdAt: createdAt,
      lastActiveAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        lessonId,
        lessonTitle,
        userId,
        messages,
        createdAt,
        lastActiveAt,
      ];
}

