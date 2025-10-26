import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/course_repository.dart';

/// Use case for checking enrollment status
class CheckEnrollmentUseCase implements UseCase<bool, CheckEnrollmentParams> {
  final CourseRepository repository;

  CheckEnrollmentUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckEnrollmentParams params) async {
    return await repository.checkEnrollment(params.userId, params.courseId);
  }
}

/// Parameters for CheckEnrollmentUseCase
class CheckEnrollmentParams {
  final String userId;
  final String courseId;

  const CheckEnrollmentParams({
    required this.userId,
    required this.courseId,
  });
}
