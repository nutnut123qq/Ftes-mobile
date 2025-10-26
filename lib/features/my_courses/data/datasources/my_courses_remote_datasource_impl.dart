import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/my_course_model.dart';
import 'my_courses_remote_datasource.dart';

/// Remote data source implementation for My Courses feature
class MyCoursesRemoteDataSourceImpl implements MyCoursesRemoteDataSource {
  final ApiClient _apiClient;

  MyCoursesRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<MyCourseModel>> getUserCourses(String userId) async {
    try {
      print('📚 Fetching user courses: ${AppConstants.baseUrl}${AppConstants.myCoursesEndpoint}/$userId');
      final response = await _apiClient.get(
        '${AppConstants.myCoursesEndpoint}/$userId',
      );
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null && result is List) {
          final coursesList = result as List;
          return coursesList
              .map((courseJson) => MyCourseModel.fromJson(courseJson))
              .toList();
        } else if (response.data is List) {
          final coursesList = response.data as List;
          return coursesList
              .map((courseJson) => MyCourseModel.fromJson(courseJson))
              .toList();
        } else {
          throw ServerException('Invalid response format for user courses');
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to fetch user courses');
      }
    } catch (e) {
      print('❌ Get user courses error: $e');
      throw ServerException(e.toString());
    }
  }
}
