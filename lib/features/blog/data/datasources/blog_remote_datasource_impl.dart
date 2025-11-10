import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/retry_helper.dart';
import '../models/blog_model.dart';
import '../models/blog_category_model.dart';
import '../models/paginated_blog_response_model.dart';
import '../../../../core/utils/json_parser_helper.dart';
import '../../domain/constants/blog_constants.dart';
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
      
      final response = await retryWithBackoff(
        operation: () => _apiClient.get(AppConstants.blogCategoriesEndpoint),
        maxRetries: BlogConstants.maxRetries,
        initialDelay: BlogConstants.retryDelay,
      );
      
      debugPrint('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null && result is Map<String, dynamic>) {
            final data = result['data'];
            if (data != null && data is List) {
              // Categories typically < 50 items, parse directly
              // But use compute if list is large for consistency
              if (data.length > BlogConstants.computeThreshold) {
                debugPrint('🔄 Using compute() isolate for parsing ${data.length} blog categories');
                return await compute(parseBlogCategoryListJson, data);
              } else {
                return parseBlogCategoryListJson(data);
              }
            } else {
              throw const ServerException(BlogConstants.errorInvalidData);
            }
          } else {
            throw const ServerException(BlogConstants.errorInvalidData);
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorLoadingCategories);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorLoadingCategories);
      }
    } catch (e) {
      debugPrint('❌ Get blog categories error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${BlogConstants.errorLoadingCategories}: ${e.toString()}');
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
      
      final response = await retryWithBackoff(
        operation: () => _apiClient.get(
          AppConstants.blogsEndpoint,
          queryParameters: {
            'pageNumber': pageNumber.toString(),
            'pageSize': pageSize.toString(),
            'sortField': sortField,
            'sortOrder': sortOrder,
          },
        ),
        maxRetries: BlogConstants.maxRetries,
        initialDelay: BlogConstants.retryDelay,
      );
      
      debugPrint('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null && result is Map<String, dynamic>) {
            // Extract blog data list for compute isolate parsing
            final data = result['data'];
            if (data != null && data is List) {
              List<BlogModel> blogsList;
              
              // Use compute() isolate for parsing if list is large (>50 items)
              if (data.length > BlogConstants.computeThreshold) {
                debugPrint('🔄 Using compute() isolate for parsing ${data.length} blogs');
                blogsList = await compute(parseBlogListJson, data);
              } else {
                blogsList = parseBlogListJson(data);
              }
              
              // Create paginated response with parsed blogs
              return PaginatedBlogResponseModel(
                data: blogsList,
                currentPage: result['currentPage'] ?? pageNumber,
                totalPages: result['totalPages'] ?? 1,
                totalElements: result['totalElements'] ?? blogsList.length,
              );
            } else {
              throw const ServerException(BlogConstants.errorInvalidData);
            }
          } else {
            throw const ServerException(BlogConstants.errorInvalidData);
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorLoadingBlogs);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorLoadingBlogs);
      }
    } catch (e) {
      debugPrint('❌ Get all blogs error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${BlogConstants.errorLoadingBlogs}: ${e.toString()}');
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
      
      final response = await retryWithBackoff(
        operation: () => _apiClient.get(
          AppConstants.blogsSearchEndpoint,
          queryParameters: queryParams,
        ),
        maxRetries: BlogConstants.maxRetries,
        initialDelay: BlogConstants.retryDelay,
      );
      
      debugPrint('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null && result is Map<String, dynamic>) {
            // Extract blog data list for compute isolate parsing
            final data = result['data'];
            if (data != null && data is List) {
              List<BlogModel> blogsList;
              
              // Use compute() isolate for parsing if list is large (>50 items)
              if (data.length > BlogConstants.computeThreshold) {
                debugPrint('🔄 Using compute() isolate for parsing ${data.length} search results');
                blogsList = await compute(parseBlogListJson, data);
              } else {
                blogsList = parseBlogListJson(data);
              }
              
              // Create paginated response with parsed blogs
              return PaginatedBlogResponseModel(
                data: blogsList,
                currentPage: result['currentPage'] ?? pageNumber,
                totalPages: result['totalPages'] ?? 1,
                totalElements: result['totalElements'] ?? blogsList.length,
              );
            } else {
              throw const ServerException(BlogConstants.errorInvalidData);
            }
          } else {
            throw const ServerException(BlogConstants.errorInvalidData);
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorSearchingBlogs);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorSearchingBlogs);
      }
    } catch (e) {
      debugPrint('❌ Search blogs error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${BlogConstants.errorSearchingBlogs}: ${e.toString()}');
    }
  }

  @override
  Future<BlogModel> getBlogById(String blogId) async {
    try {
      debugPrint('📖 Fetching blog by ID: ${AppConstants.baseUrl}${AppConstants.blogsEndpoint}/$blogId');
      
      final response = await retryWithBackoff(
        operation: () => _apiClient.get('${AppConstants.blogsEndpoint}/$blogId'),
        maxRetries: BlogConstants.maxRetries,
        initialDelay: BlogConstants.retryDelay,
      );
      
      debugPrint('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null) {
            // Always parse in isolate to avoid blocking UI thread
            // Blog content can be large (HTML content)
            return await compute(parseBlogModelJson, result as Map<String, dynamic>);
          } else {
            throw const ServerException(BlogConstants.errorInvalidData);
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorLoadingBlogDetail);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorLoadingBlogDetail);
      }
    } catch (e) {
      debugPrint('❌ Get blog by ID error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${BlogConstants.errorLoadingBlogDetail}: ${e.toString()}');
    }
  }

  @override
  Future<BlogModel> getBlogBySlug(String slugName) async {
    try {
      debugPrint('📖 Fetching blog by slug: ${AppConstants.baseUrl}${AppConstants.blogsEndpoint}/$slugName');
      
      final response = await retryWithBackoff(
        operation: () => _apiClient.get('${AppConstants.blogsEndpoint}/$slugName'),
        maxRetries: BlogConstants.maxRetries,
        initialDelay: BlogConstants.retryDelay,
      );
      
      debugPrint('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null) {
            // Always parse in isolate to avoid blocking UI thread
            // Blog content can be large (HTML content)
            return await compute(parseBlogModelJson, result as Map<String, dynamic>);
          } else {
            throw const ServerException(BlogConstants.errorInvalidData);
          }
        } else {
          throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorLoadingBlogDetail);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? BlogConstants.errorLoadingBlogDetail);
      }
    } catch (e) {
      debugPrint('❌ Get blog by slug error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${BlogConstants.errorLoadingBlogDetail}: ${e.toString()}');
    }
  }
}
