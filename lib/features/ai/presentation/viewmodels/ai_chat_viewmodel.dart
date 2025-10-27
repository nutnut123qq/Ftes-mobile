import 'package:flutter/foundation.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/usecases/send_ai_message_usecase.dart';
import '../../domain/constants/ai_constants.dart';
import '../../domain/entities/ai_chat_session.dart';
import '../../../../core/error/failures.dart';

/// ViewModel for AI Chat feature with async optimization
class AiChatViewModel extends ChangeNotifier {
  final SendAiMessageUseCase sendAiMessageUseCase;
  final String userId;

  // State
  List<AiChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  AiChatSession? _currentSession;

  AiChatViewModel({
    required this.sendAiMessageUseCase,
    required this.userId,
  });

  // Getters
  List<AiChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize chat session for a specific lesson
  Future<void> initializeLessonChat(String lessonId, String lessonTitle) async {
    try {
      _currentSession = AiChatSession.create(
        userId: userId,
        lessonId: lessonId,
        lessonTitle: lessonTitle,
      );

      _messages = _currentSession!.messages;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      print('❌ Initialize lesson chat error: $e');
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
        },
      );
    } catch (e) {
      print('❌ Send message error: $e');
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

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
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

