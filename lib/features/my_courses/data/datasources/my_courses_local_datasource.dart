import '../models/my_course_model.dart';

/// Local cache for My Courses feature
abstract class MyCoursesLocalDataSource {
  /// Cache user courses by user ID
  Future<void> cacheUserCourses(String userId, List<MyCourseModel> courses, Duration ttl);
  
  /// Get cached user courses by user ID
  Future<List<MyCourseModel>?> getCachedUserCourses(String userId, Duration ttl);
  
  /// Invalidate user courses cache by user ID
  Future<void> invalidateUserCourses(String userId);
  
  /// Clear all my courses cache
  Future<void> clearAllCache();
}

