import '../models/course_response.dart';

/// Temporary CourseService for backward compatibility
/// TODO: Migrate to Clean Architecture
class CourseService {
  /// Placeholder methods for backward compatibility
  Future<PagingCourseResponse> getAllCourses({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? searchText,
  }) async {
    // TODO: Implement with new Clean Architecture
    return PagingCourseResponse(
      currentPage: pageNumber,
      totalPage: 1,
      pageSize: pageSize,
      totalCount: 0,
      data: [],
    );
  }

  Future<List<CourseResponse>> getLatestCourses({int limit = 10}) async {
    // TODO: Implement with new Clean Architecture
    return [];
  }

  Future<List<CourseResponse>> getFeaturedCourses() async {
    // TODO: Implement with new Clean Architecture
    return [];
  }

  Future<CourseResponse> getCourseById(String courseId) async {
    // TODO: Implement with new Clean Architecture
    throw UnimplementedError('Use new Clean Architecture');
  }

  Future<List<CourseResponse>> getUserCourses(String userId) async {
    // TODO: Implement with new Clean Architecture
    return [];
  }

  /// Check enrollment - placeholder
  Future<bool> checkEnrollment(String courseId) async {
    // TODO: Implement with new Clean Architecture
    return false;
  }

  /// Enroll course - placeholder
  Future<void> enrollCourse(String courseId) async {
    // TODO: Implement with new Clean Architecture
  }
}
