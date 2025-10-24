import 'dart:convert';
import '../models/course_response.dart';
import '../core/constants/app_constants.dart';
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

    final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.coursesEndpoint}')
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
    // Use detail endpoint to ensure we get parts and lessons
    final resp = await _http.get('${AppConstants.courseDetailEndpoint}/$courseId');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      
      // Handle different response formats (same as getCourseBySlug)
      Map<String, dynamic> courseData;
      if (data is Map<String, dynamic>) {
        // Check if response is wrapped (e.g., {result: {...}}, {data: {...}})
        if (data.containsKey('result') && data['result'] is Map) {
          courseData = data['result'] as Map<String, dynamic>;
        } else if (data.containsKey('data') && data['data'] is Map) {
          courseData = data['data'] as Map<String, dynamic>;
        } else {
          courseData = data;
        }
      } else {
        throw Exception('Unexpected response format: ${data.runtimeType}');
      }
      
      return CourseResponse.fromJson(courseData);
    }

    throw Exception('Failed to load course: ${resp.statusCode} ${resp.body}');
  }

  /// Get course detail by slug name
  Future<CourseResponse> getCourseBySlug(String slugName) async {
    final resp = await _http.get('${AppConstants.courseDetailEndpoint}/$slugName');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      
      // Handle different response formats
      Map<String, dynamic> courseData;
      if (data is Map<String, dynamic>) {
        // Check if response is wrapped (e.g., {result: {...}}, {data: {...}})
        if (data.containsKey('result') && data['result'] is Map) {
          courseData = data['result'] as Map<String, dynamic>;
        } else if (data.containsKey('data') && data['data'] is Map) {
          courseData = data['data'] as Map<String, dynamic>;
        } else {
          courseData = data;
        }
      } else {
        throw Exception('Unexpected response format: ${data.runtimeType}');
      }
      
      return CourseResponse.fromJson(courseData);
    }

    // Try to parse error message from API response
    try {
      final errorData = jsonDecode(resp.body);
      final message = errorData['messageDTO']?['message'] ?? 
                     errorData['message'] ?? 
                     'Course not found';
      throw Exception(message);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load course: ${resp.statusCode}');
    }
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

    final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.coursesSearchEndpoint}')
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
    // Use /api/courses with pageSize and sort by createdAt desc
    final queryParams = {
      'pageNumber': '1',
      'pageSize': limit.toString(),
      'sortField': 'createdAt',
      'sortOrder': 'desc',
    };

    final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.coursesEndpoint}')
        .replace(queryParameters: queryParams);

    final resp = await _http.get(uri.toString());

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      
      // Handle PagingCourseResponse format
      if (data is Map) {
        // Check for result.data (common backend pattern)
        if (data['result'] != null && data['result']['data'] is List) {
          final list = data['result']['data'] as List;
          return list.map((item) => CourseResponse.fromJson(item)).toList();
        }
        // Check for direct data field
        if (data['data'] is List) {
          final list = data['data'] as List;
          return list.map((item) => CourseResponse.fromJson(item)).toList();
        }
        // Check for result as list
        if (data['result'] is List) {
          final list = data['result'] as List;
          return list.map((item) => CourseResponse.fromJson(item)).toList();
        }
      }
      
      // Handle direct list
      if (data is List) {
        return data.map((item) => CourseResponse.fromJson(item)).toList();
      }
    }

    throw Exception('Failed to load latest courses: ${resp.statusCode}');
  }

  /// Get featured courses
  Future<List<CourseResponse>> getFeaturedCourses() async {
    final queryParams = {
      'currentPage': 1,
      'pageSize': 100,
    };

    final resp = await _http.get(
      AppConstants.featuredCoursesEndpoint,
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
  Future<List<CourseResponse>> getUserCourses(String userId) async {
    final resp = await _http.get('${AppConstants.userCoursesEndpoint}/$userId');
    
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      
      // Direct list
      if (data is List) {
        return data.map((item) => CourseResponse.fromJson(item)).toList();
      }
      // ApiResponse with result as list
      if (data is Map && data['result'] is List) {
        return (data['result'] as List)
            .map((item) => CourseResponse.fromJson(item))
            .toList();
      }
      // ApiResponse with result as paging object containing data list
      if (data is Map && data['result'] is Map) {
        final result = data['result'] as Map;
        final dynamic innerData = result['data'];
        if (innerData is List) {
          return innerData
              .map((item) => CourseResponse.fromJson(item))
              .toList();
        }
      }
    }

    throw Exception('Failed to load user courses: ${resp.statusCode} ${resp.body}');
  }

  /// Get parts (sections) of a course
  /// @deprecated Parts are now returned nested in getCourseBySlug/getCourseById
  /// Use selectedCourse.parts instead
  Future<List<PartResponse>> getCourseParts(String courseId) async {
    // Return empty list to maintain compatibility with legacy code
    return [];
  }

  /// Get lessons of a part
  /// @deprecated Lessons are now returned nested in parts within Course response
  /// Use selectedCourse.parts[].lessons instead
  Future<List<LessonResponse>> getPartLessons(String partId) async {
    // Return empty list to maintain compatibility with legacy code
    return [];
  }

  /// Get lesson by ID
  Future<LessonResponse> getLessonById(String lessonId) async {
    final resp = await _http.get('${AppConstants.lessonDetailEndpoint}/$lessonId');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      return LessonResponse.fromJson(data);
    }

    throw Exception('Failed to load lesson: ${resp.statusCode} ${resp.body}');
  }

  /// Check enrollment status
  Future<bool> checkEnrollment(String courseId) async {
    // Backend expects path param: /api/user-courses/check-enrollment/{courseId}
    final url = '${AppConstants.checkEnrollmentEndpoint}/$courseId';
    final resp = await _http.get(url);

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

    final resp = await _http.post(AppConstants.enrollCourseEndpoint, body: body);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to enroll course: ${resp.statusCode} ${resp.body}');
    }
  }
}
