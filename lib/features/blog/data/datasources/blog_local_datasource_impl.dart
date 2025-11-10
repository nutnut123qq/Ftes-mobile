import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/blog_model.dart';
import '../models/blog_category_model.dart';
import '../models/paginated_blog_response_model.dart';
import '../../domain/constants/blog_constants.dart';
import 'blog_local_datasource.dart';

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final SharedPreferences sharedPreferences;

  BlogLocalDataSourceImpl({required this.sharedPreferences});

  // Cache key helpers
  String _blogListKey(String key) => '${BlogConstants.cacheKeyPrefixBlogList}$key';
  String _blogDetailKey(String slug) => '${BlogConstants.cacheKeyPrefixBlogDetail}$slug';
  String _categoriesKey() => BlogConstants.cacheKeyPrefixCategories;

  @override
  Future<void> cacheBlogs(String key, PaginatedBlogResponseModel response, Duration ttl) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'data': response.toJson(),
      });
      await sharedPreferences.setString(_blogListKey(key), payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache blogs: $e');
    }
  }

  @override
  Future<PaginatedBlogResponseModel?> getCachedBlogs(String key, Duration ttl) async {
    final raw = sharedPreferences.getString(_blogListKey(key));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await sharedPreferences.remove(_blogListKey(key));
        return null;
      }
      final data = map['data'] as Map<String, dynamic>;
      return PaginatedBlogResponseModel.fromJson(data);
    } catch (_) {
      await sharedPreferences.remove(_blogListKey(key));
      return null;
    }
  }

  @override
  Future<void> cacheBlogDetail(String slug, BlogModel blog, Duration ttl) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'data': blog.toJson(),
      });
      await sharedPreferences.setString(_blogDetailKey(slug), payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache blog detail: $e');
    }
  }

  @override
  Future<BlogModel?> getCachedBlogDetail(String slug, Duration ttl) async {
    final raw = sharedPreferences.getString(_blogDetailKey(slug));
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await sharedPreferences.remove(_blogDetailKey(slug));
        return null;
      }
      final data = map['data'] as Map<String, dynamic>;
      return BlogModel.fromJson(data);
    } catch (_) {
      await sharedPreferences.remove(_blogDetailKey(slug));
      return null;
    }
  }

  @override
  Future<void> cacheCategories(List<BlogCategoryModel> categories, Duration ttl) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'data': categories.map((c) => c.toJson()).toList(),
      });
      await sharedPreferences.setString(_categoriesKey(), payload);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache categories: $e');
    }
  }

  @override
  Future<List<BlogCategoryModel>?> getCachedCategories(Duration ttl) async {
    final raw = sharedPreferences.getString(_categoriesKey());
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await sharedPreferences.remove(_categoriesKey());
        return null;
      }
      final data = map['data'] as List<dynamic>;
      return data
          .map((json) => BlogCategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await sharedPreferences.remove(_categoriesKey());
      return null;
    }
  }

  @override
  Future<void> invalidateCache(String key) async {
    try {
      await sharedPreferences.remove(key);
    } catch (_) {
      // Silently fail
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      final keys = sharedPreferences.getKeys();
      final blogKeys = keys.where((key) =>
          key.startsWith(BlogConstants.cacheKeyPrefixBlogList) ||
          key.startsWith(BlogConstants.cacheKeyPrefixBlogDetail) ||
          key.startsWith(BlogConstants.cacheKeyPrefixCategories));
      
      for (final key in blogKeys) {
        await sharedPreferences.remove(key);
      }
    } catch (_) {
      // Silently fail
    }
  }
}

