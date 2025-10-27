/// Constants for AI Chat feature
class AiConstants {
  // Private constructor to prevent instantiation
  AiConstants._();

  // ========== Endpoints ==========
  static const String aiChatEndpoint = '/api/ai/chat';

  // ========== Error Messages ==========
  static const String errorSendMessageFailed = 'Không thể gửi tin nhắn đến AI';
  static const String errorNetworkConnection = 'Không có kết nối internet';
  static const String errorUnexpected = 'Đã xảy ra lỗi không mong muốn';
  static const String errorInvalidResponse = 'Dữ liệu trả về không hợp lệ';
  static const String errorEmptyResponse = 'AI không trả về câu trả lời';
  static const String errorNotLoggedIn = 'Bạn cần đăng nhập để sử dụng AI chat';
  static const String errorMissingSessionId = 'Thiếu thông tin phiên chat';
  static const String errorCheckKnowledgeFailed = 'Không thể kiểm tra knowledge của bài học';
  static const String errorLessonNoKnowledge = 'Bài học này chưa có knowledge, không thể hỏi AI';

  // ========== Loading Messages ==========
  static const String loadingSendingMessage = 'Đang gửi tin nhắn...';
  static const String loadingAiProcessing = 'AI đang xử lý, vui lòng đợi...';

  // ========== Success Messages ==========
  static const String successMessageSent = 'Tin nhắn đã được gửi';

  // ========== UI Text ==========
  static const String hintMessageInput = 'Nhập câu hỏi của bạn...';
  static const String buttonSend = 'Gửi';
  static const String labelAiAssistant = 'AI Trợ Giảng';
  static const String labelOnline = 'Trực tuyến';

  // ========== Session Management ==========
  static const int sessionTimeoutMinutes = 60; // Session timeout after 60 minutes
  static const int maxRetries = 3;
  static const Duration requestTimeout = Duration(seconds: 30);

  // ========== Knowledge Check ==========
  static const String messageCheckingKnowledge = 'Đang kiểm tra knowledge...';
  static const String messageNoKnowledge = 'Bài học này chưa có knowledge, không thể hỏi AI';

  // ========== JSON Parsing Threshold ==========
  static const int jsonParsingThreshold = 10000; // Parse on isolate if response > 10KB
}

