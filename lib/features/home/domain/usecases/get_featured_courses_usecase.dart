import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/home_repository.dart';

/// Use case for getting featured courses
class GetFeaturedCoursesUseCase implements UseCase<List<Course>, NoParams> {
  final HomeRepository repository;

  GetFeaturedCoursesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Course>>> call(NoParams params) async {
    return await repository.getFeaturedCourses();
  }
}
