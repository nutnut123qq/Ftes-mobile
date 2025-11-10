import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/usecases/send_ai_message_usecase.dart';
import '../../domain/constants/ai_constants.dart';
import '../../domain/entities/ai_chat_session.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/ai_chat_local_datasource.dart';

/// ViewModel for AI Chat feature with async optimization
class AiChatViewModel extends ChangeNotifier {
  final SendAiMessageUseCase sendAiMessageUseCase;
  final AiChatLocalDataSource localDataSource;
  final String userId;

  // State
  List<AiChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  AiChatSession? _currentSession;
  String? _videoId; // Video ID for HLS streaming
  String? _lessonDescription; // Lesson description to combine with title
  
  // Batch state updates
  bool _isNotifying = false;

  AiChatViewModel({
    required this.sendAiMessageUseCase,
    required this.localDataSource,
    required this.userId,
  });

  // Getters
  List<AiChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize chat session for a specific lesson
  Future<void> initializeLessonChat(
    String lessonId, 
    String lessonTitle, 
    String videoId,
    String? lessonDescription,
  ) async {
    try {
      // Clear previous session messages first to avoid showing messages from different lessons
      _messages = [];
      _errorMessage = null;
      _isLoading = false;
      
      _videoId = videoId;
      _lessonDescription = lessonDescription;
      _currentSession = AiChatSession.create(
        userId: userId,
        lessonId: lessonId,
        lessonTitle: lessonTitle,
      );

      // Load cached messages for this specific lesson
      final cached = await localDataSource.getCachedMessages(
        _currentSession!.sessionId,
      );
      
      if (cached != null && cached.isNotEmpty) {
        // Verify cached messages belong to the same lesson
        _messages = cached;
      } else {
        // Start fresh with welcome message
        _messages = _currentSession!.messages;
      }

      // Cache session
      unawaited(
        localDataSource.cacheChatSession(_currentSession!.sessionId, _currentSession!)
          .catchError((_) {}),
      );

      _notifyIfNeeded();
    } catch (e) {
      debugPrint('❌ Initialize lesson chat error: $e');
      _setError('Không thể khởi tạo chat');
    }
  }

  /// Send a message to AI (async/await optimization)
  Future<void> sendMessage(String content) async {
    // Input validation
    final trimmedContent = content.trim();
    if (trimmedContent.isEmpty || _currentSession == null) {
      return;
    }

    // Validate message length (max 5000 chars)
    if (trimmedContent.length > 5000) {
      _setError('Tin nhắn quá dài (tối đa 5000 ký tự)');
      return;
    }

    if (_currentSession!.lessonId.isEmpty || _currentSession!.lessonTitle.isEmpty) {
      _setError(AiConstants.errorMissingSessionId);
      return;
    }

    // Add user message immediately
    final userMessage = AiChatMessage.user(trimmedContent);
    _addMessage(userMessage);

    // Send to AI asynchronously
    _setLoading(true);
    _clearError();

    if (_videoId == null || _videoId!.isEmpty) {
      _setError('Video ID không hợp lệ');
      return;
    }

    try {
      // Combine lesson title with description: "Buổi N - Description"
      final fullLessonTitle = _lessonDescription != null && _lessonDescription!.isNotEmpty
          ? '${_currentSession!.lessonTitle} - $_lessonDescription'
          : _currentSession!.lessonTitle;
      
      final result = await sendAiMessageUseCase.call(
        SendAiMessageParams(
          message: trimmedContent,
          videoId: _videoId!,
          lessonTitle: fullLessonTitle,
          sessionId: 'default', // API requires 'default' session ID
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
          if (_currentSession != null) {
            unawaited(
              localDataSource.cacheMessages(
                _currentSession!.sessionId,
                _messages,
              ).catchError((_) {}),
            );
          }
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
    _notifyIfNeeded();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    _notifyIfNeeded();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    _notifyIfNeeded();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    _notifyIfNeeded();
  }

  /// Batch state updates to reduce rebuilds
  void _notifyIfNeeded() {
    if (!_isNotifying) {
      _isNotifying = true;
      Future.microtask(() {
        notifyListeners();
        _isNotifying = false;
      });
    }
  }

  /// Handle failure
  void _handleFailure(Failure failure) {
    if (failure is ServerFailure) {
      _setError(failure.message);
    } else if (failure is NetworkFailure) {
      _setError(AiConstants.errorNetworkConnection);
    } else if (failure is ValidationFailure) {
      _setError(failure.message);
    } else {
      _setError(AiConstants.errorUnexpected);
    }
  }
}

