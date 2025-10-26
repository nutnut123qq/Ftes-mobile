import '../models/course_detail_model.dart';
import '../models/profile_model.dart';

/// Abstract remote data source for course operations
abstract class CourseRemoteDataSource {
  /// Get course detail by slug name
  Future<CourseDetailModel> getCourseDetailBySlug(String slugName, String? userId);
  
  /// Get profile by userId
  Future<ProfileModel> getProfile(String userId);
  
  /// Check enrollment status for a user and course
  Future<bool> checkEnrollment(String userId, String courseId);
}
