import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/video_knowledge.dart';

/// Remote data source interface for AI Chat
abstract class AiChatRemoteDataSource {
  /// Check if video has knowledge
  /// 
  /// Args:
  ///   - videoId: ID of the video/lesson
  /// 
  /// Returns:
  ///   - VideoKnowledge containing knowledge status
  Future<VideoKnowledge> checkVideoKnowledge(String videoId);

  /// Send a message to AI and get response
  /// 
  /// Args:
  ///   - message: User's question
  ///   - lessonId: ID of the lesson (used as video_id in API)
  ///   - lessonTitle: Title of the lesson
  ///   - sessionId: Chat session identifier
  /// 
  /// Returns:
  ///   - AiChatMessage containing AI response
  Future<AiChatMessage> sendMessage({
    required String message,
    required String lessonId,
    required String lessonTitle,
    required String sessionId,
  });
}

