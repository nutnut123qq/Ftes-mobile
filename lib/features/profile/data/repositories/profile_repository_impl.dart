import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/instructor_course.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/constants/profile_constants.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/upload_image_response_model.dart';

/// Profile repository implementation
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource? _localDataSource;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    ProfileLocalDataSource? localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, Profile>> getProfileById(String userId) async {
    try {
      // 1. Try cache first (even offline)
      final localDataSource = _localDataSource;
      if (localDataSource != null) {
        final cached = await localDataSource
            .getCachedProfile(userId, ProfileConstants.profileCacheTTL);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      }

      // 2. Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final model = await _remoteDataSource.getProfileById(userId);

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource
              .cacheProfile(userId, model, ProfileConstants.profileCacheTTL)
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
      return Left(ServerFailure('${ProfileConstants.errorGetProfileFailed}: $e'));
    }
  }

  @override
  Future<Either<Failure, Profile>> getProfileByUsername(String userName, {String? postId}) async {
    try {
      // 1. Try cache first (even offline)
      final localDataSource = _localDataSource;
      if (localDataSource != null) {
        final cached = await localDataSource
            .getCachedProfileByUsername(userName, ProfileConstants.profileCacheTTL);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      }

      // 2. Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final model = await _remoteDataSource.getProfileByUsername(userName, postId: postId);

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource
              .cacheProfileByUsername(userName, model, ProfileConstants.profileCacheTTL)
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
      return Left(ServerFailure('${ProfileConstants.errorGetProfileFailed}: $e'));
    }
  }

  @override
  Future<Either<Failure, Profile>> getInstructorProfileByUsername(String userName) async {
    try {
      // 1. Try cache first (even offline)
      final localDataSource = _localDataSource;
      if (localDataSource != null) {
        final cached = await localDataSource
            .getCachedProfileByUsername(userName, ProfileConstants.profileCacheTTL);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      }

      // 2. Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final model = await _remoteDataSource.getInstructorProfileByUsername(userName);

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource
              .cacheProfileByUsername(userName, model, ProfileConstants.profileCacheTTL)
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
      return Left(ServerFailure('${ProfileConstants.errorGetProfileFailed}: $e'));
    }
  }

  @override
  Future<Either<Failure, List<InstructorCourse>>> getCoursesByCreator(String userId) async {
    try {
      // 1. Try cache first (even offline)
      final localDataSource = _localDataSource;
      if (localDataSource != null) {
        final cached = await localDataSource
            .getCachedInstructorCourses(userId, ProfileConstants.instructorCoursesCacheTTL);
        if (cached != null) {
          return Right(cached.map((model) => model.toEntity()).toList());
        }
      }

      // 2. Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final models = await _remoteDataSource.getCoursesByCreator(userId);

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource
              .cacheInstructorCourses(userId, models, ProfileConstants.instructorCoursesCacheTTL)
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
      return Left(ServerFailure('${ProfileConstants.errorGetInstructorCoursesFailed}: $e'));
    }
  }

  @override
  Future<Either<Failure, Profile>> createProfile(String userId, Map<String, dynamic> requestData) async {
    try {
      // Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // Create profile
      final model = await _remoteDataSource.createProfile(userId, requestData);

      // Cache the new profile
      final localDataSource = _localDataSource;
      if (localDataSource != null) {
        unawaited(
          localDataSource
              .cacheProfile(userId, model, ProfileConstants.profileCacheTTL)
              .catchError((_) {}),
        );
        // Also cache by username if available
        if (model.username.isNotEmpty) {
          unawaited(
            localDataSource
                .cacheProfileByUsername(model.username, model, ProfileConstants.profileCacheTTL)
                .catchError((_) {}),
          );
        }
      }

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${ProfileConstants.errorCreateProfileFailed}: $e'));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(String userId, Map<String, dynamic> requestData) async {
    try {
      // Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // Update profile
      final model = await _remoteDataSource.updateProfile(userId, requestData);

      // Invalidate and cache the updated profile
      final localDataSource = _localDataSource;
      if (localDataSource != null) {
        // Invalidate old cache
        await localDataSource.invalidateProfile(userId);
        if (model.username.isNotEmpty) {
          await localDataSource.invalidateProfileByUsername(model.username);
        }

        // Cache updated profile
        unawaited(
          localDataSource
              .cacheProfile(userId, model, ProfileConstants.profileCacheTTL)
              .catchError((_) {}),
        );
        if (model.username.isNotEmpty) {
          unawaited(
            localDataSource
                .cacheProfileByUsername(model.username, model, ProfileConstants.profileCacheTTL)
                .catchError((_) {}),
          );
        }
      }

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${ProfileConstants.errorUpdateProfileFailed}: $e'));
    }
  }

  @override
  Future<Either<Failure, Profile>> createProfileAuto(String userId) async {
    try {
      // Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // Create profile automatically
      final model = await _remoteDataSource.createProfileAuto(userId);

      // Cache the new profile
      final localDataSource = _localDataSource;
      if (localDataSource != null) {
        unawaited(
          localDataSource
              .cacheProfile(userId, model, ProfileConstants.profileCacheTTL)
              .catchError((_) {}),
        );
        // Also cache by username if available
        if (model.username.isNotEmpty) {
          unawaited(
            localDataSource
                .cacheProfileByUsername(model.username, model, ProfileConstants.profileCacheTTL)
                .catchError((_) {}),
          );
        }
      }

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${ProfileConstants.errorCreateProfileFailed}: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getParticipantsCount(String instructorId) async {
    try {
      // 1. Try cache first (even offline)
      final localDataSource = _localDataSource;
      if (localDataSource != null) {
        final cached = await localDataSource
            .getCachedParticipantsCount(instructorId, ProfileConstants.participantsCountCacheTTL);
        if (cached != null) {
          return Right(cached);
        }
      }

      // 2. Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // 3. Fetch from network
      final count = await _remoteDataSource.getParticipantsCount(instructorId);

      // 4. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource
              .cacheParticipantsCount(instructorId, count, ProfileConstants.participantsCountCacheTTL)
              .catchError((_) {}),
        );
      }

      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${ProfileConstants.errorCountParticipantsFailed}: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> checkApplyCourse(String userId, String courseId) async {
    try {
      // Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // Check apply course (no cache for this operation)
      final status = await _remoteDataSource.checkApplyCourse(userId, courseId);

      return Right(status);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${ProfileConstants.errorCheckApplyCourseFailed}: $e'));
    }
  }

  @override
  Future<Either<Failure, UploadImageResponseModel>> uploadImage({
    required String filePath,
    String? fileName,
    String? description,
    String? allText,
    String? folderPath,
  }) async {
    try {
      // Check network connection
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(ProfileConstants.errorNoInternet));
      }

      // Upload image (already optimized in RemoteDataSource with isolate and timeout)
      final response = await _remoteDataSource.uploadImage(
        filePath: filePath,
        fileName: fileName,
        description: description,
        allText: allText,
        folderPath: folderPath,
      );

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${ProfileConstants.errorUploadImageFailed}: $e'));
    }
  }
}
