import '../../domain/entities/profile.dart';
import '../../data/models/upload_image_response_model.dart';

/// Abstract repository for Profile operations
abstract class ProfileRepository {
  /// Get profile by user ID
  Future<Profile> getProfileById(String userId);

  /// Get profile by username
  Future<Profile> getProfileByUsername(String userName, {String? postId});

  /// Create new profile
  Future<Profile> createProfile(String userId, Map<String, dynamic> requestData);

  /// Update existing profile
  Future<Profile> updateProfile(String userId, Map<String, dynamic> requestData);

  /// Create profile automatically (for new users)
  Future<Profile> createProfileAuto(String userId);

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
