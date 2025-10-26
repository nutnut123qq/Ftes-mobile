import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/course_detail.dart';
import '../repositories/course_repository.dart';

/// Use case for getting course detail by slug
class GetCourseDetailUseCase implements UseCase<CourseDetail, CourseDetailParams> {
  final CourseRepository repository;

  GetCourseDetailUseCase(this.repository);

  @override
  Future<Either<Failure, CourseDetail>> call(CourseDetailParams params) async {
    return await repository.getCourseDetailBySlug(params.slugName, params.userId);
  }
}

/// Parameters for GetCourseDetailUseCase
class CourseDetailParams {
  final String slugName;
  final String? userId;

  const CourseDetailParams({
    required this.slugName,
    this.userId,
  });
}
