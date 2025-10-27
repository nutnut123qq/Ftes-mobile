/// Constants for My Courses feature
class MyCoursesConstants {
  // Private constructor to prevent instantiation
  MyCoursesConstants._();

  // ========== Error Messages ==========
  static const String errorLoadCoursesFailed = 'Không thể tải danh sách khóa học';
  static const String errorNetworkConnection = 'Không có kết nối internet';
  static const String errorInvalidResponse = 'Dữ liệu trả về không hợp lệ';
  static const String errorNoUserId = 'Không tìm thấy thông tin người dùng';
  
  // ========== Loading Messages ==========
  static const String loadingCourses = 'Đang tải khóa học...';
  
  // ========== UI Text ==========
  static const String titleMyCoursesPage = 'Khóa học của tôi';
  static const String searchHintText = 'Tìm kiếm khóa học...';
  static const String emptyCoursesTitle = 'Bạn chưa có khóa học nào';
  static const String emptyCoursesSubtitle = 'Hãy tham gia các khóa học để bắt đầu học tập';
  static const String emptySearchTitle = 'Không tìm thấy khóa học';
  static const String emptySearchSubtitle = 'Thử tìm kiếm với từ khóa khác';
  static const String retryButtonText = 'Thử lại';
  
  // ========== Default Values ==========
  static const int defaultCoursesThreshold = 20; // Số courses để trigger compute isolate
  static const int searchDebounceMs = 300; // Debounce time cho search (milliseconds)
}

