import 'package:flutter/foundation.dart';
import '../models/course_response.dart';

/// Temporary CourseProvider for backward compatibility
/// TODO: Migrate to Clean Architecture
class CourseProvider extends ChangeNotifier {
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
  bool _isLoadingCourseDetail = false;

  // User courses state
  List<CourseResponse> _userCourses = [];
  bool _isLoadingUserCourses = false;

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
  bool get isLoadingCourseDetail => _isLoadingCourseDetail;
  
  List<CourseResponse> get userCourses => _userCourses;
  bool get isLoadingUserCourses => _isLoadingUserCourses;

  /// Fetch latest courses - placeholder
  Future<void> fetchLatestCourses({int limit = 10}) async {
    _isLoadingLatestCourses = true;
    notifyListeners();
    
    // TODO: Implement with new Clean Architecture
    await Future.delayed(const Duration(seconds: 1));
    
    _latestCourses = [];
    _isLoadingLatestCourses = false;
    notifyListeners();
  }

  /// Fetch featured courses - placeholder
  Future<void> fetchFeaturedCourses() async {
    _isLoadingCourses = true;
    notifyListeners();
    
    // TODO: Implement with new Clean Architecture
    await Future.delayed(const Duration(seconds: 1));
    
    _courses = [];
    _isLoadingCourses = false;
    notifyListeners();
  }

  /// Get course by ID - placeholder
  Future<void> fetchCourseById(String courseId) async {
    _isLoadingCourseDetail = true;
    notifyListeners();
    
    // TODO: Implement with new Clean Architecture
    await Future.delayed(const Duration(seconds: 1));
    
    _selectedCourse = null;
    _isLoadingCourseDetail = false;
    notifyListeners();
  }

  /// Get user courses - placeholder
  Future<void> fetchUserCourses(String userId) async {
    _isLoadingUserCourses = true;
    notifyListeners();
    
    // TODO: Implement with new Clean Architecture
    await Future.delayed(const Duration(seconds: 1));
    
    _userCourses = [];
    _isLoadingUserCourses = false;
    notifyListeners();
  }

  /// Get course by slug - placeholder
  Future<void> fetchCourseBySlug(String slugName) async {
    _isLoadingCourseDetail = true;
    notifyListeners();
    
    // TODO: Implement with new Clean Architecture
    await Future.delayed(const Duration(seconds: 1));
    
    _selectedCourse = null;
    _isLoadingCourseDetail = false;
    notifyListeners();
  }

  /// Get lesson by ID - placeholder
  Future<dynamic> fetchLessonById(String lessonId) async {
    // TODO: Implement with new Clean Architecture
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }

  /// Load more courses - placeholder
  Future<void> loadMoreCourses() async {
    // TODO: Implement with new Clean Architecture
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Search courses - placeholder
  Future<void> searchCourses({
    String? title,
    String? category,
    String? level,
  }) async {
    _isLoadingCourses = true;
    notifyListeners();
    
    // TODO: Implement with new Clean Architecture
    await Future.delayed(const Duration(seconds: 1));
    
    _courses = [];
    _isLoadingCourses = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset selected course
  void clearSelectedCourse() {
    _selectedCourse = null;
    notifyListeners();
  }
}
