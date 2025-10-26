import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/blog_model.dart';
import '../models/blog_category_model.dart';
import '../models/paginated_blog_response_model.dart';
import 'blog_remote_datasource.dart';

/// Remote data source implementation for Blog feature
class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final ApiClient _apiClient;

  BlogRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<BlogCategoryModel>> getBlogCategories() async {
    try {
      debugPrint('📂 Fetching blog categories: ${AppConstants.baseUrl}${AppConstants.blogCategoriesEndpoint}');
      
      final response = await _apiClient.get(AppConstants.blogCategoriesEndpoint);
      
      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null && result is List) {
            return result
                .map((categoryJson) => BlogCategoryModel.fromJson(categoryJson))
                .toList();
          } else {
            throw ServerException('Invalid response format for blog categories');
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch blog categories');
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch blog categories');
      }
    } catch (e) {
      debugPrint('❌ Get blog categories error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to fetch blog categories: ${e.toString()}');
    }
  }

  @override
  Future<PaginatedBlogResponseModel> getAllBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      debugPrint('📚 Fetching all blogs: ${AppConstants.baseUrl}${AppConstants.blogsEndpoint}');
      debugPrint('📊 Page: $pageNumber, Size: $pageSize, Sort: $sortField $sortOrder');
      
      final response = await _apiClient.get(
        AppConstants.blogsEndpoint,
        queryParameters: {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString(),
          'sortField': sortField,
          'sortOrder': sortOrder,
        },
      );
      
      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null) {
            return PaginatedBlogResponseModel.fromJson(result);
          } else {
            throw ServerException('Invalid response format for blogs');
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch blogs');
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch blogs');
      }
    } catch (e) {
      debugPrint('❌ Get all blogs error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to fetch blogs: ${e.toString()}');
    }
  }

  @override
  Future<PaginatedBlogResponseModel> searchBlogs({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? title,
    String? category,
  }) async {
    try {
      debugPrint('🔍 Searching blogs: ${AppConstants.baseUrl}${AppConstants.blogsSearchEndpoint}');
      debugPrint('📊 Page: $pageNumber, Size: $pageSize, Title: $title, Category: $category');
      
      final queryParams = {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'sortField': sortField,
        'sortOrder': sortOrder,
      };
      
      if (title != null && title.isNotEmpty) {
        queryParams['title'] = title;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      
      final response = await _apiClient.get(
        AppConstants.blogsSearchEndpoint,
        queryParameters: queryParams,
      );
      
      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null) {
            return PaginatedBlogResponseModel.fromJson(result);
          } else {
            throw ServerException('Invalid response format for search blogs');
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to search blogs');
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to search blogs');
      }
    } catch (e) {
      debugPrint('❌ Search blogs error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to search blogs: ${e.toString()}');
    }
  }

  @override
  Future<BlogModel> getBlogById(String blogId) async {
    try {
      debugPrint('📖 Fetching blog by ID: ${AppConstants.baseUrl}${AppConstants.blogsEndpoint}/$blogId');
      
      final response = await _apiClient.get('${AppConstants.blogsEndpoint}/$blogId');
      
      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null) {
            return BlogModel.fromJson(result);
          } else {
            throw ServerException('Invalid response format for blog detail');
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch blog detail');
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch blog detail');
      }
    } catch (e) {
      debugPrint('❌ Get blog by ID error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to fetch blog detail: ${e.toString()}');
    }
  }

  @override
  Future<BlogModel> getBlogBySlug(String slugName) async {
    try {
      debugPrint('📖 Fetching blog by slug: ${AppConstants.baseUrl}${AppConstants.blogsEndpoint}/$slugName');
      
      final response = await _apiClient.get('${AppConstants.blogsEndpoint}/$slugName');
      
      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null) {
            return BlogModel.fromJson(result);
          } else {
            throw ServerException('Invalid response format for blog detail');
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch blog detail');
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch blog detail');
      }
    } catch (e) {
      debugPrint('❌ Get blog by slug error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to fetch blog detail: ${e.toString()}');
    }
  }
}
