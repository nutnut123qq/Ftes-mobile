import 'dart:async' show unawaited;
import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/exceptions.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/network/network_info.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/course_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../cache/home_memory_cache.dart';
import '../../common/home_messages.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource? localDataSource;
  final NetworkInfo networkInfo;
  final HomeMemoryCache<dynamic> _memoryCache;
  final Map<String, Future<dynamic>> _pendingRequests = {};

  // Local key prefixes (will be moved to HomeConstants later)
  static const String _memKeyLatestPrefix = 'home_mem_latest_';
  static const String _memKeyFeatured = 'home_mem_featured';
  static const String _memKeyBanners = 'home_mem_banners';
  static const String _memKeyCategories = 'home_mem_categories';

  // Default TTLs (will be moved to HomeConstants later)
  static const Duration _ttlLatest = Duration(minutes: 10);
  static const Duration _ttlFeatured = Duration(minutes: 10);
  static const Duration _ttlBanners = Duration(minutes: 30);
  static const Duration _ttlCategories = Duration(hours: 2);

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    this.localDataSource,
    HomeMemoryCache<dynamic>? memoryCache,
  }) : _memoryCache = memoryCache ?? HomeMemoryCache<dynamic>(maxEntries: 50);

  @override
  Future<Either<Failure, List<Course>>> getLatestCourses({int limit = 3}) async {
    final memKey = '$_memKeyLatestPrefix$limit';

    // 1) Memory cache
    final mem = _memoryCache.get(memKey, ttl: _ttlLatest) as List<CourseModel>?;
    if (mem != null) {
      return Right(mem.map((m) => m.toEntity()).toList());
    }

    // 2) Local cache (disk)
    if (localDataSource != null) {
      final local = await localDataSource!.getCachedLatestCourses(limit, _ttlLatest);
      if (local != null) {
        _memoryCache.set(memKey, local);
        return Right(local.map((m) => m.toEntity()).toList());
      }
    }

    // 3) Deduplicate network request
    if (_pendingRequests.containsKey(memKey)) {
      final fut = _pendingRequests[memKey] as Future<Either<Failure, List<Course>>>;
      return fut;
    }

    final future = _fetchLatestCoursesNetwork(limit, memKey);
    _pendingRequests[memKey] = future;
    try {
      return await future;
    } finally {
      _pendingRequests.remove(memKey);
    }
  }

  Future<Either<Failure, List<Course>>> _fetchLatestCoursesNetwork(int limit, String memKey) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(HomeMessages.noInternet));
    }
    try {
      final models = await remoteDataSource.getLatestCourses(limit: limit);
      // Cache non-blocking
      _memoryCache.set(memKey, models);
      if (localDataSource != null) {
        unawaited(localDataSource!.cacheLatestCourses(limit, models, _ttlLatest));
      }
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> getFeaturedCourses() async {
    const memKey = _memKeyFeatured;
    final mem = _memoryCache.get(memKey, ttl: _ttlFeatured) as List<CourseModel>?;
    if (mem != null) {
      return Right(mem.map((m) => m.toEntity()).toList());
    }

    if (localDataSource != null) {
      final local = await localDataSource!.getCachedFeaturedCourses(_ttlFeatured);
      if (local != null) {
        _memoryCache.set(memKey, local);
        return Right(local.map((m) => m.toEntity()).toList());
      }
    }

    if (_pendingRequests.containsKey(memKey)) {
      return _pendingRequests[memKey] as Future<Either<Failure, List<Course>>>;
    }
    final future = _fetchFeaturedNetwork(memKey);
    _pendingRequests[memKey] = future;
    try {
      return await future;
    } finally {
      _pendingRequests.remove(memKey);
    }
  }

  Future<Either<Failure, List<Course>>> _fetchFeaturedNetwork(String memKey) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(HomeMessages.noInternet));
    }
    try {
      final models = await remoteDataSource.getFeaturedCourses();
      _memoryCache.set(memKey, models);
      if (localDataSource != null) {
        unawaited(localDataSource!.cacheFeaturedCourses(models, _ttlFeatured));
      }
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Banner>>> getBanners() async {
    const memKey = _memKeyBanners;
    final mem = _memoryCache.get(memKey, ttl: _ttlBanners) as List<BannerModel>?;
    if (mem != null) {
      return Right(mem.map((m) => m.toEntity()).toList());
    }

    if (localDataSource != null) {
      final local = await localDataSource!.getCachedBanners(_ttlBanners);
      if (local != null) {
        _memoryCache.set(memKey, local);
        return Right(local.map((m) => m.toEntity()).toList());
      }
    }

    if (_pendingRequests.containsKey(memKey)) {
      return _pendingRequests[memKey] as Future<Either<Failure, List<Banner>>>;
    }
    final future = _fetchBannersNetwork(memKey);
    _pendingRequests[memKey] = future;
    try {
      return await future;
    } finally {
      _pendingRequests.remove(memKey);
    }
  }

  Future<Either<Failure, List<Banner>>> _fetchBannersNetwork(String memKey) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(HomeMessages.noInternet));
    }
    try {
      final models = await remoteDataSource.getBanners();
      _memoryCache.set(memKey, models);
      if (localDataSource != null) {
        unawaited(localDataSource!.cacheBanners(models, _ttlBanners));
      }
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    const memKey = _memKeyCategories;
    final mem = _memoryCache.get(memKey, ttl: _ttlCategories) as List<CategoryModel>?;
    if (mem != null) {
      return Right(mem.map((m) => m.toEntity()).toList());
    }

    if (localDataSource != null) {
      final local = await localDataSource!.getCachedCategories(_ttlCategories);
      if (local != null) {
        _memoryCache.set(memKey, local);
        return Right(local.map((m) => m.toEntity()).toList());
      }
    }

    if (_pendingRequests.containsKey(memKey)) {
      return _pendingRequests[memKey] as Future<Either<Failure, List<Category>>>;
    }
    final future = _fetchCategoriesNetwork(memKey);
    _pendingRequests[memKey] = future;
    try {
      return await future;
    } finally {
      _pendingRequests.remove(memKey);
    }
  }

  Future<Either<Failure, List<Category>>> _fetchCategoriesNetwork(String memKey) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(HomeMessages.noInternet));
    }
    try {
      final models = await remoteDataSource.getCourseCategories();
      _memoryCache.set(memKey, models);
      if (localDataSource != null) {
        unawaited(localDataSource!.cacheCategories(models, _ttlCategories));
      }
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> searchCourses({
    String? code,
    String? categoryId,
    String? level,
    double? avgStar,
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'title',
    String sortOrder = 'ASC',
  }) async {
    // For search we mainly deduplicate identical queries within a short window.
    final keyBuffer = StringBuffer('home_search_')
      ..write(code ?? '')
      ..write('_')
      ..write(categoryId ?? '')
      ..write('_')
      ..write(level ?? '')
      ..write('_')
      ..write(avgStar?.toString() ?? '')
      ..write('_')
      ..write(pageNumber)
      ..write('_')
      ..write(pageSize)
      ..write('_')
      ..write(sortField)
      ..write('_')
      ..write(sortOrder);
    final memKey = keyBuffer.toString();

    if (_pendingRequests.containsKey(memKey)) {
      return _pendingRequests[memKey] as Future<Either<Failure, List<Course>>>;
    }

    Future<Either<Failure, List<Course>>> future() async {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }
      try {
        final models = await remoteDataSource.searchCourses(
          code: code,
          categoryId: categoryId,
          level: level,
          avgStar: avgStar,
          pageNumber: pageNumber,
          pageSize: pageSize,
          sortField: sortField,
          sortOrder: sortOrder,
        );
        return Right(models.map((m) => m.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    }

    final f = future();
    _pendingRequests[memKey] = f;
    try {
      return await f;
    } finally {
      _pendingRequests.remove(memKey);
    }
  }
}
