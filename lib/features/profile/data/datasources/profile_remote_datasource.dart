import '../models/profile_model.dart';
import '../models/instructor_course_model.dart';
import '../models/upload_image_response_model.dart';

/// Abstract remote data source for profile operations
abstract class ProfileRemoteDataSource {
  /// Get profile by user ID
  Future<ProfileModel> getProfileById(String userId);

  /// Get profile by username
  Future<ProfileModel> getProfileByUsername(String userName, {String? postId});

  /// Get instructor profile by username
  Future<ProfileModel> getInstructorProfileByUsername(String userName);

  /// Get courses created by instructor
  Future<List<InstructorCourseModel>> getCoursesByCreator(String userId);

  /// Create new profile
  Future<ProfileModel> createProfile(String userId, Map<String, dynamic> requestData);

  /// Update existing profile
  Future<ProfileModel> updateProfile(String userId, Map<String, dynamic> requestData);

  /// Create profile automatically (for new users)
  Future<ProfileModel> createProfileAuto(String userId);

  /// Get participants count for instructor
  Future<int> getParticipantsCount(String instructorId);

  /// Check if user has applied to course
  Future<int> checkApplyCourse(String userId, String courseId);

  /// Upload image to GitHub
  Future<UploadImageResponseModel> uploadImage({
    required String filePath,
    String? fileName,
    String? description,
    String? allText,
    String? folderPath,
  });
}


