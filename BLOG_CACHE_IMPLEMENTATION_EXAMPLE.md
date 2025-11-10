# VÍ DỤ IMPLEMENTATION: BLOG CACHE LAYER

## 1. BLOG LOCAL DATA SOURCE INTERFACE

```dart
// lib/features/blog/data/datasources/blog_local_datasource.dart

import '../models/blog_model.dart';
import '../models/blog_category_model.dart';

/// Abstract local data source for blog caching operations
abstract class BlogLocalDataSource {
  /// Cache blog list with TTL
  Future<void> cacheBlogs(String key, List<BlogModel> blogs, Duration ttl);
  
  /// Get cached blog list
  Future<List<BlogModel>?> getCachedBlogs(String key, Duration ttl);
  
  /// Cache single blog detail
  Future<void> cacheBlogDetail(String slug, BlogModel blog, Duration ttl);
  
  /// Get cached blog detail
  Future<BlogModel?> getCachedBlogDetail(String slug, Duration ttl);
  
  /// Cache blog categories
  Future<void> cacheCategories(List<BlogCategoryModel> categories, Duration ttl);
  
  /// Get cached categories
  Future<List<BlogCategoryModel>?> getCachedCategories(Duration ttl);
  
  /// Invalidate specific cache key
  Future<void> invalidateCache(String key);
  
  /// Clear all blog cache
  Future<void> clearAllCache();
}
```

---

## 2. BLOG LOCAL DATA SOURCE IMPLEMENTATION

```dart
// lib/features/blog/data/datasources/blog_local_datasource_impl.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/constants/blog_constants.dart';
import '../models/blog_model.dart';
import '../models/blog_category_model.dart';
import 'blog_local_datasource.dart';

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final SharedPreferences _sharedPreferences;
  
  // Cache keys
  static const String _keyBlogsPrefix = 'cache_blogs_';
  static const String _keyBlogDetailPrefix = 'cache_blog_detail_';
  static const String _keyCategories = 'cache_blog_categories';
  
  BlogLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;
  
  String _blogsKey(int page, int pageSize, String? category, String? search) {
    final parts = [
      _keyBlogsPrefix,
      'page_$page',
      'size_$pageSize',
      if (category != null) 'cat_$category',
      if (search != null) 'search_$search',
    ];
    return parts.join('_');
  }
  
  @override
  Future<void> cacheBlogs(
    String key,
    List<BlogModel> blogs,
    Duration ttl,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'ttl': ttl.inMilliseconds,
        'data': blogs.map((b) => b.toJson()).toList(),
      });
      await _sharedPreferences.setString(key, payload);
    } catch (e) {
      throw CacheException('Failed to cache blogs: $e');
    }
  }
  
  @override
  Future<List<BlogModel>?> getCachedBlogs(
    String key,
    Duration ttl,
  ) async {
    try {
      final raw = _sharedPreferences.getString(key);
      if (raw == null) return null;
      
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final cachedTtl = (map['ttl'] as num?)?.toInt() ?? ttl.inMilliseconds;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      
      // Check if expired
      if (age > cachedTtl) {
        await _sharedPreferences.remove(key);
        return null;
      }
      
      final dataList = map['data'] as List<dynamic>;
      return dataList
          .map((json) => BlogModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Invalid cache, remove it
      await _sharedPreferences.remove(key);
      return null;
    }
  }
  
  @override
  Future<void> cacheBlogDetail(
    String slug,
    BlogModel blog,
    Duration ttl,
  ) async {
    try {
      final key = '$_keyBlogDetailPrefix$slug';
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'ttl': ttl.inMilliseconds,
        'data': blog.toJson(),
      });
      await _sharedPreferences.setString(key, payload);
    } catch (e) {
      throw CacheException('Failed to cache blog detail: $e');
    }
  }
  
  @override
  Future<BlogModel?> getCachedBlogDetail(String slug, Duration ttl) async {
    try {
      final key = '$_keyBlogDetailPrefix$slug';
      final raw = _sharedPreferences.getString(key);
      if (raw == null) return null;
      
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final cachedTtl = (map['ttl'] as num?)?.toInt() ?? ttl.inMilliseconds;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      
      if (age > cachedTtl) {
        await _sharedPreferences.remove(key);
        return null;
      }
      
      final data = map['data'] as Map<String, dynamic>;
      return BlogModel.fromJson(data);
    } catch (e) {
      await _sharedPreferences.remove(key);
      return null;
    }
  }
  
  @override
  Future<void> cacheCategories(
    List<BlogCategoryModel> categories,
    Duration ttl,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final payload = jsonEncode({
        'ts': now,
        'ttl': ttl.inMilliseconds,
        'data': categories.map((c) => c.toJson()).toList(),
      });
      await _sharedPreferences.setString(_keyCategories, payload);
    } catch (e) {
      throw CacheException('Failed to cache categories: $e');
    }
  }
  
  @override
  Future<List<BlogCategoryModel>?> getCachedCategories(Duration ttl) async {
    try {
      final raw = _sharedPreferences.getString(_keyCategories);
      if (raw == null) return null;
      
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final cachedTtl = (map['ttl'] as num?)?.toInt() ?? ttl.inMilliseconds;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      
      if (age > cachedTtl) {
        await _sharedPreferences.remove(_keyCategories);
        return null;
      }
      
      final dataList = map['data'] as List<dynamic>;
      return dataList
          .map((json) => BlogCategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      await _sharedPreferences.remove(_keyCategories);
      return null;
    }
  }
  
  @override
  Future<void> invalidateCache(String key) async {
    try {
      await _sharedPreferences.remove(key);
    } catch (e) {
      throw CacheException('Failed to invalidate cache: $e');
    }
  }
  
  @override
  Future<void> clearAllCache() async {
    try {
      final keys = _sharedPreferences.getKeys();
      final blogKeys = keys.where((k) => 
        k.startsWith(_keyBlogsPrefix) || 
        k.startsWith(_keyBlogDetailPrefix) || 
        k == _keyCategories
      );
      
      for (final key in blogKeys) {
        await _sharedPreferences.remove(key);
      }
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
```

