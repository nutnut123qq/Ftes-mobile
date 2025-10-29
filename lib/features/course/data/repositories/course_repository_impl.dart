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

/// Repository implementation for Course feature
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;
  final CourseLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CourseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CourseDetail>> getCourseDetailBySlug(
    String slugName, 
    String? userId,
  ) async {
    // Strategy: Stale-while-revalidate
    // 1. Try to get from cache first
    // 2. If cache exists and valid, return it immediately
    // 3. If online, fetch fresh data in background and update cache
    // 4. If cache invalid or not exists, fetch from network
    
    try {
      // Check cache first
      final cachedModel = await localDataSource.getCachedCourseDetail(slugName);
      
      if (cachedModel != null) {
        print('📦 Returning cached course detail for: $slugName');
        
        // Return cached data immediately
        final cachedEntity = cachedModel.toEntity();
        
        // If online, refresh in background (fire and forget)
        if (await networkInfo.isConnected) {
          _refreshCacheInBackground(slugName, userId);
        }
        
        return Right(cachedEntity);
      }
    } catch (e) {
      print('⚠️ Cache read error: $e');
      // Continue to network fetch if cache fails
    }

    // No cache or cache error - fetch from network
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getCourseDetailBySlug(slugName, userId);
        
        // Cache the fresh data
        try {
          await localDataSource.cacheCourseDetail(slugName, model);
        } catch (e) {
          print('⚠️ Failed to cache course: $e');
          // Don't fail the whole operation if caching fails
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

  /// Background refresh cache (fire and forget)
  Future<void> _refreshCacheInBackground(String slugName, String? userId) async {
    try {
      print('🔄 Refreshing cache in background for: $slugName');
      final model = await remoteDataSource.getCourseDetailBySlug(slugName, userId);
      await localDataSource.cacheCourseDetail(slugName, model);
      print('✅ Cache refreshed for: $slugName');
    } catch (e) {
      print('⚠️ Background cache refresh failed: $e');
      // Silently fail - don't affect user experience
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
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getVideoPlaylist(videoId, presign: presign);
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
