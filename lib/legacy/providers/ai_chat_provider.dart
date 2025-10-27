import 'package:flutter/foundation.dart';
import '../../models/message_item.dart';
import '../services/ai_chat_service.dart';
import 'auth_provider.dart';

/// DEPRECATED: This provider has been moved to lib/features/ai
/// Please use AiChatViewModel instead
@Deprecated('Use lib/features/ai/presentation/viewmodels/ai_chat_viewmodel.dart instead')
class AIChatProvider extends ChangeNotifier {
  final AIChatService _aiChatService = AIChatService();
  final AuthProvider _authProvider;
  
  AIChatProvider(this._authProvider);
  
  // State
  List<MessageItem> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentLessonId;
  String? _currentLessonTitle;
  
  // Getters
  List<MessageItem> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  /// Initialize chat for a specific lesson
  void initializeLessonChat(String lessonId, String lessonTitle) {
    _currentLessonId = lessonId;
    _currentLessonTitle = lessonTitle;
    _messages = [
      MessageItem(
        id: 'welcome',
        content: 'Xin chào! Tôi là AI trợ giảng của bạn cho bài học "$lessonTitle". Hãy hỏi tôi bất cứ điều gì về bài học này nhé! 😊',
        time: _getCurrentTime(),
        isFromUser: false,
        type: MessageType.text,
      ),
    ];
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Send a message to AI
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || _currentLessonId == null || _currentLessonTitle == null) {
      return;
    }
    
    // Get user ID from auth provider (legacy code - deprecated)
    // Note: AuthProvider in legacy may not have currentUser getter
    final userId = 'legacy_user'; // Placeholder for backward compatibility
    if (userId.isEmpty) {
      _setError('Bạn cần đăng nhập để sử dụng AI chat');
      return;
    }
    
    // Add user message
    final userMessage = MessageItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      time: _getCurrentTime(),
      isFromUser: true,
      type: MessageType.text,
    );
    
    _messages.add(userMessage);
    notifyListeners();
    
    // Send to AI
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _aiChatService.chatWithLesson(
        message: content,
        lessonId: _currentLessonId!,
        lessonTitle: _currentLessonTitle!,
        userId: userId,
      );
      
      if (response.success) {
        final answer = response.getAnswer();
        
        if (answer != null && answer.isNotEmpty) {
          // Add AI response
          final aiMessage = MessageItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: answer,
            time: _getCurrentTime(),
            isFromUser: false,
            type: MessageType.text,
          );
          
          _messages.add(aiMessage);
        } else {
          throw Exception('AI không trả về câu trả lời');
        }
      } else {
        throw Exception(response.error ?? response.message);
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Không thể gửi tin nhắn: $e');
      
      // Add error message with details
      final errorMessage = MessageItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Xin lỗi, tôi gặp sự cố khi xử lý câu hỏi của bạn.\n\nLỗi: ${e.toString()}\n\nVui lòng thử lại sau.',
        time: _getCurrentTime(),
        isFromUser: false,
        type: MessageType.text,
      );
      
      _messages.add(errorMessage);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }
  
  /// Clear chat messages
  void clearMessages() {
    _messages = [];
    _currentLessonId = null;
    _currentLessonTitle = null;
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
  
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

