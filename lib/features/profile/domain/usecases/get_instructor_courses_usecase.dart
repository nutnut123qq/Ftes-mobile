import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/instructor_course.dart';
import '../../domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

/// Use case to get courses created by instructor
class GetInstructorCoursesUseCase implements UseCase<List<InstructorCourse>, String> {
  final ProfileRepository _repository;

  GetInstructorCoursesUseCase(this._repository);

  @override
  Future<Either<Failure, List<InstructorCourse>>> call(String userId) async {
    return await _repository.getCoursesByCreator(userId);
  }
}
