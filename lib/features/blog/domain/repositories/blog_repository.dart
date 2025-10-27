import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/blog.dart';
import '../entities/blog_category.dart';
import '../entities/paginated_blog_response.dart';

/// Abstract repository interface for blog operations
abstract class BlogRepository {
  /// Get all blog categories
  Future<Either<Failure, List<BlogCategory>>> getBlogCategories();
  
  /// Get all blogs with pagination
  Future<Either<Failure, PaginatedBlogResponse>> getAllBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
  });
  
  /// Search blogs with filters
  Future<Either<Failure, PaginatedBlogResponse>> searchBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? title,
    String? category,
  });
  
  /// Get blog by ID
  Future<Either<Failure, Blog>> getBlogById(String blogId);
  
  /// Get blog by slug name
  Future<Either<Failure, Blog>> getBlogBySlug(String slugName);
}

