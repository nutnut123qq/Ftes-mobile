import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/video_playlist.dart';
import '../../domain/entities/video_status.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';
import '../datasources/course_local_datasource.dart';
import '../models/course_detail_model.dart';
import '../../domain/constants/course_constants.dart';

/// Repository implementation for Course feature
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;
  final CourseLocalDataSource? localDataSource;
  final NetworkInfo networkInfo;

  CourseRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CourseDetail>> getCourseDetailBySlug(
    String slugName, 
    String? userId,
  ) async {
    final cacheKey = '${CourseConstants.cacheKeyPrefixCourseDetail}${slugName}_${userId ?? 'guest'}';

    // Try cache first if available
    if (localDataSource != null) {
      final cached = await localDataSource!
          .getCachedCourseDetail(cacheKey, CourseConstants.cacheDurationCourseDetail);
      if (cached != null) {
        return Right(cached.toEntity());
      }
    }

    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getCourseDetailBySlug(slugName, userId);
        // cache result asynchronously (fire-and-forget)
        if (localDataSource != null) {
          // ignore: unawaited_futures
          localDataSource!.cacheCourseDetail(
            cacheKey,
            model,
            CourseConstants.cacheDurationCourseDetail,
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
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Profile>> getProfile(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getProfile(userId);
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
  Future<Either<Failure, bool>> checkEnrollment(String userId, String courseId) async {
    if (await networkInfo.isConnected) {
      try {
        final isEnrolled = await remoteDataSource.checkEnrollment(userId, courseId);
        return Right(isEnrolled);
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
  Future<Either<Failure, void>> enrollCourse(String userId, String courseId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.enrollCourse(userId, courseId);
        return const Right(null);
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
  Future<Either<Failure, VideoPlaylist>> getVideoPlaylist(String videoId, bool presign) async {
    final cacheKey = '${CourseConstants.cacheKeyPrefixVideoPlaylist}$videoId';

    // Only cache non-presigned URLs to avoid expiry issues
    if (!presign && localDataSource != null) {
      final cached = await localDataSource!
          .getCachedVideoPlaylist(cacheKey, CourseConstants.cacheDurationCourseDetail);
      if (cached != null) {
        return Right(cached.toEntity());
      }
    }

    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getVideoPlaylist(videoId, presign: presign);
        if (!presign && localDataSource != null) {
          // ignore: unawaited_futures
          localDataSource!.cacheVideoPlaylist(
            cacheKey,
            model,
            CourseConstants.cacheDurationCourseDetail,
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
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, VideoStatus>> getVideoStatus(String videoId) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getVideoStatus(videoId);
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
