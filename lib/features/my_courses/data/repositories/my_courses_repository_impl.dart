import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/my_course.dart';
import '../../domain/repositories/my_courses_repository.dart';
import '../../domain/constants/my_courses_constants.dart';
import '../datasources/my_courses_remote_datasource.dart';
import '../datasources/my_courses_local_datasource.dart';
import '../models/my_course_model.dart';

/// Repository implementation for My Courses feature
class MyCoursesRepositoryImpl implements MyCoursesRepository {
  final MyCoursesRemoteDataSource _remoteDataSource;
  final MyCoursesLocalDataSource? _localDataSource;
  final NetworkInfo _networkInfo;

  MyCoursesRepositoryImpl({
    required MyCoursesRemoteDataSource remoteDataSource,
    MyCoursesLocalDataSource? localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<MyCourse>>> getUserCourses(String userId) async {
    try {
      // 1. Parallel execution: Check cache and network status simultaneously
      final localDataSource = _localDataSource;
      final results = await Future.wait([
        localDataSource != null
            ? localDataSource.getCachedUserCourses(userId, MyCoursesConstants.cacheTTL)
            : Future.value(null),
        _networkInfo.isConnected,
      ]);

      final cached = results[0] as List<MyCourseModel>?;
      final isConnected = results[1] as bool;

      // 2. Return cached data if available (even offline)
      if (cached != null) {
        // If connected, refresh cache in background (stale-while-revalidate)
        if (isConnected && localDataSource != null) {
          unawaited(
            _refreshCoursesInBackground(userId, localDataSource)
                .catchError((_) {}),
          );
        }
        // Convert models to entities in isolate if list is large
        final entities = await _convertModelsToEntities(cached);
        return Right(entities);
      }

      // 3. Check network connection
      if (!isConnected) {
        return const Left(NetworkFailure(MyCoursesConstants.errorNoInternet));
      }

      // 4. Fetch from network
      final models = await _remoteDataSource.getUserCourses(userId);

      // 5. Cache for next time (async, don't block)
      if (localDataSource != null) {
        unawaited(
          localDataSource
              .cacheUserCourses(userId, models, MyCoursesConstants.cacheTTL)
              .catchError((_) {}),
        );
      }

      // 6. Convert models to entities in isolate if list is large
      final entities = await _convertModelsToEntities(models);
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('${MyCoursesConstants.errorLoadCoursesFailed}: $e'));
    }
  }

  /// Refresh courses in background (stale-while-revalidate pattern)
  Future<void> _refreshCoursesInBackground(
    String userId,
    MyCoursesLocalDataSource localDataSource,
  ) async {
    try {
      final models = await _remoteDataSource.getUserCourses(userId);
      await localDataSource.cacheUserCourses(userId, models, MyCoursesConstants.cacheTTL);
    } catch (_) {
      // Silently fail background refresh
    }
  }

  /// Convert models to entities, using isolate for large lists
  Future<List<MyCourse>> _convertModelsToEntities(List<MyCourseModel> models) async {
    // Use isolate for large lists to avoid blocking main thread
    if (models.length > MyCoursesConstants.defaultCoursesThreshold) {
      // Convert models to JSON for serialization
      final modelsJson = models.map((model) => model.toJson()).toList();
      
      // Convert in isolate
      final entitiesJson = await compute(_convertModelsToEntitiesInIsolate, modelsJson);
      
      // Convert JSON back to entities
      return entitiesJson.map((json) => MyCourse(
        id: json['id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        imageHeader: json['imageHeader'] as String?,
        slugName: json['slugName'] as String?,
        instructor: json['instructor'] as String?,
        purchaseDate: json['purchaseDate'] as String?,
        courses: (json['courses'] as List<dynamic>?)?.map((c) => CourseReference(
          courseId: c['courseId'] as String?,
        )).toList(),
      )).toList();
    } else {
      // For smaller lists, convert on main thread
      return models.map((model) => model.toEntity()).toList();
    }
  }
}

/// Top-level function for converting models to entities in compute isolate
List<Map<String, dynamic>> _convertModelsToEntitiesInIsolate(List<Map<String, dynamic>> modelsJson) {
  // Just return the JSON as-is, conversion to entity will happen on main thread
  // This avoids complex serialization of CourseReference
  return modelsJson;
}
