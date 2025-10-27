import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/blog_model.dart';
import '../models/blog_category_model.dart';
import '../models/paginated_blog_response_model.dart';
import '../helpers/json_parser_helper.dart';
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
      print('📂 Fetching blog categories: ${AppConstants.baseUrl}${AppConstants.blogCategoriesEndpoint}');
      
      final response = await _apiClient.get(AppConstants.blogCategoriesEndpoint);
      
      print('📥 Response status: ${response.statusCode}');
      
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
                print('🔄 Using compute() isolate for parsing ${data.length} blog categories');
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
      print('❌ Get blog categories error: $e');
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
      print('📚 Fetching all blogs: ${AppConstants.baseUrl}${AppConstants.blogsEndpoint}');
      print('📊 Page: $pageNumber, Size: $pageSize, Sort: $sortField $sortOrder');
      
      final response = await _apiClient.get(
        AppConstants.blogsEndpoint,
        queryParameters: {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString(),
          'sortField': sortField,
          'sortOrder': sortOrder,
        },
      );
      
      print('📥 Response status: ${response.statusCode}');
      
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
                print('🔄 Using compute() isolate for parsing ${data.length} blogs');
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
      print('❌ Get all blogs error: $e');
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
      print('🔍 Searching blogs: ${AppConstants.baseUrl}${AppConstants.blogsSearchEndpoint}');
      print('📊 Page: $pageNumber, Size: $pageSize, Title: $title, Category: $category');
      
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
      
      print('📥 Response status: ${response.statusCode}');
      
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
                print('🔄 Using compute() isolate for parsing ${data.length} search results');
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
      print('❌ Search blogs error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${BlogConstants.errorSearchingBlogs}: ${e.toString()}');
    }
  }

  @override
  Future<BlogModel> getBlogById(String blogId) async {
    try {
      print('📖 Fetching blog by ID: ${AppConstants.baseUrl}${AppConstants.blogsEndpoint}/$blogId');
      
      final response = await _apiClient.get('${AppConstants.blogsEndpoint}/$blogId');
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null) {
            return BlogModel.fromJson(result);
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
      print('❌ Get blog by ID error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${BlogConstants.errorLoadingBlogDetail}: ${e.toString()}');
    }
  }

  @override
  Future<BlogModel> getBlogBySlug(String slugName) async {
    try {
      print('📖 Fetching blog by slug: ${AppConstants.baseUrl}${AppConstants.blogsEndpoint}/$slugName');
      
      final response = await _apiClient.get('${AppConstants.blogsEndpoint}/$slugName');
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          final result = response.data['result'];
          if (result != null) {
            return BlogModel.fromJson(result);
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
      print('❌ Get blog by slug error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${BlogConstants.errorLoadingBlogDetail}: ${e.toString()}');
    }
  }
}
