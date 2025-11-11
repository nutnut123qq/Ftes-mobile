import '../models/profile_model.dart';
import '../models/instructor_course_model.dart';

/// Local cache for Profile feature
abstract class ProfileLocalDataSource {
  /// Cache profile by user ID
  Future<void> cacheProfile(String userId, ProfileModel profile, Duration ttl);
  
  /// Get cached profile by user ID
  Future<ProfileModel?> getCachedProfile(String userId, Duration ttl);
  
  /// Cache profile by username
  Future<void> cacheProfileByUsername(String username, ProfileModel profile, Duration ttl);
  
  /// Get cached profile by username
  Future<ProfileModel?> getCachedProfileByUsername(String username, Duration ttl);
  
  /// Cache instructor courses
  Future<void> cacheInstructorCourses(String userId, List<InstructorCourseModel> courses, Duration ttl);
  
  /// Get cached instructor courses
  Future<List<InstructorCourseModel>?> getCachedInstructorCourses(String userId, Duration ttl);
  
  /// Cache participants count
  Future<void> cacheParticipantsCount(String instructorId, int count, Duration ttl);
  
  /// Get cached participants count
  Future<int?> getCachedParticipantsCount(String instructorId, Duration ttl);
  
  /// Invalidate profile cache by user ID
  Future<void> invalidateProfile(String userId);
  
  /// Invalidate profile cache by username
  Future<void> invalidateProfileByUsername(String username);
  
  /// Clear all profile-related cache
  Future<void> clearAllCache();
}

