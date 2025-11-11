import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';
import '../models/instructor_course_model.dart';
import '../../domain/constants/profile_constants.dart';
import 'profile_local_datasource.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  // Cache key helpers
  String _profileKey(String userId) => '${ProfileConstants.cacheKeyPrefixProfile}$userId';
  String _profileByUsernameKey(String username) => '${ProfileConstants.cacheKeyPrefixProfileByUsername}$username';
  String _instructorCoursesKey(String userId) => '${ProfileConstants.cacheKeyPrefixInstructorCourses}$userId';
  String _participantsCountKey(String instructorId) => '${ProfileConstants.cacheKeyPrefixParticipantsCount}$instructorId';

  @override
  Future<void> cacheProfile(String userId, ProfileModel profile, Duration ttl) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'data': profile.toJson(),
      });
      await sharedPreferences.setString(_profileKey(userId), payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache profile: $e');
    }
  }

  @override
  Future<ProfileModel?> getCachedProfile(String userId, Duration ttl) async {
    final raw = sharedPreferences.getString(_profileKey(userId));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await sharedPreferences.remove(_profileKey(userId));
        return null;
      }
      final data = map['data'] as Map<String, dynamic>;
      return ProfileModel.fromJson(data);
    } catch (_) {
      await sharedPreferences.remove(_profileKey(userId));
      return null;
    }
  }

  @override
  Future<void> cacheProfileByUsername(String username, ProfileModel profile, Duration ttl) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'data': profile.toJson(),
      });
      await sharedPreferences.setString(_profileByUsernameKey(username), payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache profile by username: $e');
    }
  }

  @override
  Future<ProfileModel?> getCachedProfileByUsername(String username, Duration ttl) async {
    final raw = sharedPreferences.getString(_profileByUsernameKey(username));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await sharedPreferences.remove(_profileByUsernameKey(username));
        return null;
      }
      final data = map['data'] as Map<String, dynamic>;
      return ProfileModel.fromJson(data);
    } catch (_) {
      await sharedPreferences.remove(_profileByUsernameKey(username));
      return null;
    }
  }

  @override
  Future<void> cacheInstructorCourses(String userId, List<InstructorCourseModel> courses, Duration ttl) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'data': courses.map((c) => c.toJson()).toList(),
      });
      await sharedPreferences.setString(_instructorCoursesKey(userId), payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache instructor courses: $e');
    }
  }

  @override
  Future<List<InstructorCourseModel>?> getCachedInstructorCourses(String userId, Duration ttl) async {
    final raw = sharedPreferences.getString(_instructorCoursesKey(userId));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await sharedPreferences.remove(_instructorCoursesKey(userId));
        return null;
      }
      final data = map['data'] as List<dynamic>;
      return data
          .map((json) => InstructorCourseModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await sharedPreferences.remove(_instructorCoursesKey(userId));
      return null;
    }
  }

  @override
  Future<void> cacheParticipantsCount(String instructorId, int count, Duration ttl) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'data': count,
      });
      await sharedPreferences.setString(_participantsCountKey(instructorId), payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache participants count: $e');
    }
  }

  @override
  Future<int?> getCachedParticipantsCount(String instructorId, Duration ttl) async {
    final raw = sharedPreferences.getString(_participantsCountKey(instructorId));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await sharedPreferences.remove(_participantsCountKey(instructorId));
        return null;
      }
      final data = map['data'] as int;
      return data;
    } catch (_) {
      await sharedPreferences.remove(_participantsCountKey(instructorId));
      return null;
    }
  }

  @override
  Future<void> invalidateProfile(String userId) async {
    try {
      await sharedPreferences.remove(_profileKey(userId));
    } catch (_) {
      // Silently fail
    }
  }

  @override
  Future<void> invalidateProfileByUsername(String username) async {
    try {
      await sharedPreferences.remove(_profileByUsernameKey(username));
    } catch (_) {
      // Silently fail
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      final keys = sharedPreferences.getKeys();
      final profileKeys = keys.where((key) =>
          key.startsWith(ProfileConstants.cacheKeyPrefixProfile) ||
          key.startsWith(ProfileConstants.cacheKeyPrefixProfileByUsername) ||
          key.startsWith(ProfileConstants.cacheKeyPrefixInstructorCourses) ||
          key.startsWith(ProfileConstants.cacheKeyPrefixParticipantsCount));
      
      for (final key in profileKeys) {
        await sharedPreferences.remove(key);
      }
    } catch (_) {
      // Silently fail
    }
  }
}


