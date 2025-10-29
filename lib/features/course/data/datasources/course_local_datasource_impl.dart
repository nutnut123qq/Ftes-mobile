import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_detail_model.dart';
import '../models/video_playlist_model.dart';
import 'course_local_datasource.dart';

class CourseLocalDataSourceImpl implements CourseLocalDataSource {
  final SharedPreferences sharedPreferences;

  CourseLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCourseDetail(String key, CourseDetailModel model, Duration ttl) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final payload = jsonEncode({
      'ts': now,
      'data': model.toJson(),
    });
    await sharedPreferences.setString(key, payload);
  }

  @override
  Future<CourseDetailModel?> getCachedCourseDetail(String key, Duration ttl) async {
    final raw = sharedPreferences.getString(key);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await sharedPreferences.remove(key);
        return null;
      }
      final data = map['data'] as Map<String, dynamic>;
      return CourseDetailModel.fromJson(data);
    } catch (_) {
      await sharedPreferences.remove(key);
      return null;
    }
  }

  @override
  Future<void> invalidateCourseDetail(String key) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> cacheVideoPlaylist(String key, VideoPlaylistModel model, Duration ttl) async {
    final payload = jsonEncode({
      'ts': DateTime.now().millisecondsSinceEpoch,
      'data': model.toJson(),
    });
    await sharedPreferences.setString(key, payload);
  }

  @override
  Future<VideoPlaylistModel?> getCachedVideoPlaylist(String key, Duration ttl) async {
    final raw = sharedPreferences.getString(key);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      if (DateTime.now().millisecondsSinceEpoch - ts > ttl.inMilliseconds) {
        await sharedPreferences.remove(key);
        return null;
      }
      final data = map['data'] as Map<String, dynamic>;
      return VideoPlaylistModel.fromJson(data);
    } catch (_) {
      await sharedPreferences.remove(key);
      return null;
    }
  }
}


