/// Constants for Order/Payment feature
class OrderConstants {
  // Payment status codes
  static const String paymentStatusSuccess = 'success';
  static const String paymentStatusError = 'error_price';
  static const String paymentStatusPending = 'PENDING';
  static const String paymentStatusCompleted = 'COMPLETED';
  static const String paymentStatusCancelled = 'CANCELLED';

  // Success messages
  static const String createOrderSuccess = 'Đã tạo đơn hàng thành công';
  static const String cancelOrderSuccess = 'Đã hủy đơn hàng chờ xử lý';
  static const String paymentSuccessMessage = 'Thanh toán thành công!';
  static const String enrollmentSuccessMessage = 'Bạn đã đăng ký khóa học thành công';

  // Error messages
  static const String createOrderError = 'Không thể tạo đơn hàng';
  static const String getOrderError = 'Không thể tải thông tin đơn hàng';
  static const String getAllOrdersError = 'Không thể tải lịch sử đơn hàng';
  static const String cancelOrderError = 'Không thể hủy đơn hàng';
  static const String paymentErrorPrice = 'Số tiền thanh toán không khớp. Bạn đã được cộng điểm bồi thường.';
  static const String qrCodeLoadError = 'Không thể tải mã QR';

  // WebSocket configuration
  static const String wsEndpoint = '/ws';
  static const String paymentTopicPrefix = '/topic/payments/';
  static const String wsSuccessStatus = 'success';
  static const String wsErrorPriceStatus = 'error_price';
  
  // Connection settings
  static const Duration wsConnectionTimeout = Duration(seconds: 10);
  static const Duration wsReconnectDelay = Duration(seconds: 5);

  // UI messages
  static const String qrCodeTitle = 'Quét mã QR để thanh toán';
  static const String qrCodePlaceholder = 'Mã QR';
  static const String qrCodeInstructions = 'Quét mã QR bằng ứng dụng ngân hàng để hoàn tất thanh toán';
  static const String qrCodeAutoProcess = 'Sau khi thanh toán thành công, đơn hàng sẽ được xử lý tự động';
  static const String viewMyCoursesButton = 'Xem khóa học của tôi';

  // Default values
  static const int defaultOrderPageSize = 10;
  static const int defaultOrderPageNumber = 1;
}


