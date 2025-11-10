import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/my_course_model.dart';
import '../helpers/json_parser_helper.dart';
import '../../domain/constants/my_courses_constants.dart';
import 'my_courses_remote_datasource.dart';

/// Remote data source implementation for My Courses feature
class MyCoursesRemoteDataSourceImpl implements MyCoursesRemoteDataSource {
  final ApiClient _apiClient;

  MyCoursesRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<MyCourseModel>> getUserCourses(String userId) async {
    try {
      final response = await _apiClient.get(
        '${AppConstants.myCoursesEndpoint}/$userId',
      );
      if (response.statusCode == 200) {
        final result = response.data['result'];
        List<dynamic> coursesList;
        
        if (result != null && result is List) {
          coursesList = result;
        } else if (response.data is List) {
          coursesList = response.data as List;
        } else {
          throw ServerException(MyCoursesConstants.errorInvalidResponse);
        }
        
        final coursesCount = countCourses(coursesList);
        
        // Use compute isolate for large lists to avoid blocking main thread
        if (coursesCount > MyCoursesConstants.defaultCoursesThreshold) {
          return await compute<List<dynamic>, List<MyCourseModel>>(
            parseMyCourseListJson,
            coursesList,
          );
        } else {
          return parseMyCourseListJson(coursesList);
        }
      } else {
        throw ServerException(response.data['message'] ?? MyCoursesConstants.errorLoadCoursesFailed);
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${MyCoursesConstants.errorLoadCoursesFailed}: ${e.toString()}');
    }
  }
}
