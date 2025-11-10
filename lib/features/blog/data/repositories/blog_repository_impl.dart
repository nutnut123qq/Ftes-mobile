import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_category.dart';
import '../../domain/entities/paginated_blog_response.dart';
import '../../domain/repositories/blog_repository.dart';
import '../../domain/constants/blog_constants.dart';
import '../datasources/blog_remote_datasource.dart';
import '../datasources/blog_local_datasource.dart';

/// Repository implementation for Blog feature
class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;
  final BlogLocalDataSource? localDataSource;
  final NetworkInfo networkInfo;

  BlogRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BlogCategory>>> getBlogCategories() async {
    try {
      // 1. Try cache first (even offline)
      if (localDataSource != null) {
        final cached = await localDataSource!
            .getCachedCategories(BlogConstants.categoryCacheTTL);
        if (cached != null) {
          return Right(cached.map((model) => model.toEntity()).toList());
        }
      }

      // 2. Check network connection
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(BlogConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final models = await remoteDataSource.getBlogCategories();

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource!
              .cacheCategories(models, BlogConstants.categoryCacheTTL)
              .catchError((_) {}),
        );
      }

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

  String _generateBlogListCacheKey({
    required int pageNumber,
    required int pageSize,
    required String sortField,
    required String sortOrder,
  }) {
    return 'page_$pageNumber' '_size_$pageSize' '_sort_$sortField' '_$sortOrder';
  }

  @override
  Future<Either<Failure, PaginatedBlogResponse>> getAllBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final cacheKey = _generateBlogListCacheKey(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortField: sortField,
        sortOrder: sortOrder,
      );

      // 1. Try cache first (even offline)
      if (localDataSource != null) {
        final cached = await localDataSource!
            .getCachedBlogs(cacheKey, BlogConstants.cacheTTL);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      }

      // 2. Check network connection
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(BlogConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final model = await remoteDataSource.getAllBlogs(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortField: sortField,
        sortOrder: sortOrder,
      );

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource!
              .cacheBlogs(cacheKey, model, BlogConstants.cacheTTL)
              .catchError((_) {}),
        );
      }

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${BlogConstants.errorLoadingBlogs}: $e'));
    }
  }

  String _generateSearchCacheKey({
    required int pageNumber,
    required int pageSize,
    required String sortField,
    required String sortOrder,
    String? title,
    String? category,
  }) {
    final titlePart = title != null && title.isNotEmpty ? '_title_$title' : '';
    final categoryPart =
        category != null && category.isNotEmpty ? '_cat_$category' : '';
    return 'search_page_$pageNumber' '_size_$pageSize' '_sort_$sortField' '_$sortOrder$titlePart$categoryPart';
  }

  @override
  Future<Either<Failure, PaginatedBlogResponse>> searchBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? title,
    String? category,
  }) async {
    try {
      final cacheKey = _generateSearchCacheKey(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortField: sortField,
        sortOrder: sortOrder,
        title: title,
        category: category,
      );

      // 1. Try cache first (even offline)
      if (localDataSource != null) {
        final cached = await localDataSource!
            .getCachedBlogs(cacheKey, BlogConstants.cacheTTL);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      }

      // 2. Check network connection
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(BlogConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final model = await remoteDataSource.searchBlogs(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortField: sortField,
        sortOrder: sortOrder,
        title: title,
        category: category,
      );

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource!
              .cacheBlogs(cacheKey, model, BlogConstants.cacheTTL)
              .catchError((_) {}),
        );
      }

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${BlogConstants.errorSearchingBlogs}: $e'));
    }
  }

  @override
  Future<Either<Failure, Blog>> getBlogById(String blogId) async {
    try {
      // 1. Try cache first (even offline) - use blogId as cache key
      if (localDataSource != null) {
        final cached = await localDataSource!
            .getCachedBlogDetail(blogId, BlogConstants.blogDetailCacheTTL);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      }

      // 2. Check network connection
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(BlogConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final model = await remoteDataSource.getBlogById(blogId);

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource!
              .cacheBlogDetail(blogId, model, BlogConstants.blogDetailCacheTTL)
              .catchError((_) {}),
        );
      }

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${BlogConstants.errorLoadingBlogDetail}: $e'));
    }
  }

  @override
  Future<Either<Failure, Blog>> getBlogBySlug(String slugName) async {
    try {
      // 1. Try cache first (even offline)
      if (localDataSource != null) {
        final cached = await localDataSource!
            .getCachedBlogDetail(slugName, BlogConstants.blogDetailCacheTTL);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      }

      // 2. Check network connection
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(BlogConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final model = await remoteDataSource.getBlogBySlug(slugName);

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource!
              .cacheBlogDetail(
                  slugName, model, BlogConstants.blogDetailCacheTTL)
              .catchError((_) {}),
        );
      }

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${BlogConstants.errorLoadingBlogDetail}: $e'));
    }
  }
}

