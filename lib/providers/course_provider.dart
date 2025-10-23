import 'package:flutter/foundation.dart';
import '../models/course_response.dart';
import '../services/course_service.dart';

/// Provider để quản lý state cho Course
class CourseProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();

  // State cho danh sách courses
  List<CourseResponse> _courses = [];
  bool _isLoadingCourses = false;
  String? _errorMessage;

  // State cho latest courses (Home screen)
  List<CourseResponse> _latestCourses = [];
  bool _isLoadingLatestCourses = false;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _pageSize = 10;
  bool _hasMore = true;

  // Selected course state
  CourseResponse? _selectedCourse;
  List<PartResponse> _courseParts = [];
  List<LessonResponse> _lessons = [];
  bool _isLoadingCourseDetail = false;

  // User courses state
  List<CourseResponse> _userCourses = [];
  bool _isLoadingUserCourses = false;

  // Search/Filter state
  String? _searchText;
  String? _selectedCategory;
  String? _selectedLevel;

  // Getters
  List<CourseResponse> get courses => _courses;
  bool get isLoadingCourses => _isLoadingCourses;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMore => _hasMore;
  
  // Latest courses getters (for Home screen)
  List<CourseResponse> get latestCourses => _latestCourses;
  bool get isLoadingLatestCourses => _isLoadingLatestCourses;
  
  CourseResponse? get selectedCourse => _selectedCourse;
  List<PartResponse> get courseParts => _courseParts;
  List<LessonResponse> get lessons => _lessons;
  bool get isLoadingCourseDetail => _isLoadingCourseDetail;
  
  List<CourseResponse> get userCourses => _userCourses;
  bool get isLoadingUserCourses => _isLoadingUserCourses;

  String? get searchText => _searchText;
  String? get selectedCategory => _selectedCategory;
  String? get selectedLevel => _selectedLevel;

  /// Fetch all courses
  Future<void> fetchCourses({
    int? pageNumber,
    int? pageSize,
    String sortField = 'createdAt',
    String sortOrder = 'desc',
    String? searchText,
  }) async {
    try {
      _isLoadingCourses = true;
      _errorMessage = null;
      notifyListeners();

      final page = pageNumber ?? _currentPage;
      final size = pageSize ?? _pageSize;

      final response = await _courseService.getAllCourses(
        pageNumber: page,
        pageSize: size,
        sortField: sortField,
        sortOrder: sortOrder,
        searchText: searchText,
      );

      _courses = response.data ?? [];
      _currentPage = response.currentPage ?? 1;
      _totalPages = response.totalPage ?? 1;
      _pageSize = response.pageSize ?? 10;
      _hasMore = _currentPage < _totalPages;
      _searchText = searchText;

      _isLoadingCourses = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingCourses = false;
      notifyListeners();
    }
  }

  /// Load more courses (for pagination)
  Future<void> loadMoreCourses() async {
    if (_isLoadingCourses || !_hasMore) return;

    try {
      _isLoadingCourses = true;
      notifyListeners();

      final nextPage = _currentPage + 1;
      final response = await _courseService.getAllCourses(
        pageNumber: nextPage,
        pageSize: _pageSize,
        searchText: _searchText,
      );

      if (response.data != null && response.data!.isNotEmpty) {
        _courses.addAll(response.data!);
        _currentPage = response.currentPage ?? nextPage;
        _totalPages = response.totalPage ?? _totalPages;
        _hasMore = _currentPage < _totalPages;
      } else {
        _hasMore = false;
      }

      _isLoadingCourses = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingCourses = false;
      notifyListeners();
    }
  }

  /// Refresh courses (reset to page 1)
  Future<void> refreshCourses() async {
    _currentPage = 1;
    _searchText = null;
    _selectedCategory = null;
    _selectedLevel = null;
    await fetchCourses(pageNumber: 1);
  }

  /// Search courses
  Future<void> searchCourses({
    String? title,
    String? category,
    String? level,
  }) async {
    try {
      _isLoadingCourses = true;
      _errorMessage = null;
      _selectedCategory = category;
      _selectedLevel = level;
      _currentPage = 1;
      notifyListeners();

      final response = await _courseService.searchCourses(
        pageNumber: 1,
        pageSize: _pageSize,
        title: title,
        category: category,
        level: level,
      );

      _courses = response.data ?? [];
      _currentPage = response.currentPage ?? 1;
      _totalPages = response.totalPage ?? 1;
      _hasMore = _currentPage < _totalPages;

      _isLoadingCourses = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingCourses = false;
      notifyListeners();
    }
  }

  /// Get course by slug
  Future<void> fetchCourseBySlug(String slugName) async {
    try {
      _isLoadingCourseDetail = true;
      _errorMessage = null;
      notifyListeners();

      _selectedCourse = await _courseService.getCourseBySlug(slugName);

      _isLoadingCourseDetail = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingCourseDetail = false;
      notifyListeners();
    }
  }

  /// Get course by ID
  Future<void> fetchCourseById(String courseId) async {
    try {
      _isLoadingCourseDetail = true;
      _errorMessage = null;
      notifyListeners();

      _selectedCourse = await _courseService.getCourseById(courseId);

      _isLoadingCourseDetail = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingCourseDetail = false;
      notifyListeners();
    }
  }

  /// Get latest courses
  Future<void> fetchLatestCourses({int limit = 10}) async {
    try {
      _isLoadingLatestCourses = true;
      _errorMessage = null;
      notifyListeners();

      // Try featured courses first (known to work)
      final allCourses = await _courseService.getFeaturedCourses();
      
      // Take only the requested limit and sort by createdAt
      allCourses.sort((a, b) {
        final aDate = a.createdAt ?? DateTime(2000);
        final bDate = b.createdAt ?? DateTime(2000);
        return bDate.compareTo(aDate); // Descending order (newest first)
      });
      
      _latestCourses = allCourses.take(limit).toList();

      _isLoadingLatestCourses = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingLatestCourses = false;
      notifyListeners();
    }
  }

  /// Get featured courses
  Future<void> fetchFeaturedCourses() async {
    try {
      _isLoadingCourses = true;
      _errorMessage = null;
      notifyListeners();

      _courses = await _courseService.getFeaturedCourses();
      
      // Featured courses don't have pagination, so disable load more
      _currentPage = 1;
      _totalPages = 1;
      _hasMore = false;

      _isLoadingCourses = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingCourses = false;
      notifyListeners();
    }
  }

  /// Get user courses
  Future<void> fetchUserCourses(String userId) async {
    try {
      _isLoadingUserCourses = true;
      _errorMessage = null;
      notifyListeners();

      _userCourses = await _courseService.getUserCourses(userId);

      _isLoadingUserCourses = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingUserCourses = false;
      notifyListeners();
    }
  }

  /// Get course parts
  Future<void> fetchCourseParts(String courseId) async {
    try {
      _errorMessage = null;
      notifyListeners();

      _courseParts = await _courseService.getCourseParts(courseId);

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Get part lessons
  Future<void> fetchPartLessons(String partId) async {
    try {
      _errorMessage = null;
      notifyListeners();

      _lessons = await _courseService.getPartLessons(partId);

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Get lesson by ID
  Future<LessonResponse?> fetchLessonById(String lessonId) async {
    try {
      _errorMessage = null;
      final lesson = await _courseService.getLessonById(lessonId);
      return lesson;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Check enrollment
  Future<bool> checkEnrollment(String courseId) async {
    try {
      return await _courseService.checkEnrollment(courseId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Enroll in course
  Future<void> enrollCourse(String courseId) async {
    try {
      _errorMessage = null;
      await _courseService.enrollCourse(courseId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset selected course
  void clearSelectedCourse() {
    _selectedCourse = null;
    _courseParts = [];
    _lessons = [];
    notifyListeners();
  }
}