---

## 3. UPDATE BLOG REPOSITORY VỚI CACHE-FIRST STRATEGY

```dart
// lib/features/blog/data/repositories/blog_repository_impl.dart
// (Update phần getBlogCategories)

@override
Future<Either<Failure, List<BlogCategory>>> getBlogCategories() async {
  try {
    // 1. Try cache first (even if offline)
    final cached = await localDataSource.getCachedCategories(
      BlogConstants.categoryCacheTTL,
    );
    if (cached != null) {
      return Right(cached.map((model) => model.toEntity()).toList());
    }
    
    // 2. Check network
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(BlogConstants.errorNoInternet));
    }
    
    // 3. Fetch from network
    final models = await remoteDataSource.getBlogCategories();
    
    // 4. Cache for next time (fire-and-forget, don't block)
    unawaited(
      localDataSource
          .cacheCategories(models, BlogConstants.categoryCacheTTL)
          .catchError((e) => debugPrint('Cache error: $e')),
    );
    
    return Right(models.map((model) => model.toEntity()).toList());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } on ValidationException catch (e) {
    return Left(ValidationFailure(e.message));
  } catch (e) {
    return Left(ServerFailure('${BlogConstants.errorLoadingCategories}: $e'));
  }
}
```

---

## 4. UPDATE BLOG CONSTANTS VỚI CACHE TTL

```dart
// lib/features/blog/domain/constants/blog_constants.dart
// (Thêm vào cuối file)

class BlogConstants {
  // ... existing constants ...
  
  // Cache TTL
  static const Duration cacheTTL = Duration(hours: 24);
  static const Duration categoryCacheTTL = Duration(hours: 12);
  static const Duration blogDetailCacheTTL = Duration(hours: 6);
  static const Duration searchCacheTTL = Duration(hours: 1);
  
  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration networkTimeout = Duration(seconds: 30);
}
```

---

## 5. UPDATE DEPENDENCY INJECTION

```dart
// lib/features/blog/di/blog_injection.dart
// (Update initBlogDependencies)

Future<void> initBlogDependencies() async {
  final sl = core.sl;

  // Data sources
  sl.registerLazySingleton<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  
  // ✅ Thêm local datasource
  sl.registerLazySingleton<BlogLocalDataSource>(
    () => BlogLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<BlogRepository>(
    () => BlogRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(), // ✅ Thêm local datasource
      networkInfo: sl(),
    ),
  );

  // ... rest of the code ...
}
```

---

## 6. UPDATE REPOSITORY INTERFACE

