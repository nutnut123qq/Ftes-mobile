import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ai_chat_message.dart';
import '../entities/video_knowledge.dart';

/// Repository interface for AI Chat feature
abstract class AiChatRepository {
  /// Check if video has knowledge
  /// 
  /// Args:
  ///   - videoId: ID of the video/lesson
  /// 
  /// Returns:
  ///   - Either&lt;Failure, VideoKnowledge&gt; containing knowledge status
  Future<Either<Failure, VideoKnowledge>> checkVideoKnowledge(String videoId);

  /// Send a message to AI and get response
  /// 
  /// Args:
  ///   - message: User's question
  ///   - lessonId: ID of the lesson (used as video_id in API)
  ///   - lessonTitle: Title of the lesson
  ///   - sessionId: Chat session identifier
  ///   - userId: User ID for session tracking
  /// 
  /// Returns:
  ///   - Either&lt;Failure, AiChatMessage&gt; containing AI response
  Future<Either<Failure, AiChatMessage>> sendMessage({
    required String message,
    required String lessonId,
    required String lessonTitle,
    required String sessionId,
    required String userId,
  });
}

