import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/my_course.dart';
import '../../domain/repositories/my_courses_repository.dart';
import '../datasources/my_courses_remote_datasource.dart';

/// Repository implementation for My Courses feature
class MyCoursesRepositoryImpl implements MyCoursesRepository {
  final MyCoursesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MyCoursesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MyCourse>>> getUserCourses(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUserCourses(userId);
        return Right(models.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
