# AI FEATURE - CACHE IMPLEMENTATION EXAMPLES

## 📋 TỔNG QUAN
File này cung cấp các ví dụ code cụ thể để implement cache layer cho AI feature, dựa trên pattern đã được sử dụng trong `CourseLocalDataSource` và `BlogLocalDataSource`.

---

## 1. AI CHAT LOCAL DATA SOURCE INTERFACE

```dart
// lib/features/ai/data/datasources/ai_chat_local_datasource.dart

import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/ai_chat_session.dart';
import '../../domain/entities/video_knowledge.dart';

/// Local cache for AI Chat feature
abstract class AiChatLocalDataSource {
  // Chat session cache
  Future<void> cacheChatSession(String sessionId, AiChatSession session);
  Future<AiChatSession?> getCachedChatSession(String sessionId);
  Future<void> invalidateChatSession(String sessionId);
  
  // Chat messages cache (per session)
  Future<void> cacheMessages(String sessionId, List<AiChatMessage> messages);
  Future<List<AiChatMessage>?> getCachedMessages(String sessionId);
  Future<void> clearMessages(String sessionId);
  
  // Video knowledge cache
  Future<void> cacheVideoKnowledge(String videoId, VideoKnowledge knowledge, Duration ttl);
  Future<VideoKnowledge?> getCachedVideoKnowledge(String videoId, Duration ttl);
  Future<void> invalidateVideoKnowledge(String videoId);
  
  // Clear all cache
  Future<void> clearAllCache();
}
```

---

## 2. AI CHAT LOCAL DATA SOURCE IMPLEMENTATION

```dart
// lib/features/ai/data/datasources/ai_chat_local_datasource_impl.dart

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
    final key = '$_sessionPrefix$sessionId';
    await sharedPreferences.remove(key);
    // Also clear messages for this session
    await clearMessages(sessionId);
  }

  @override
  Future<void> cacheMessages(String sessionId, List<AiChatMessage> messages) async {
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
    final key = '$_messagesPrefix$sessionId';
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> cacheVideoKnowledge(
    String videoId,
    VideoKnowledge knowledge,
    Duration ttl,
  ) async {
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
    final key = '$_knowledgePrefix$videoId';
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> clearAllCache() async {
    final keys = sharedPreferences.getKeys()
        .where((key) => key.startsWith(_sessionPrefix) ||
                       key.startsWith(_messagesPrefix) ||
                       key.startsWith(_knowledgePrefix))
        .toList();
    
    for (final key in keys) {
      await sharedPreferences.remove(key);
    }
  }
}
```

---

## 3. UPDATE REPOSITORY WITH CACHE-FIRST STRATEGY

```dart
// lib/features/ai/data/repositories/ai_chat_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/video_knowledge.dart';
import '../../domain/repositories/ai_chat_repository.dart';
import '../../domain/constants/ai_constants.dart';
import '../datasources/ai_chat_remote_datasource.dart';
import '../datasources/ai_chat_local_datasource.dart';
import 'dart:async';

/// Repository implementation for AI Chat feature with cache-first strategy
class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteDataSource remoteDataSource;
  final AiChatLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AiChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, VideoKnowledge>> checkVideoKnowledge(String videoId) async {
    // 1. Try cache first (even offline)
    final cached = await localDataSource.getCachedVideoKnowledge(
      videoId,
      const Duration(hours: 24), // Cache for 24 hours
    );
    if (cached != null) {
      return Right(cached);
    }

    // 2. Check network
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    // 3. Fetch from network
    try {
      final knowledge = await remoteDataSource.checkVideoKnowledge(videoId);
      
      // 4. Cache for next time (async, don't block)
      unawaited(
        localDataSource.cacheVideoKnowledge(
          videoId,
          knowledge,
          const Duration(hours: 24),
        ).catchError((_) {}),
      );
      
      return Right(knowledge);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AiChatMessage>> sendMessage({
    required String message,
    required String lessonId,
    required String lessonTitle,
    required String sessionId,
    required String userId,
  }) async {
    // Check network
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final aiMessage = await remoteDataSource.sendMessage(
        message: message,
        lessonId: lessonId,
        lessonTitle: lessonTitle,
        sessionId: sessionId,
      );
      
      // Cache message (async, don't block)
      // Note: We'll update the full message list in ViewModel
      unawaited(
        _updateCachedMessages(sessionId, aiMessage).catchError((_) {}),
      );
      
      return Right(aiMessage);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  /// Update cached messages for a session
  Future<void> _updateCachedMessages(
    String sessionId,
    AiChatMessage newMessage,
  ) async {
    final cached = await localDataSource.getCachedMessages(sessionId);
    final updated = [
      ...?cached,
      newMessage,
    ];
    await localDataSource.cacheMessages(sessionId, updated);
  }
}
```