```dart
// lib/features/blog/data/repositories/blog_repository_impl.dart
// (Update constructor)

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;
  final BlogLocalDataSource localDataSource; // ✅ Thêm
  final NetworkInfo networkInfo;

  BlogRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource, // ✅ Thêm
    required this.networkInfo,
  });
  
  // ... rest of implementation ...
}
```

---

## 7. OPTIMIZE JSON PARSING (Luôn dùng isolate)

```dart
// lib/features/blog/data/datasources/blog_remote_datasource_impl.dart
// (Update getBlogById và getBlogBySlug)

@override
Future<BlogModel> getBlogById(String blogId) async {
  try {
    final response = await _apiClient.get('${AppConstants.blogsEndpoint}/$blogId');
    
    if (response.statusCode == 200) {
      final success = response.data['success'];
      if (success == true) {
        final result = response.data['result'];
        if (result != null) {
          // ✅ Luôn parse trong isolate để không block UI
          return await compute(_parseBlogModel, result);
        } else {
          throw const ServerException(BlogConstants.errorInvalidData);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 
          BlogConstants.errorLoadingBlogDetail);
      }
    } else {
      throw ServerException(response.data['messageDTO']?['message'] ?? 
        BlogConstants.errorLoadingBlogDetail);
    }
  } catch (e) {
    debugPrint('❌ Get blog by ID error: $e');
    if (e is AppException) {
      rethrow;
    }
    throw ServerException('${BlogConstants.errorLoadingBlogDetail}: ${e.toString()}');
  }
}

// ✅ Top-level function cho compute
static BlogModel _parseBlogModel(Map<String, dynamic> json) {
  return BlogModel.fromJson(json);
}
```

---

## 8. OPTIMIZE VIEWMODEL STATE UPDATES

```dart
// lib/features/blog/presentation/viewmodels/blog_viewmodel.dart
// (Thêm helper method)

/// Batch state updates để minimize notifyListeners() calls
void _updateState({
  bool? isLoading,
  bool? isLoadingMore,
  bool? isLoadingCategories,
  List<Blog>? blogs,
  List<BlogCategory>? categories,
  Blog? selectedBlog,
  String? errorMessage,
  int? currentPage,
  int? totalPages,
  int? totalElements,
  String? selectedCategory,
  String? searchText,
}) {
  bool shouldNotify = false;
  
  if (isLoading != null && _isLoading != isLoading) {
    _isLoading = isLoading;
    shouldNotify = true;
  }
  
  if (isLoadingMore != null && _isLoadingMore != isLoadingMore) {
    _isLoadingMore = isLoadingMore;
    shouldNotify = true;
  }
  
  if (isLoadingCategories != null && _isLoadingCategories != isLoadingCategories) {
    _isLoadingCategories = isLoadingCategories;
    shouldNotify = true;
  }
  
  if (blogs != null) {
    _blogs = blogs;
    shouldNotify = true;
  }
  
  if (categories != null) {
    _categories = categories;
    shouldNotify = true;
  }
  
  if (selectedBlog != null || selectedBlog == null && _selectedBlog != null) {
    _selectedBlog = selectedBlog;
    shouldNotify = true;
  }
  
  if (errorMessage != null || errorMessage == null && _errorMessage != null) {
    _errorMessage = errorMessage;
    shouldNotify = true;
  }
  
  if (currentPage != null && _currentPage != currentPage) {
    _currentPage = currentPage;
    shouldNotify = true;
  }
  
  if (totalPages != null && _totalPages != totalPages) {
    _totalPages = totalPages;
    shouldNotify = true;
  }
  
  if (totalElements != null && _totalElements != totalElements) {
    _totalElements = totalElements;
    shouldNotify = true;
  }
  
  if (selectedCategory != null || selectedCategory == null && _selectedCategory != null) {
    _selectedCategory = selectedCategory;
    shouldNotify = true;
  }
  
  if (searchText != null || searchText == null && _searchText != null) {
    _searchText = searchText;
    shouldNotify = true;
  }
  
  if (shouldNotify) {
    notifyListeners();
  }
}
```

---

## 📝 NOTES

1. **Cache Strategy**: Cache-aside pattern (check cache → fetch if miss → update cache)
2. **TTL**: Different TTL cho different data types (categories cache lâu hơn search results)
3. **Error Handling**: Cache errors không nên block main flow
4. **Performance**: Fire-and-forget cache updates để không block response
5. **Offline Support**: Always check cache first, even when offline

