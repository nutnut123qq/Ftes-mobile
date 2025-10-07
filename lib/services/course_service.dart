import 'dart:convert';
import '../models/course_response.dart';
import '../utils/api_constants.dart';
import 'http_client.dart';

/// Course Service để xử lý các API liên quan đến khóa học
class CourseService {
  final HttpClient _http = HttpClient();

  CourseService() {
    _http.initialize();
  }

  /// Get all courses with pagination
  /// [pageNumber] - Trang hiện tại (default: 1)
  /// [pageSize] - Số lượng items mỗi trang (default: 10)
  /// [sortField] - Field để sort (default: 'createdAt')
  /// [sortOrder] - Thứ tự sort: 'asc' hoặc 'desc' (default: 'desc')
  /// [searchText] - Text để search (optional)
  Future<PagingCourseResponse> getAllCourses({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? searchText,
  }) async {
    final queryParams = {
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      'sortField': sortField,
      'sortOrder': sortOrder,
    };

    if (searchText != null && searchText.isNotEmpty) {
      queryParams['searchText'] = searchText;
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.coursesEndpoint}')
        .replace(queryParameters: queryParams);

    final resp = await _http.get(uri.toString());

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      return PagingCourseResponse.fromJson(data);
    }

    throw Exception('Failed to load courses: ${resp.statusCode} ${resp.body}');
  }

  /// Get course by ID
  Future<CourseResponse> getCourseById(String courseId) async {
    final resp = await _http.get('${ApiConstants.coursesEndpoint}/$courseId');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      return CourseResponse.fromJson(data);
    }

    throw Exception('Failed to load course: ${resp.statusCode} ${resp.body}');
  }

  /// Get course detail by slug name
  Future<CourseResponse> getCourseBySlug(String slugName) async {
    final resp = await _http.get('${ApiConstants.courseDetailEndpoint}/$slugName');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      return CourseResponse.fromJson(data);
    }

    throw Exception('Failed to load course: ${resp.statusCode} ${resp.body}');
  }

  /// Search courses
  /// [title] - Search by title (optional)
  /// [category] - Search by category (optional)
  /// [level] - Search by level (optional)
  Future<PagingCourseResponse> searchCourses({
    int pageNumber = 1,
    int pageSize = 10,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? title,
    String? category,
    String? level,
  }) async {
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
    if (level != null && level.isNotEmpty) {
      queryParams['level'] = level;
    }

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.coursesSearchEndpoint}')
        .replace(queryParameters: queryParams);

    final resp = await _http.get(uri.toString());

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      return PagingCourseResponse.fromJson(data);
    }

    throw Exception('Failed to search courses: ${resp.statusCode} ${resp.body}');
  }

  /// Get latest courses
  /// [limit] - Số lượng courses cần lấy (default: 10)
  Future<List<CourseResponse>> getLatestCourses({int limit = 10}) async {
    final queryParams = {
      'limit': limit.toString(),
    };

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.latestCoursesEndpoint}')
        .replace(queryParameters: queryParams);

    final resp = await _http.get(uri.toString());

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        return data.map((item) => CourseResponse.fromJson(item)).toList();
      }
      if (data is Map && data['result'] is List) {
        return (data['result'] as List)
            .map((item) => CourseResponse.fromJson(item))
            .toList();
      }
    }

    throw Exception('Failed to load latest courses: ${resp.statusCode} ${resp.body}');
  }

  /// Get featured courses
  Future<List<CourseResponse>> getFeaturedCourses() async {
    final queryParams = {
      'currentPage': 1,
      'pageSize': 100,
    };

    final resp = await _http.get(
      ApiConstants.featuredCoursesEndpoint,
      queryParameters: queryParams,
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      
      // Backend trả về ApiResponse<PagingResponse<GetCourseResponse>>
      if (data is Map && data['result'] != null) {
        final result = data['result'];
        if (result is Map && result['data'] is List) {
          return (result['data'] as List)
              .map((item) => CourseResponse.fromJson(item))
              .toList();
        }
      }
      // Fallback cho format cũ
      if (data is List) {
        return data.map((item) => CourseResponse.fromJson(item)).toList();
      }
      if (data is Map && data['result'] is List) {
        return (data['result'] as List)
            .map((item) => CourseResponse.fromJson(item))
            .toList();
      }
    }

    throw Exception('Failed to load featured courses: ${resp.statusCode} ${resp.body}');
  }

  /// Get courses by user ID
  Future<List<UserCourseResponse>> getUserCourses(String userId) async {
    final resp = await _http.get('${ApiConstants.userCoursesEndpoint}/$userId');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        return data.map((item) => UserCourseResponse.fromJson(item)).toList();
      }
      if (data is Map && data['result'] is List) {
        return (data['result'] as List)
            .map((item) => UserCourseResponse.fromJson(item))
            .toList();
      }
    }

    throw Exception('Failed to load user courses: ${resp.statusCode} ${resp.body}');
  }

  /// Get parts (sections) of a course
  Future<List<PartResponse>> getCourseParts(String courseId) async {
    final resp = await _http.get('${ApiConstants.coursePartsEndpoint}/$courseId');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        return data.map((item) => PartResponse.fromJson(item)).toList();
      }
      if (data is Map && data['result'] is List) {
        return (data['result'] as List)
            .map((item) => PartResponse.fromJson(item))
            .toList();
      }
    }

    throw Exception('Failed to load course parts: ${resp.statusCode} ${resp.body}');
  }

  /// Get lessons of a part
  Future<List<LessonResponse>> getPartLessons(String partId) async {
    final resp = await _http.get('${ApiConstants.partLessonsEndpoint}/$partId');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        return data.map((item) => LessonResponse.fromJson(item)).toList();
      }
      if (data is Map && data['result'] is List) {
        return (data['result'] as List)
            .map((item) => LessonResponse.fromJson(item))
            .toList();
      }
    }

    throw Exception('Failed to load part lessons: ${resp.statusCode} ${resp.body}');
  }

  /// Get lesson by ID
  Future<LessonResponse> getLessonById(String lessonId) async {
    final resp = await _http.get('${ApiConstants.lessonDetailEndpoint}/$lessonId');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      return LessonResponse.fromJson(data);
    }

    throw Exception('Failed to load lesson: ${resp.statusCode} ${resp.body}');
  }

  /// Check enrollment status
  Future<bool> checkEnrollment(String courseId) async {
    final queryParams = {
      'courseId': courseId,
    };

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.checkEnrollmentEndpoint}')
        .replace(queryParameters: queryParams);

    final resp = await _http.get(uri.toString());

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      if (data is bool) return data;
      if (data is Map && data['result'] != null) return data['result'] as bool;
      if (data is Map && data['enrolled'] != null) return data['enrolled'] as bool;
    }

    return false;
  }

  /// Enroll in a course
  Future<void> enrollCourse(String courseId) async {
    final body = {
      'courseId': courseId,
    };

    final resp = await _http.post(ApiConstants.enrollCourseEndpoint, body: body);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to enroll course: ${resp.statusCode} ${resp.body}');
    }
  }
}
