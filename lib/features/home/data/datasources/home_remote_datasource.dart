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

  /// Search courses with filters
  Future<List<CourseModel>> searchCourses({
    String? code,
    String? categoryId,
    String? level,
    double? avgStar,
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'title',
    String sortOrder = 'ASC',
  });
}
