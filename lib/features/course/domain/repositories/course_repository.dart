import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/course_detail.dart';
import '../entities/profile.dart';
import '../entities/video_playlist.dart';
import '../entities/video_status.dart';

/// Abstract repository interface for course operations
abstract class CourseRepository {
  /// Get course detail by slug name
  Future<Either<Failure, CourseDetail>> getCourseDetailBySlug(
    String slugName, 
    String? userId,
  );
  
  /// Get profile by userId
  Future<Either<Failure, Profile>> getProfile(String userId);
  
  /// Check enrollment status for a user and course
  Future<Either<Failure, bool>> checkEnrollment(String userId, String courseId);

  /// Get video playlist for HLS streaming
  Future<Either<Failure, VideoPlaylist>> getVideoPlaylist(String videoId, bool presign);

  /// Get video processing status
  Future<Either<Failure, VideoStatus>> getVideoStatus(String videoId);
}
