import '../models/blog_model.dart';
import '../models/blog_category_model.dart';
import '../models/paginated_blog_response_model.dart';

/// Local cache for Blog feature
abstract class BlogLocalDataSource {
  /// Cache paginated blog list
  Future<void> cacheBlogs(String key, PaginatedBlogResponseModel response, Duration ttl);
  
  /// Get cached paginated blog list
  Future<PaginatedBlogResponseModel?> getCachedBlogs(String key, Duration ttl);
  
  /// Cache blog detail by slug
  Future<void> cacheBlogDetail(String slug, BlogModel blog, Duration ttl);
  
  /// Get cached blog detail by slug
  Future<BlogModel?> getCachedBlogDetail(String slug, Duration ttl);
  
  /// Cache blog categories
  Future<void> cacheCategories(List<BlogCategoryModel> categories, Duration ttl);
  
  /// Get cached blog categories
  Future<List<BlogCategoryModel>?> getCachedCategories(Duration ttl);
  
  /// Invalidate specific cache by key
  Future<void> invalidateCache(String key);
  
  /// Clear all blog-related cache
  Future<void> clearAllCache();
}

