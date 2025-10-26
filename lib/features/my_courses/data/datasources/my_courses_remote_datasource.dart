import '../models/my_course_model.dart';

/// Remote data source interface for My Courses feature
abstract class MyCoursesRemoteDataSource {
  /// Get user's enrolled courses from remote API
  Future<List<MyCourseModel>> getUserCourses(String userId);
}
