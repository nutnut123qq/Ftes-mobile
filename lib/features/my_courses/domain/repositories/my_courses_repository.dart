import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/my_course.dart';

/// Repository interface for My Courses feature
abstract class MyCoursesRepository {
  /// Get user's enrolled courses
  Future<Either<Failure, List<MyCourse>>> getUserCourses(String userId);
}
