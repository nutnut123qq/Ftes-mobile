import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/ai_chat_session.dart';
import '../../domain/entities/video_knowledge.dart';

/// Local cache for AI Chat feature
abstract class AiChatLocalDataSource {
  /// Cache chat session
  Future<void> cacheChatSession(String sessionId, AiChatSession session);
  
  /// Get cached chat session
  Future<AiChatSession?> getCachedChatSession(String sessionId);
  
  /// Invalidate chat session cache
  Future<void> invalidateChatSession(String sessionId);
  
  /// Cache chat messages for a session
  Future<void> cacheMessages(String sessionId, List<AiChatMessage> messages);
  
  /// Get cached chat messages for a session
  Future<List<AiChatMessage>?> getCachedMessages(String sessionId);
  
  /// Clear messages for a session
  Future<void> clearMessages(String sessionId);
  
  /// Cache video knowledge with TTL
  Future<void> cacheVideoKnowledge(String videoId, VideoKnowledge knowledge, Duration ttl);
  
  /// Get cached video knowledge (checks TTL)
  Future<VideoKnowledge?> getCachedVideoKnowledge(String videoId, Duration ttl);
  
  /// Invalidate video knowledge cache
  Future<void> invalidateVideoKnowledge(String videoId);
  
  /// Clear all AI chat-related cache
  Future<void> clearAllCache();
}

