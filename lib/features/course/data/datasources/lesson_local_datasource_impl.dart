import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'lesson_local_datasource.dart';

class LessonLocalDataSourceImpl implements LessonLocalDataSource {
  final SharedPreferences sharedPreferences;

  LessonLocalDataSourceImpl({required this.sharedPreferences});

  String _key(String lessonId) => 'cache_lesson_$lessonId';

  @override
  Future<void> cacheLesson(String lessonId, Map<String, dynamic> json, Duration ttl) async {
    final payload = jsonEncode({'ts': DateTime.now().millisecondsSinceEpoch, 'data': json});
    await sharedPreferences.setString(_key(lessonId), payload);
  }

  @override
  Future<Map<String, dynamic>?> getCachedLesson(String lessonId, Duration ttl) async {
    final raw = sharedPreferences.getString(_key(lessonId));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      if (DateTime.now().millisecondsSinceEpoch - ts > ttl.inMilliseconds) {
        await sharedPreferences.remove(_key(lessonId));
        return null;
      }
      return (map['data'] as Map<String, dynamic>);
    } catch (_) {
      await sharedPreferences.remove(_key(lessonId));
      return null;
    }
  }

  @override
  Future<void> invalidateLesson(String lessonId) async {
    await sharedPreferences.remove(_key(lessonId));
  }
}


