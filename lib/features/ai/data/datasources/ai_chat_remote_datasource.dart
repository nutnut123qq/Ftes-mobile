import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/video_knowledge.dart';

/// Remote data source interface for AI Chat
abstract class AiChatRemoteDataSource {
  /// Check if video has knowledge
  /// 
  /// Args:
  ///   - videoId: Video ID for HLS streaming (e.g., "video_ab83bee3-b55")
  /// 
  /// Returns:
  ///   - VideoKnowledge containing knowledge status
  Future<VideoKnowledge> checkVideoKnowledge(String videoId);

  /// Send a message to AI and get response
  /// 
  /// Args:
  ///   - message: User's question
  ///   - videoId: Video ID for HLS streaming (e.g., "video_ab83bee3-b55")
  ///   - lessonTitle: Title of the lesson
  ///   - sessionId: Chat session identifier
  /// 
  /// Returns:
  ///   - AiChatMessage containing AI response
  Future<AiChatMessage> sendMessage({
    required String message,
    required String videoId,
    required String lessonTitle,
    required String sessionId,
  });
}

