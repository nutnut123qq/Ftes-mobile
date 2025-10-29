import '../models/course_detail_model.dart';

/// Abstract local data source for Course operations
abstract class CourseLocalDataSource {
  /// Cache course detail
  Future<void> cacheCourseDetail(String courseId, CourseDetailModel courseDetail);

  /// Get cached course detail
  Future<CourseDetailModel?> getCachedCourseDetail(String courseId);

  /// Check if cache is valid (not expired)
  Future<bool> isCacheValid(String courseId);

  /// Clear cache for specific course
  Future<void> clearCourseCache(String courseId);

  /// Clear all course cache
  Future<void> clearAllCache();
}

