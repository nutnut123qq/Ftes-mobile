import '../../../../core/error/failures.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/instructor_course.dart';
import '../../data/models/upload_image_response_model.dart';
import 'package:dartz/dartz.dart';

/// Abstract repository for Profile operations
abstract class ProfileRepository {
  /// Get profile by user ID
  Future<Either<Failure, Profile>> getProfileById(String userId);

  /// Get profile by username
  Future<Either<Failure, Profile>> getProfileByUsername(String userName, {String? postId});

  /// Get instructor profile by username
  Future<Either<Failure, Profile>> getInstructorProfileByUsername(String userName);

  /// Get courses created by instructor
  Future<Either<Failure, List<InstructorCourse>>> getCoursesByCreator(String userId);

  /// Create new profile
  Future<Either<Failure, Profile>> createProfile(String userId, Map<String, dynamic> requestData);

  /// Update existing profile
  Future<Either<Failure, Profile>> updateProfile(String userId, Map<String, dynamic> requestData);

  /// Create profile automatically (for new users)
  Future<Either<Failure, Profile>> createProfileAuto(String userId);

  /// Get participants count for instructor
  Future<Either<Failure, int>> getParticipantsCount(String instructorId);

  /// Check if user has applied to course
  Future<Either<Failure, int>> checkApplyCourse(String userId, String courseId);

  /// Upload image to GitHub
  Future<Either<Failure, UploadImageResponseModel>> uploadImage({
    required String filePath,
    String? fileName,
    String? description,
    String? allText,
    String? folderPath,
  });
}
