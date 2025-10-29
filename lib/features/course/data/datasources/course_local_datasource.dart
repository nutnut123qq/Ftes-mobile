import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_detail_model.dart';
import '../models/video_playlist_model.dart';

/// Local cache for Course feature
abstract class CourseLocalDataSource {
  Future<void> cacheCourseDetail(String key, CourseDetailModel model, Duration ttl);
  Future<CourseDetailModel?> getCachedCourseDetail(String key, Duration ttl);
  Future<void> invalidateCourseDetail(String key);

  // Video playlist cache
  Future<void> cacheVideoPlaylist(String key, VideoPlaylistModel model, Duration ttl);
  Future<VideoPlaylistModel?> getCachedVideoPlaylist(String key, Duration ttl);
}


