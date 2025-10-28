import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/instructor_course.dart';
import '../../domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

/// Use case to get courses created by instructor
class GetInstructorCoursesUseCase implements UseCase<List<InstructorCourse>, String> {
  final ProfileRepository _repository;

  GetInstructorCoursesUseCase(this._repository);

  @override
  Future<Either<Failure, List<InstructorCourse>>> call(String userId) async {
    try {
      final courses = await _repository.getCoursesByCreator(userId);
      return Right(courses);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    } else {
      return ServerFailure('Unexpected error: $exception');
    }
  }
}
