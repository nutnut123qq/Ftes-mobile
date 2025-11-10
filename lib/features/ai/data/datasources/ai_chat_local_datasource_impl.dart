import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/ai_chat_session.dart';
import '../../domain/entities/video_knowledge.dart';
import 'ai_chat_local_datasource.dart';

class AiChatLocalDataSourceImpl implements AiChatLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // Cache keys
  static const String _sessionPrefix = 'ai_chat_session_';
  static const String _messagesPrefix = 'ai_chat_messages_';
  static const String _knowledgePrefix = 'ai_chat_knowledge_';

  AiChatLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheChatSession(String sessionId, AiChatSession session) async {
    try {
      final key = '$_sessionPrefix$sessionId';
      final payload = jsonEncode({
        'ts': DateTime.now().millisecondsSinceEpoch,
        'data': {
          'sessionId': session.sessionId,
          'lessonId': session.lessonId,
          'lessonTitle': session.lessonTitle,
          'userId': session.userId,
          'createdAt': session.createdAt.toIso8601String(),
          'lastActiveAt': session.lastActiveAt?.toIso8601String(),
        },
      });
      await sharedPreferences.setString(key, payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache chat session: $e');
    }
  }

  @override
  Future<AiChatSession?> getCachedChatSession(String sessionId) async {
    final key = '$_sessionPrefix$sessionId';
    final raw = sharedPreferences.getString(key);
    if (raw == null) return null;
    
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final data = map['data'] as Map<String, dynamic>;
      
      return AiChatSession(
        sessionId: data['sessionId'] as String,
        lessonId: data['lessonId'] as String,
        lessonTitle: data['lessonTitle'] as String,
        userId: data['userId'] as String,
        messages: [], // Messages are cached separately
        createdAt: DateTime.parse(data['createdAt'] as String),
        lastActiveAt: data['lastActiveAt'] != null
            ? DateTime.parse(data['lastActiveAt'] as String)
            : null,
      );
    } catch (_) {
      await sharedPreferences.remove(key);
      return null;
    }
  }

  @override
  Future<void> invalidateChatSession(String sessionId) async {
    try {
      final key = '$_sessionPrefix$sessionId';
      await sharedPreferences.remove(key);
      // Also clear messages for this session
      await clearMessages(sessionId);
    } catch (_) {
      // Silently fail
    }
  }

  @override
  Future<void> cacheMessages(String sessionId, List<AiChatMessage> messages) async {
    try {
      final key = '$_messagesPrefix$sessionId';
      final payload = jsonEncode({
        'ts': DateTime.now().millisecondsSinceEpoch,
        'data': messages.map((m) => {
          'id': m.id,
          'content': m.content,
          'timestamp': m.timestamp.toIso8601String(),
          'isFromUser': m.isFromUser,
          'type': m.type.name,
          'imageUrl': m.imageUrl,
        }).toList(),
      });
      await sharedPreferences.setString(key, payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache messages: $e');
    }
  }

  @override
  Future<List<AiChatMessage>?> getCachedMessages(String sessionId) async {
    final key = '$_messagesPrefix$sessionId';
    final raw = sharedPreferences.getString(key);
    if (raw == null) return null;
    
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final data = map['data'] as List<dynamic>;
      
      return data.map((json) {
        final m = json as Map<String, dynamic>;
        return AiChatMessage(
          id: m['id'] as String,
          content: m['content'] as String,
          timestamp: DateTime.parse(m['timestamp'] as String),
          isFromUser: m['isFromUser'] as bool,
          type: AiMessageType.values.firstWhere(
            (e) => e.name == m['type'] as String,
            orElse: () => AiMessageType.text,
          ),
          imageUrl: m['imageUrl'] as String?,
        );
      }).toList();
    } catch (_) {
      await sharedPreferences.remove(key);
      return null;
    }
  }

  @override
  Future<void> clearMessages(String sessionId) async {
    try {
      final key = '$_messagesPrefix$sessionId';
      await sharedPreferences.remove(key);
    } catch (_) {
      // Silently fail
    }
  }

  @override
  Future<void> cacheVideoKnowledge(
    String videoId,
    VideoKnowledge knowledge,
    Duration ttl,
  ) async {
    try {
      final key = '$_knowledgePrefix$videoId';
      final payload = jsonEncode({
        'ts': DateTime.now().millisecondsSinceEpoch,
        'ttl': ttl.inMilliseconds,
        'data': {
          'hasKnowledge': knowledge.hasKnowledge,
          'status': knowledge.status,
          'message': knowledge.message,
        },
      });
      await sharedPreferences.setString(key, payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache video knowledge: $e');
    }
  }

  @override
  Future<VideoKnowledge?> getCachedVideoKnowledge(
    String videoId,
    Duration ttl,
  ) async {
    final key = '$_knowledgePrefix$videoId';
    final raw = sharedPreferences.getString(key);
    if (raw == null) return null;
    
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final cachedTtl = (map['ttl'] as num?)?.toInt() ?? ttl.inMilliseconds;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      
      if (age > cachedTtl) {
        // Expired
        await sharedPreferences.remove(key);
        return null;
      }
      
      final data = map['data'] as Map<String, dynamic>;
      return VideoKnowledge(
        hasKnowledge: data['hasKnowledge'] as bool,
        status: data['status'] as String,
        message: data['message'] as String,
      );
    } catch (_) {
      await sharedPreferences.remove(key);
      return null;
    }
  }

  @override
  Future<void> invalidateVideoKnowledge(String videoId) async {
    try {
      final key = '$_knowledgePrefix$videoId';
      await sharedPreferences.remove(key);
    } catch (_) {
      // Silently fail
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      final keys = sharedPreferences.getKeys()
          .where((key) => key.startsWith(_sessionPrefix) ||
                         key.startsWith(_messagesPrefix) ||
                         key.startsWith(_knowledgePrefix))
          .toList();
      
      for (final key in keys) {
        await sharedPreferences.remove(key);
      }
    } catch (_) {
      // Silently fail
    }
  }
}

