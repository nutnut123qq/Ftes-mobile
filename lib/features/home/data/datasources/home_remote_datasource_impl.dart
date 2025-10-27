import 'package:flutter/foundation.dart';
import 'package:ftes/core/network/api_client.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/error/exceptions.dart';
import '../models/course_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../helpers/json_parser_helper.dart';
import 'home_remote_datasource.dart';

/// Implementation of HomeRemoteDataSource
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<CourseModel>> getLatestCourses({int limit = 50}) async {
    try {
      print('📚 Fetching latest courses: ${AppConstants.baseUrl}${AppConstants.latestCoursesEndpoint}');
      print('📊 Limit: $limit');
      
      final response = await _apiClient.get(
        AppConstants.latestCoursesEndpoint,
        queryParameters: {
          'pageNumber': '1',
          'pageSize': limit.toString(),
          'sortField': 'createdAt',
          'sortOrder': 'desc',
        },
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        List<dynamic> coursesList;
        
        if (result != null && result['data'] is List) {
          coursesList = result['data'] as List;
        } else if (response.data is List) {
          coursesList = response.data as List;
        } else {
          throw const ServerException('Invalid response format for latest courses');
        }
        
        // Use compute() isolate for parsing if list is large (>50 items)
        if (coursesList.length > 50) {
          print('🔄 Using compute() isolate for parsing ${coursesList.length} courses');
          return await compute(parseCourseListJson, coursesList);
        } else {
          // For smaller lists, parse directly on main isolate
          return parseCourseListJson(coursesList);
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch latest courses');
      }
    } catch (e) {
      print('❌ Get latest courses error: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CourseModel>> getFeaturedCourses() async {
    try {
      print('⭐ Fetching featured courses: ${AppConstants.baseUrl}${AppConstants.featuredCoursesEndpoint}');
      
      final response = await _apiClient.get(
        AppConstants.featuredCoursesEndpoint,
        queryParameters: {
          'pageNumber': '1',
          'pageSize': '50',
          'sortField': 'createdAt',
          'sortOrder': 'desc',
        },
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        List<dynamic> coursesList;
        
        if (result != null && result['data'] is List) {
          coursesList = result['data'] as List;
        } else if (response.data is List) {
          coursesList = response.data as List;
        } else {
          throw const ServerException('Invalid response format for featured courses');
        }
        
        // Use compute() isolate for parsing if list is large (>50 items)
        if (coursesList.length > 50) {
          print('🔄 Using compute() isolate for parsing ${coursesList.length} featured courses');
          return await compute(parseCourseListJson, coursesList);
        } else {
          return parseCourseListJson(coursesList);
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch featured courses');
      }
    } catch (e) {
      print('❌ Get featured courses error: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      print('🖼️ Fetching banners: ${AppConstants.baseUrl}${AppConstants.bannerEndpoint}');
      
      final response = await _apiClient.get(AppConstants.bannerEndpoint);
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        List<dynamic> bannersList;
        
        if (result != null && result['data'] is List) {
          bannersList = result['data'] as List;
        } else if (response.data is List) {
          bannersList = response.data as List;
        } else {
          throw const ServerException('Invalid response format for banners');
        }
        
        // Banners typically <20 items, no need for compute()
        return parseBannerListJson(bannersList);
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch banners');
      }
    } catch (e) {
      print('❌ Get banners error: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCourseCategories() async {
    try {
      print('📂 Fetching course categories: ${AppConstants.baseUrl}${AppConstants.courseCategoriesEndpoint}');
      
      final response = await _apiClient.get(
        AppConstants.courseCategoriesEndpoint,
        queryParameters: {
          'pageNumber': '1',
          'pageSize': '50',
          'sortField': 'name',
          'sortOrder': 'ASC',
        },
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        List<dynamic> categoriesList;
        
        if (result != null && result['data'] is List) {
          categoriesList = result['data'] as List;
        } else if (response.data is List) {
          categoriesList = response.data as List;
        } else {
          throw const ServerException('Invalid response format for categories');
        }
        
        // Categories typically <50 items, parse directly
        final categories = categoriesList
            .map((categoryJson) => CategoryModel.fromJson(categoryJson as Map<String, dynamic>))
            .toList();
        
        print('✅ Fetched ${categories.length} categories');
        return categories;
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch categories');
      }
    } catch (e) {
      print('❌ Get categories error: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CourseModel>> getCoursesByCategory(String categoryId) async {
    try {
      print('📚 Fetching courses by category: ${AppConstants.baseUrl}${AppConstants.coursesSearchEndpoint}');
      print('🏷️ Category ID: $categoryId');
      
      final response = await _apiClient.get(
        AppConstants.coursesSearchEndpoint,
        queryParameters: {
          'categoryId': categoryId,
          'pageNumber': '1',
          'pageSize': '50',
          'sortField': 'createdAt',
          'sortOrder': 'DESC',
        },
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        List<dynamic> coursesList;
        
        if (result != null && result['data'] is List) {
          coursesList = result['data'] as List;
        } else if (response.data is List) {
          coursesList = response.data as List;
        } else {
          throw const ServerException('Invalid response format for category courses');
        }
        
        // Use compute() isolate for parsing if list is large (>50 items)
        if (coursesList.length > 50) {
          print('🔄 Using compute() isolate for parsing ${coursesList.length} category courses');
          return await compute(parseCourseListJson, coursesList);
        } else {
          return parseCourseListJson(coursesList);
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch category courses');
      }
    } catch (e) {
      print('❌ Get category courses error: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }
}
