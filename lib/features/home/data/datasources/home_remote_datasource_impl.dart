import 'package:ftes/core/network/api_client.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/error/exceptions.dart';
import '../models/course_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
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
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null && result['data'] is List) {
          final coursesList = result['data'] as List;
          return coursesList
              .map((courseJson) => CourseModel.fromJson(courseJson))
              .toList();
        } else if (response.data is List) {
          final coursesList = response.data as List;
          return coursesList
              .map((courseJson) => CourseModel.fromJson(courseJson))
              .toList();
        } else {
          throw ServerException('Invalid response format for latest courses');
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch latest courses');
      }
    } catch (e) {
      print('❌ Get latest courses error: $e');
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
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null && result['data'] is List) {
          final coursesList = result['data'] as List;
          return coursesList
              .map((courseJson) => CourseModel.fromJson(courseJson))
              .toList();
        } else if (response.data is List) {
          final coursesList = response.data as List;
          return coursesList
              .map((courseJson) => CourseModel.fromJson(courseJson))
              .toList();
        } else {
          throw ServerException('Invalid response format for featured courses');
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch featured courses');
      }
    } catch (e) {
      print('❌ Get featured courses error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      print('🖼️ Fetching banners: ${AppConstants.baseUrl}${AppConstants.bannerEndpoint}');
      
      final response = await _apiClient.get(AppConstants.bannerEndpoint);
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null && result['data'] is List) {
          final bannersList = result['data'] as List;
          return bannersList
              .map((bannerJson) => BannerModel.fromJson(bannerJson))
              .toList();
        } else if (response.data is List) {
          final bannersList = response.data as List;
          return bannersList
              .map((bannerJson) => BannerModel.fromJson(bannerJson))
              .toList();
        } else {
          throw ServerException('Invalid response format for banners');
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch banners');
      }
    } catch (e) {
      print('❌ Get banners error: $e');
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
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null && result['data'] is List) {
          final categoriesList = result['data'] as List;
          return categoriesList
              .map((categoryJson) => CategoryModel.fromJson(categoryJson))
              .toList();
        } else if (response.data is List) {
          final categoriesList = response.data as List;
          return categoriesList
              .map((categoryJson) => CategoryModel.fromJson(categoryJson))
              .toList();
        } else {
          throw ServerException('Invalid response format for categories');
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch categories');
      }
    } catch (e) {
      print('❌ Get categories error: $e');
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
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null && result['data'] is List) {
          final coursesList = result['data'] as List;
          return coursesList
              .map((courseJson) => CourseModel.fromJson(courseJson))
              .toList();
        } else if (response.data is List) {
          final coursesList = response.data as List;
          return coursesList
              .map((courseJson) => CourseModel.fromJson(courseJson))
              .toList();
        } else {
          throw ServerException('Invalid response format for category courses');
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch category courses');
      }
    } catch (e) {
      print('❌ Get category courses error: $e');
      throw ServerException(e.toString());
    }
  }
}
