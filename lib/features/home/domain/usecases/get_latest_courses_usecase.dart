import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/home_repository.dart';

/// Use case for getting latest courses
class GetLatestCoursesUseCase implements UseCase<List<Course>, GetLatestCoursesParams> {
  final HomeRepository repository;

  GetLatestCoursesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Course>>> call(GetLatestCoursesParams params) async {
    return await repository.getLatestCourses(limit: params.limit);
  }
}

/// Parameters for GetLatestCoursesUseCase
class GetLatestCoursesParams {
  final int limit;

  GetLatestCoursesParams({this.limit = 50});
}
