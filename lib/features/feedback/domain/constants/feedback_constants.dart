/// Các hằng số phục vụ tính năng feedback
class FeedbackConstants {
  const FeedbackConstants._();

  static const int defaultPageNumber = 0;
  static const int defaultPageSize = 10;
  static const int computeThreshold = 50;

  // Thông điệp lỗi
  static const String errorLoadFeedbacks = 'Không thể tải danh sách đánh giá';
  static const String errorCreateFeedback = 'Không thể tạo đánh giá';
  static const String errorUpdateFeedback = 'Không thể cập nhật đánh giá';
  static const String errorDeleteFeedback = 'Không thể xoá đánh giá';
  static const String errorAverageRating = 'Không thể tính trung bình đánh giá';
  static const String errorUnexpectedFormat =
      'Dữ liệu phản hồi không đúng định dạng';

  // Thông điệp hiển thị
  static const String successSubmitMessage = 'Đánh giá đã được gửi thành công!';
  static const String errorSubmitMessage =
      'Không thể gửi đánh giá. Vui lòng thử lại.';
}
