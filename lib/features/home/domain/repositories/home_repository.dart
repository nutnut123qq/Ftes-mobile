import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import '../entities/course.dart';
import '../entities/banner.dart';
import '../entities/category.dart';

/// Abstract repository for home feature
abstract class HomeRepository {
  /// Get latest courses
  Future<Either<Failure, List<Course>>> getLatestCourses({int limit = 3});
  
  /// Get featured courses
  Future<Either<Failure, List<Course>>> getFeaturedCourses();
  
  /// Get banners
  Future<Either<Failure, List<Banner>>> getBanners();
  
  /// Get course categories
  Future<Either<Failure, List<Category>>> getCategories();
}
