/// Constants for Blog feature
class BlogConstants {
  // Error Messages
  static const String errorLoadingBlogs = 'Không thể tải danh sách bài viết';
  static const String errorLoadingBlogDetail = 'Không thể tải chi tiết bài viết';
  static const String errorLoadingCategories = 'Không thể tải danh mục bài viết';
  static const String errorSearchingBlogs = 'Không thể tìm kiếm bài viết';
  static const String errorNoInternet = 'Không có kết nối internet';
  static const String errorServerError = 'Lỗi máy chủ, vui lòng thử lại sau';
  static const String errorInvalidData = 'Dữ liệu không hợp lệ';
  
  // Loading Messages
  static const String loadingBlogs = 'Đang tải bài viết...';
  static const String loadingBlogDetail = 'Đang tải chi tiết...';
  static const String loadingCategories = 'Đang tải danh mục...';
  static const String loadingMore = 'Đang tải thêm...';
  static const String searching = 'Đang tìm kiếm...';
  
  // Success Messages
  static const String loadedBlogsSuccess = 'Đã tải bài viết thành công';
  static const String loadedCategoriesSuccess = 'Đã tải danh mục thành công';
  static const String searchSuccess = 'Tìm kiếm thành công';
  
  // Empty States
  static const String noBlogsAvailable = 'Không có bài viết nào';
  static const String noCategoriesAvailable = 'Không có danh mục nào';
  static const String noSearchResults = 'Không tìm thấy kết quả';
  static const String noBlogDetail = 'Không tìm thấy bài viết';
  
  // Default Values
  static const int defaultPageSize = 10;
  static const int defaultPageNumber = 1;
  static const String defaultSortField = 'createdAt';
  static const String defaultSortOrder = 'desc';
  static const int computeThreshold = 50; // Use compute isolate when list > 50 items
  static const int averageReadingSpeed = 200; // Words per minute
  
  // Pagination
  static const int loadMoreThreshold = 200; // Pixels from bottom to trigger load more
  static const int maxRetries = 3;
  
  // UI Text
  static const String blogListTitle = 'Blog';
  static const String allCategoriesLabel = 'Tất cả';
  static const String featuredPostLabel = 'Bài viết nổi bật';
  static const String blogPostsLabel = 'Bài viết';
  static const String totalLabel = 'Tổng';
  static const String retryLabel = 'Thử lại';
  static const String searchPlaceholder = 'Tìm kiếm bài viết...';
  static const String readTimeLabel = 'phút đọc';
  static const String noImageLabel = 'Không có ảnh';
  static const String imageLoadError = 'Không thể tải ảnh';
  
  // Date Format
  static const String justNow = 'Vừa xong';
  static const String minutesAgo = 'phút trước';
  static const String hoursAgo = 'giờ trước';
  static const String yesterday = 'Hôm qua';
  static const String daysAgo = 'ngày trước';
  static const String unknownDate = 'Không rõ';
}



