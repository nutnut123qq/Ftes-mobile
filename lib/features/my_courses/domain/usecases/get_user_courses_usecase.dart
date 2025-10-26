import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/my_course.dart';
import '../repositories/my_courses_repository.dart';

/// Use case for getting user's enrolled courses
class GetUserCoursesUseCase implements UseCase<List<MyCourse>, String> {
  final MyCoursesRepository repository;

  GetUserCoursesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MyCourse>>> call(String userId) async {
    return await repository.getUserCourses(userId);
  }
}