---

## 4. UPDATE VIEWMODEL WITH CACHE SUPPORT

```dart
// lib/features/ai/presentation/viewmodels/ai_chat_viewmodel.dart

// ... existing imports ...
import '../../data/datasources/ai_chat_local_datasource.dart';

class AiChatViewModel extends ChangeNotifier {
  final SendAiMessageUseCase sendAiMessageUseCase;
  final AiChatLocalDataSource localDataSource; // Add this
  final String userId;

  // ... existing state ...

  AiChatViewModel({
    required this.sendAiMessageUseCase,
    required this.localDataSource, // Add this
    required this.userId,
  });

  /// Initialize chat session for a specific lesson
  Future<void> initializeLessonChat(String lessonId, String lessonTitle) async {
    try {
      _currentSession = AiChatSession.create(
        userId: userId,
        lessonId: lessonId,
        lessonTitle: lessonTitle,
      );

      // Load cached messages
      final cached = await localDataSource.getCachedMessages(
        _currentSession!.sessionId,
      );
      
      if (cached != null && cached.isNotEmpty) {
        _messages = cached;
      } else {
        _messages = _currentSession!.messages;
      }

      // Cache session
      unawaited(
        localDataSource.cacheChatSession(_currentSession!, _currentSession!)
          .catchError((_) {}),
      );

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Initialize lesson chat error: $e');
      _setError('Không thể khởi tạo chat');
    }
  }

  /// Send a message to AI (async/await optimization)
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || _currentSession == null) {
      return;
    }

    if (_currentSession!.lessonId.isEmpty || _currentSession!.lessonTitle.isEmpty) {
      _setError(AiConstants.errorMissingSessionId);
      return;
    }

    // Add user message immediately
    final userMessage = AiChatMessage.user(content);
    _addMessage(userMessage);

    // Send to AI asynchronously
    _setLoading(true);
    _clearError();

    try {
      final result = await sendAiMessageUseCase.call(
        SendAiMessageParams(
          message: content,
          lessonId: _currentSession!.lessonId,
          lessonTitle: _currentSession!.lessonTitle,
          sessionId: _currentSession!.sessionId,
          userId: userId,
        ),
      );

      // Handle response
      result.fold(
        (failure) => _handleFailure(failure),
        (aiMessage) {
          _clearError();
          _addMessage(aiMessage);
          _currentSession = _currentSession!.addMessage(aiMessage);
          
          // Cache updated messages (async, don't block)
          unawaited(
            localDataSource.cacheMessages(
              _currentSession!.sessionId,
              _messages,
            ).catchError((_) {}),
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Send message error: $e');
      _setError('Không thể gửi tin nhắn: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Add message to list
  void _addMessage(AiChatMessage message) {
    _messages = [..._messages, message];
    notifyListeners();
  }

  // ... rest of the code ...
}
```

---

## 5. UPDATE DEPENDENCY INJECTION

```dart
// lib/features/ai/di/ai_injection.dart

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../data/datasources/ai_chat_remote_datasource.dart';
import '../data/datasources/ai_chat_remote_datasource_impl.dart';
import '../data/datasources/ai_chat_local_datasource.dart';
import '../data/datasources/ai_chat_local_datasource_impl.dart';
import '../data/repositories/ai_chat_repository_impl.dart';
import '../domain/repositories/ai_chat_repository.dart';
import '../domain/usecases/send_ai_message_usecase.dart';
import '../domain/usecases/check_video_knowledge_usecase.dart';
import '../presentation/viewmodels/ai_chat_viewmodel.dart';

/// Dependency injection setup for AI Chat feature
class AiInjection {
  static void init(GetIt sl) {
    // Data sources
    sl.registerLazySingleton<AiChatRemoteDataSource>(
      () => AiChatRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );

    // Local data source
    sl.registerLazySingleton<AiChatLocalDataSource>(
      () => AiChatLocalDataSourceImpl(
        sharedPreferences: sl<SharedPreferences>(),
      ),
    );

    // Repositories
    sl.registerLazySingleton<AiChatRepository>(
      () => AiChatRepositoryImpl(
        remoteDataSource: sl<AiChatRemoteDataSource>(),
        localDataSource: sl<AiChatLocalDataSource>(), // Add this
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton<SendAiMessageUseCase>(
      () => SendAiMessageUseCase(sl<AiChatRepository>()),
    );

    sl.registerLazySingleton<CheckVideoKnowledgeUseCase>(
      () => CheckVideoKnowledgeUseCase(sl<AiChatRepository>()),
    );

    // ViewModels (factory để tạo mới mỗi lần)
    sl.registerFactory<AiChatViewModel>(
      () {
        // Get user ID from SharedPreferences
        final sharedPreferences = sl<SharedPreferences>();
        final userId = sharedPreferences.getString('user_id') ?? '';
        
        return AiChatViewModel(
          sendAiMessageUseCase: sl<SendAiMessageUseCase>(),
          localDataSource: sl<AiChatLocalDataSource>(), // Add this
          userId: userId,
        );
      },
    );
  }
}
```

