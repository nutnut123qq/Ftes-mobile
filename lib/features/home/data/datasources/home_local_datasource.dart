import '../models/course_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';

/// Local cache for Home feature with TTL support.
abstract class HomeLocalDataSource {
  // Latest courses
  Future<void> cacheLatestCourses(int limit, List<CourseModel> courses, Duration ttl);
  Future<List<CourseModel>?> getCachedLatestCourses(int limit, Duration ttl);

  // Featured courses
  Future<void> cacheFeaturedCourses(List<CourseModel> courses, Duration ttl);
  Future<List<CourseModel>?> getCachedFeaturedCourses(Duration ttl);

  // Banners
  Future<void> cacheBanners(List<BannerModel> banners, Duration ttl);
  Future<List<BannerModel>?> getCachedBanners(Duration ttl);

  // Categories
  Future<void> cacheCategories(List<CategoryModel> categories, Duration ttl);
  Future<List<CategoryModel>?> getCachedCategories(Duration ttl);

  // Cache invalidation
  Future<void> invalidateCache(String key);
  Future<void> clearAllCache();
}


