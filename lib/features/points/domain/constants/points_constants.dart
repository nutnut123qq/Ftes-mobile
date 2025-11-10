/// Các hằng số dùng cho tính năng quản lý điểm
class PointsConstants {
  const PointsConstants._();

  static const int defaultPage = 0;
  static const int defaultPageSize = 20;
  static const int computeThreshold = 50;

  static const String errorLoadSummary = 'Không thể tải thông tin điểm';
  static const String errorLoadTransactions = 'Không thể tải lịch sử giao dịch';
  static const String errorLoadReferral = 'Không thể tải thông tin giới thiệu';
  static const String errorLoadInvitedUsers =
      'Không thể tải danh sách người được mời';
  static const String errorLoadChart = 'Không thể tải biểu đồ điểm';
  static const String errorWithdraw = 'Không thể rút điểm';
  static const String errorSetReferral = 'Không thể thiết lập mã giới thiệu';
  static const String errorUnexpectedFormat =
      'Dữ liệu điểm trả về không đúng định dạng';

  static const String successWithdraw =
      'Yêu cầu rút điểm đã được gửi thành công!';
  static const String successSetReferral = 'Mã giới thiệu đã được cập nhật!';
}
