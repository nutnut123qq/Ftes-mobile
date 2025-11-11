import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/my_course_model.dart';
import '../../domain/constants/my_courses_constants.dart';
import 'my_courses_local_datasource.dart';

class MyCoursesLocalDataSourceImpl implements MyCoursesLocalDataSource {
  final SharedPreferences sharedPreferences;

  MyCoursesLocalDataSourceImpl({required this.sharedPreferences});

  // Cache key helper
  String _userCoursesKey(String userId) => '${MyCoursesConstants.cacheKeyPrefixMyCourses}$userId';

  @override
  Future<void> cacheUserCourses(String userId, List<MyCourseModel> courses, Duration ttl) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'data': courses.map((c) => c.toJson()).toList(),
      });
      await sharedPreferences.setString(_userCoursesKey(userId), payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache user courses: $e');
    }
  }

  @override
  Future<List<MyCourseModel>?> getCachedUserCourses(String userId, Duration ttl) async {
    final raw = sharedPreferences.getString(_userCoursesKey(userId));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await sharedPreferences.remove(_userCoursesKey(userId));
        return null;
      }
      final data = map['data'] as List<dynamic>;
      return data
          .map((json) => MyCourseModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await sharedPreferences.remove(_userCoursesKey(userId));
      return null;
    }
  }

  @override
  Future<void> invalidateUserCourses(String userId) async {
    try {
      await sharedPreferences.remove(_userCoursesKey(userId));
    } catch (_) {
      // Silently fail
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      final keys = sharedPreferences.getKeys();
      final myCoursesKeys = keys.where((key) =>
          key.startsWith(MyCoursesConstants.cacheKeyPrefixMyCourses));
      
      for (final key in myCoursesKeys) {
        await sharedPreferences.remove(key);
      }
    } catch (_) {
      // Silently fail
    }
  }
}

