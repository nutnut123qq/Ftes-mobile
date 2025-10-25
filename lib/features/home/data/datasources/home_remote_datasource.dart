import '../models/course_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';

/// Abstract remote data source for home operations
abstract class HomeRemoteDataSource {
  /// Get latest courses
  Future<List<CourseModel>> getLatestCourses({int limit = 3});
  
  /// Get featured courses
  Future<List<CourseModel>> getFeaturedCourses();
  
  /// Get banners
  Future<List<BannerModel>> getBanners();
  
  /// Get course categories
  Future<List<CategoryModel>> getCourseCategories();
  
  /// Get courses by category
  Future<List<CourseModel>> getCoursesByCategory(String categoryId);
}
