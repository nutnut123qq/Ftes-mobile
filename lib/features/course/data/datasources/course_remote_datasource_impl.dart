import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/course_detail_model.dart';
import '../models/profile_model.dart';
import 'course_remote_datasource.dart';

/// Remote data source implementation for Course feature
class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient _apiClient;

  CourseRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<CourseDetailModel> getCourseDetailBySlug(String slugName, String? userId) async {
    try {
      print('📚 Fetching course detail: ${AppConstants.baseUrl}${AppConstants.courseDetailEndpoint}/$slugName');
      print('🔑 Slug: $slugName');
      if (userId != null) {
        print('👤 User ID: $userId');
      }
      
      final queryParams = <String, dynamic>{};
      if (userId != null && userId.isNotEmpty) {
        queryParams['userId'] = userId;
      }
      
      final response = await _apiClient.get(
        '${AppConstants.courseDetailEndpoint}/$slugName',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null) {
          return CourseDetailModel.fromJson(result);
        } else {
          throw ServerException('Invalid response format - missing result');
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch course detail');
      }
    } catch (e) {
      print('❌ Get course detail error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to fetch course detail: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      print('👤 Fetching profile: ${AppConstants.baseUrl}${AppConstants.profileViewEndpoint}/$userId');
      
      final response = await _apiClient.get(
        '${AppConstants.profileViewEndpoint}/$userId',
      );
      
      print('📥 Profile response status: ${response.statusCode}');
      print('📥 Profile response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null) {
          return ProfileModel.fromJson(result);
        } else {
          throw ServerException('Invalid response format - missing result');
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      print('❌ Get profile error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to fetch profile: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkEnrollment(String userId, String courseId) async {
    try {
      print('🔍 Checking enrollment: ${AppConstants.baseUrl}${AppConstants.checkEnrollmentByUserEndpoint}/$userId/apply-course/$courseId');
      
      final response = await _apiClient.get(
        '${AppConstants.checkEnrollmentByUserEndpoint}/$userId/apply-course/$courseId',
      );
      
      print('📥 Enrollment response status: ${response.statusCode}');
      print('📥 Enrollment response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null) {
          // API returns 0 = not enrolled, 1 = enrolled
          return result == 1;
        } else {
          throw ServerException('Invalid response format - missing result');
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? 'Failed to check enrollment');
      }
    } catch (e) {
      print('❌ Check enrollment error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to check enrollment: ${e.toString()}');
    }
  }
}
