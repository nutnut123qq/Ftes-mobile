import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/course_repository.dart';

/// Use case for enrolling in a course
class EnrollCourseUseCase implements UseCase<void, EnrollCourseParams> {
  final CourseRepository repository;

  EnrollCourseUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(EnrollCourseParams params) async {
    return await repository.enrollCourse(params.userId, params.courseId);
  }
}

/// Parameters for EnrollCourseUseCase
class EnrollCourseParams {
  final String userId;
  final String courseId;

  const EnrollCourseParams({
    required this.userId,
    required this.courseId,
  });
}

