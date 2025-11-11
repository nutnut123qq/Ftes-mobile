/// Constants for Home feature
class HomeConstants {
  // Error Messages
  static const String errorLoadingCourses = 'Không thể tải danh sách khóa học';
  static const String errorLoadingBanners = 'Không thể tải banner';
  static const String errorLoadingCategories = 'Không thể tải danh mục';
  static const String errorLoadingUserProfile = 'Không thể tải thông tin người dùng';
  static const String errorNoInternet = 'Không có kết nối internet';
  static const String errorServerError = 'Lỗi máy chủ, vui lòng thử lại sau';
  
  // Loading Messages
  static const String loadingCourses = 'Đang tải khóa học...';
  static const String loadingBanners = 'Đang tải banner...';
  static const String loadingCategories = 'Đang tải danh mục...';
  static const String loadingUserProfile = 'Đang tải thông tin...';
  
  // Success Messages
  static const String loadedCoursesSuccess = 'Đã tải khóa học thành công';
  static const String loadedBannersSuccess = 'Đã tải banner thành công';
  static const String loadedCategoriesSuccess = 'Đã tải danh mục thành công';
  
  // Empty States
  static const String noCoursesAvailable = 'Không có khóa học nào';
  static const String noBannersAvailable = 'Không có banner nào';
  static const String noCategoriesAvailable = 'Không có danh mục nào';
  
  // Default Values
  static const String defaultUserName = 'User';
  static const String defaultCategoryId = 'all';
  static const String defaultCategoryName = 'Tất cả';
  static const int defaultPageSize = 50;
  static const int defaultBannerAutoPlayDuration = 3;
  
  // UI Text
  static const String greetingText = 'Xin chào! 👋';
  static const String searchPlaceholder = 'Tìm kiếm khóa học...';
  static const String popularCoursesTitle = 'Khóa học phổ biến';
  static const String topMentorsTitle = 'Giảng viên hàng đầu';
  static const String allCategoriesLabel = 'Tất cả';

  // Featured Category IDs (mirror web sections)
  // DEV căn bản, không lo PHÍ
  static const String categoryDevFree = '9f59a8bf-490c-4645-a60e-02c83a279bc3';
  // Từ Zero đến Pro-Dev
  static const String categoryZeroToPro = '2837e815-2ed8-49af-b0c3-6d3d8d883640';
  // Tư duy toán học cho dân Dev
  static const String categoryMathForDev = '2bbb2eed-d14d-43f2-b4a9-28fe867d49cb';
  // Dev chinh phục Ngoại ngữ
  static const String categoryLanguageForDev = 'bc669cc6-a425-4af3-93b7-7eb66f666649';
}

