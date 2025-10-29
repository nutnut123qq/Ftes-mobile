/// Constants for Course feature
class CourseConstants {
  // Private constructor to prevent instantiation
  CourseConstants._();

  // ========== Error Messages ==========
  static const String errorLoadCourseFailed = 'Không thể tải thông tin khóa học';
  static const String errorLoadProfileFailed = 'Không thể tải thông tin giảng viên';
  static const String errorCheckEnrollmentFailed = 'Không thể kiểm tra trạng thái đăng ký';
  static const String errorEnrollFailed = 'Không thể đăng ký khóa học';
  static const String errorNetworkConnection = 'Không có kết nối internet';
  static const String errorUnexpected = 'Đã xảy ra lỗi không mong muốn';
  static const String errorInvalidResponse = 'Dữ liệu trả về không hợp lệ';
  static const String errorNotEnrolled = 'Bạn chưa đăng ký khóa học này';
  static const String errorVideoNotAvailable = 'Video chưa được tải lên';
  static const String errorAddToCartFailed = 'Không thể thêm vào giỏ hàng';
  
  // ========== Loading Messages ==========
  static const String loadingCourseDetail = 'Đang tải thông tin khóa học...';
  static const String loadingProfile = 'Đang tải thông tin giảng viên...';
  static const String loadingEnrollment = 'Đang kiểm tra trạng thái đăng ký...';
  static const String loadingVideo = 'Đang tải video...';
  
  // ========== UI Text ==========
  static const String tabIntroduction = 'Giới thiệu';
  static const String tabCurriculum = 'Chương trình học';
  static const String titleCourseIntroduction = 'Giới thiệu khóa học';
  static const String titleInstructor = 'Giảng viên';
  static const String titleWhatYouWillLearn = 'Bạn sẽ học được gì';
  static const String titleReviews = 'Đánh giá';
  static const String titleCurriculum = 'Chương trình học';
  static const String buttonEnrollFree = 'Tham gia miễn phí';
  static const String buttonAddToCart = 'Thêm vào giỏ hàng';
  static const String buttonViewCart = 'Xem giỏ hàng';
  static const String labelFree = 'Miễn phí';
  static const String labelStudents = 'học viên';
  static const String labelLessons = 'bài học';
  static const String labelMinutes = 'phút';
  static const String labelReviews = 'đánh giá';
  static const String defaultInstructorTitle = 'Giảng viên chuyên nghiệp';
  static const String defaultInstructorName = 'Giảng viên';
  static const String defaultDescription = 'Không có mô tả';
  static const String defaultBenefitPrefix = 'Kiến thức';
  
  // ========== Success Messages ==========
  static const String successAddedToCart = 'Đã thêm khóa học vào giỏ hàng';
  static const String successEnrolled = 'Đăng ký khóa học thành công';
  
  // ========== Snackbar Messages ==========
  static const String messageNeedPurchase = 'Bạn cần mua khóa học để xem video';
  
  // ========== Default Values ==========
  static const int defaultCourseDetailThreshold = 10; // Số parts để trigger compute isolate
  static const int defaultLessonThreshold = 30; // Tổng số lessons để trigger compute isolate
  
  // ========== Fallback Benefits ==========
  static const List<String> defaultBenefits = [
    'Kiến thức cơ bản về lập trình',
    'Thực hành với các bài tập thực tế',
    'Kỹ năng giải quyết vấn đề',
  ];
}

