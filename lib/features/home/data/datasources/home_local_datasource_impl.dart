import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import 'home_local_datasource.dart';

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SharedPreferences sharedPreferences;

  HomeLocalDataSourceImpl({required this.sharedPreferences});

  // Key prefixes (kept internal to avoid scattering literals)
  static const String _prefixLatestCourses = 'home_latest_courses_';
  static const String _prefixFeaturedCourses = 'home_featured_courses';
  static const String _prefixBanners = 'home_banners';
  static const String _prefixCategories = 'home_categories';

  String _latestKey(int limit) => '$_prefixLatestCourses$limit';
  String _featuredKey() => _prefixFeaturedCourses;
  String _bannersKey() => _prefixBanners;
  String _categoriesKey() => _prefixCategories;

  Map<String, dynamic> _wrapPayload(dynamic data) {
    return {
      'ts': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    };
  }

  bool _isExpired(int ts, Duration ttl) {
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    return age > ttl.inMilliseconds;
  }

  // Latest courses
  @override
  Future<void> cacheLatestCourses(int limit, List<CourseModel> courses, Duration ttl) async {
    final payload = _wrapPayload(courses.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_latestKey(limit), jsonEncode(payload));
  }

  @override
  Future<List<CourseModel>?> getCachedLatestCourses(int limit, Duration ttl) async {
    final raw = sharedPreferences.getString(_latestKey(limit));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      if (_isExpired(ts, ttl)) {
        await sharedPreferences.remove(_latestKey(limit));
        return null;
      }
      final list = (map['data'] as List).cast<Map<String, dynamic>>();
      return list.map((e) => CourseModel.fromJson(e)).toList();
    } catch (_) {
      await sharedPreferences.remove(_latestKey(limit));
      return null;
    }
  }

  // Featured courses
  @override
  Future<void> cacheFeaturedCourses(List<CourseModel> courses, Duration ttl) async {
    final payload = _wrapPayload(courses.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_featuredKey(), jsonEncode(payload));
  }

  @override
  Future<List<CourseModel>?> getCachedFeaturedCourses(Duration ttl) async {
    final raw = sharedPreferences.getString(_featuredKey());
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      if (_isExpired(ts, ttl)) {
        await sharedPreferences.remove(_featuredKey());
        return null;
      }
      final list = (map['data'] as List).cast<Map<String, dynamic>>();
      return list.map((e) => CourseModel.fromJson(e)).toList();
    } catch (_) {
      await sharedPreferences.remove(_featuredKey());
      return null;
    }
  }

  // Banners
  @override
  Future<void> cacheBanners(List<BannerModel> banners, Duration ttl) async {
    final payload = _wrapPayload(banners.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_bannersKey(), jsonEncode(payload));
  }

  @override
  Future<List<BannerModel>?> getCachedBanners(Duration ttl) async {
    final raw = sharedPreferences.getString(_bannersKey());
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      if (_isExpired(ts, ttl)) {
        await sharedPreferences.remove(_bannersKey());
        return null;
      }
      final list = (map['data'] as List).cast<Map<String, dynamic>>();
      return list.map((e) => BannerModel.fromJson(e)).toList();
    } catch (_) {
      await sharedPreferences.remove(_bannersKey());
      return null;
    }
  }

  // Categories
  @override
  Future<void> cacheCategories(List<CategoryModel> categories, Duration ttl) async {
    final payload = _wrapPayload(categories.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_categoriesKey(), jsonEncode(payload));
  }

  @override
  Future<List<CategoryModel>?> getCachedCategories(Duration ttl) async {
    final raw = sharedPreferences.getString(_categoriesKey());
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      if (_isExpired(ts, ttl)) {
        await sharedPreferences.remove(_categoriesKey());
        return null;
      }
      final list = (map['data'] as List).cast<Map<String, dynamic>>();
      return list.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (_) {
      await sharedPreferences.remove(_categoriesKey());
      return null;
    }
  }

  // Invalidate / Clear
  @override
  Future<void> invalidateCache(String key) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> clearAllCache() async {
    // Remove known keys; avoids clearing unrelated data
    await Future.wait([
      sharedPreferences.remove(_featuredKey()),
      sharedPreferences.remove(_bannersKey()),
      sharedPreferences.remove(_categoriesKey()),
      // Latest courses keys are parameterized by limit; best-effort cleanup
    ]);
  }
}


