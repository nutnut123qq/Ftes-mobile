import '../models/blog_model.dart';
import '../models/blog_category_model.dart';
import '../models/paginated_blog_response_model.dart';

/// Abstract remote data source for blog operations
abstract class BlogRemoteDataSource {
  /// Get all blog categories
  Future<List<BlogCategoryModel>> getBlogCategories();
  
  /// Get all blogs with pagination
  Future<PaginatedBlogResponseModel> getAllBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
  });
  
  /// Search blogs with filters
  Future<PaginatedBlogResponseModel> searchBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? title,
    String? category,
  });
  
  /// Get blog by ID
  Future<BlogModel> getBlogById(String blogId);
  
  /// Get blog by slug name
  Future<BlogModel> getBlogBySlug(String slugName);
}
