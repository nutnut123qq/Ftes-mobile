/// Constants for Cart feature
class CartConstants {
  // Message codes
  static const String successCode = 'M001';
  static const String alreadyInCartCode = 'M004';
  
  // Success messages
  static const String addToCartSuccess = 'Đã thêm khóa học vào giỏ hàng';
  static const String alreadyInCartSuccess = 'Khóa học đã có trong giỏ hàng';
  static const String removeFromCartSuccess = 'Đã xóa khóa học khỏi giỏ hàng';
  
  // Error messages
  static const String addToCartError = 'Không thể thêm khóa học vào giỏ hàng';
  static const String removeFromCartError = 'Không thể xóa khóa học khỏi giỏ hàng';
  static const String loadCartError = 'Không thể tải danh sách giỏ hàng';
  static const String loadCartCountError = 'Không thể tải số lượng giỏ hàng';
  static const String alreadyInCartError = 'Khóa học đã có trong giỏ hàng';
  static const String networkError = 'Lỗi kết nối mạng';
  static const String serverError = 'Lỗi máy chủ';
  
  // Default values
  static const int defaultPageSize = 10;
  static const int defaultPageNumber = 1;
  static const String defaultSortOrder = 'ASC';
  static const String defaultSortField = 'createdAt';
  
  // UI messages
  static const String emptyCartTitle = 'Giỏ hàng trống';
  static const String emptyCartMessage = 'Bạn chưa có khóa học nào trong giỏ hàng';
  static const String loadingMessage = 'Đang tải...';
  static const String retryMessage = 'Thử lại';
}