---

## 6. UPDATE REMOTE DATASOURCE WITH RETRY & TIMEOUT

```dart
// lib/features/ai/data/datasources/ai_chat_remote_datasource_impl.dart

// ... existing imports ...
import '../../../../core/utils/retry_helper.dart';

class AiChatRemoteDataSourceImpl implements AiChatRemoteDataSource {
  // ... existing code ...

  @override
  Future<AiChatMessage> sendMessage({
    required String message,
    required String lessonId,
    required String lessonTitle,
    required String sessionId,
  }) async {
    try {
      debugPrint('🤖 Sending message to AI: $message');

      // Create request model
      final request = AiChatRequestModel(
        message: message,
        videoId: lessonId,
        lessonTitle: lessonTitle,
        sessionId: sessionId,
        prompt: message,
      );

      final url = '${AppConstants.aiChatBaseUrl}${AppConstants.aiChatEndpoint}';
      final dio = _apiClient.dio;
      final token = await _getAccessToken();
      
      // Use retry with exponential backoff
      final response = await retryWithBackoff(
        () => dio.post(
          url,
          data: request.toJson(),
          options: Options(
            headers: token != null ? {'Authorization': 'Bearer $token'} : null,
            receiveTimeout: const Duration(seconds: 60), // AI can take time
            sendTimeout: const Duration(seconds: 30),
          ),
        ),
        maxRetries: 3,
        initialDelay: const Duration(seconds: 2),
      );

      debugPrint('📥 AI response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Parse in isolate using helper
        final aiMessage = await AiJsonParserHelper.parseAiChatResponseInIsolate(
          responseData,
        );
        
        debugPrint('✅ AI response received');
        return aiMessage;
      } else {
        throw ServerException(
          response.data?['messageDTO']?['message'] ??
              AiConstants.errorSendMessageFailed,
        );
      }
    } catch (e) {
      debugPrint('❌ Send message error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${AiConstants.errorSendMessageFailed}: ${e.toString()}');
    }
  }
}
```

---

## 7. ADD CACHE TTL CONSTANTS

```dart
// lib/features/ai/domain/constants/ai_constants.dart

class AiConstants {
  // ... existing constants ...

  // ========== Cache TTL ==========
  static const Duration cacheVideoKnowledgeTTL = Duration(hours: 24);
  static const Duration cacheChatSessionTTL = Duration(days: 7);
  static const Duration cacheMessagesTTL = Duration(days: 30);
}
```

---

## 📝 NOTES

1. **Async Cache Updates**: Luôn dùng `unawaited()` cho cache operations để không block response
2. **Error Handling**: Cache operations nên có `.catchError((_) {})` để không crash app
3. **TTL Strategy**: 
   - Video knowledge: 24 hours (ít thay đổi)
   - Chat session: 7 days (user có thể quay lại)
   - Messages: 30 days (lịch sử chat)
4. **Cache Keys**: Sử dụng prefix để dễ quản lý và clear cache
5. **Memory vs Storage**: Messages có thể lớn, nên cache vào SharedPreferences hoặc SQLite

---

## ✅ TESTING CHECKLIST

- [ ] Test cache hit (load from cache)
- [ ] Test cache miss (fetch from network)
- [ ] Test cache expiration (TTL)
- [ ] Test offline scenario (use cache only)
- [ ] Test chat history persistence (close and reopen app)
- [ ] Test cache invalidation
- [ ] Test concurrent access (multiple sessions)

