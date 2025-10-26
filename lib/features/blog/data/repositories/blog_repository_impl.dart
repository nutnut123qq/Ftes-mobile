import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/blog.dart';
import '../../domain/entities/blog_category.dart';
import '../../domain/entities/paginated_blog_response.dart';
import '../../domain/repositories/blog_repository.dart';
import '../datasources/blog_remote_datasource.dart';

/// Repository implementation for Blog feature
class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BlogRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BlogCategory>>> getBlogCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getBlogCategories();
        return Right(models.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PaginatedBlogResponse>> getAllBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getAllBlogs(
          pageNumber: pageNumber,
          pageSize: pageSize,
          sortField: sortField,
          sortOrder: sortOrder,
        );
        return Right(model.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
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
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.searchBlogs(
          pageNumber: pageNumber,
          pageSize: pageSize,
          sortField: sortField,
          sortOrder: sortOrder,
          title: title,
          category: category,
        );
        return Right(model.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Blog>> getBlogById(String blogId) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getBlogById(blogId);
        return Right(model.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Blog>> getBlogBySlug(String slugName) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getBlogBySlug(slugName);
        return Right(model.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
