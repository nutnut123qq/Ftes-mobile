import 'package:flutter/foundation.dart';
import '../../domain/entities/my_course.dart';
import '../../domain/usecases/get_user_courses_usecase.dart';
import '../../domain/constants/my_courses_constants.dart';

/// ViewModel for My Courses feature
class MyCoursesViewModel extends ChangeNotifier {
  final GetUserCoursesUseCase _getUserCoursesUseCase;

  MyCoursesViewModel({
    required GetUserCoursesUseCase getUserCoursesUseCase,
  }) : _getUserCoursesUseCase = getUserCoursesUseCase;

  List<MyCourse> _allCourses = []; // Store all courses
  List<MyCourse> _filteredCourses = []; // Store filtered courses for search
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<MyCourse> get myCourses => _searchQuery.isEmpty ? _allCourses : _filteredCourses;
  List<MyCourse> get allCourses => _allCourses;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasSearchResults => _filteredCourses.isNotEmpty;

  /// Fetch user's enrolled courses - optimized with batch updates
  Future<void> fetchUserCourses(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    final result = await _getUserCoursesUseCase(userId);
    
    if (result.isLeft()) {
      _errorMessage = result.fold((l) => l.message, (r) => '');
    } else {
      final courses = result.fold((l) => <MyCourse>[], (r) => r);
      _allCourses = courses;
      // If there's an active search, reapply it
      if (_searchQuery.isNotEmpty) {
        await _performSearch(_searchQuery);
      }
    }

    _isLoading = false;
    notifyListeners(); // Only once at end
  }

  /// Search courses by title, description, or instructor
  Future<void> searchCourses(String query) async {
    _searchQuery = query.trim();
    
    if (_searchQuery.isEmpty) {
      // Show all courses when search is empty
      _filteredCourses = [];
      notifyListeners();
      return;
    }

    await _performSearch(_searchQuery);
    notifyListeners();
  }

  /// Internal method to perform search without notifying
  /// Uses compute isolate for large lists to avoid blocking main thread
  Future<void> _performSearch(String query) async {
    final lowerQuery = query.toLowerCase();
    
    // Use compute isolate for large lists
    if (_allCourses.length > MyCoursesConstants.searchThreshold) {
      // Convert MyCourse to Map for serialization (in isolate if needed)
      final coursesMap = await compute(_convertCoursesToMap, _allCourses);
      
      final filteredMap = await compute(_searchInIsolate, {
        'courses': coursesMap,
        'query': lowerQuery,
      });
      
      // Convert Map back to MyCourse (in isolate if needed)
      _filteredCourses = await compute(_convertMapToCourses, filteredMap);
    } else {
      // For smaller lists, search on main thread
      _filteredCourses = _searchSync(_allCourses, lowerQuery);
    }
  }

  /// Synchronous search for small lists
  List<MyCourse> _searchSync(List<MyCourse> courses, String lowerQuery) {
    return courses.where((course) {
      // Search in title
      final titleMatch = course.title?.toLowerCase().contains(lowerQuery) ?? false;
      
      // Search in description
      final descriptionMatch = course.description?.toLowerCase().contains(lowerQuery) ?? false;
      
      // Search in instructor name
      final instructorMatch = course.instructor?.toLowerCase().contains(lowerQuery) ?? false;
      
      return titleMatch || descriptionMatch || instructorMatch;
    }).toList();
  }

  /// Clear search and show all courses
  void clearSearch() {
    _searchQuery = '';
    _filteredCourses = [];
    notifyListeners();
  }

  /// Clear all data
  void clear() {
    _allCourses = [];
    _filteredCourses = [];
    _searchQuery = '';
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}

/// Top-level function for converting courses to Map in isolate
List<Map<String, dynamic>> _convertCoursesToMap(List<MyCourse> courses) {
  return courses.map((course) => {
    'id': course.id,
    'title': course.title,
    'description': course.description,
    'instructor': course.instructor,
    'imageHeader': course.imageHeader,
    'slugName': course.slugName,
    'purchaseDate': course.purchaseDate,
    'courses': course.courses?.map((c) => {'courseId': c.courseId}).toList(),
  }).toList();
}

/// Top-level function for searching courses in compute isolate
List<Map<String, dynamic>> _searchInIsolate(Map<String, dynamic> params) {
  final courses = params['courses'] as List<dynamic>;
  final query = params['query'] as String;
  
  return courses.where((courseMap) {
    final course = courseMap as Map<String, dynamic>;
    
    // Search in title
    final title = course['title'] as String?;
    final titleMatch = title?.toLowerCase().contains(query) ?? false;
    
    // Search in description
    final description = course['description'] as String?;
    final descriptionMatch = description?.toLowerCase().contains(query) ?? false;
    
    // Search in instructor name
    final instructor = course['instructor'] as String?;
    final instructorMatch = instructor?.toLowerCase().contains(query) ?? false;
    
    return titleMatch || descriptionMatch || instructorMatch;
  }).cast<Map<String, dynamic>>().toList();
}

/// Top-level function for converting Map back to MyCourse in isolate
List<MyCourse> _convertMapToCourses(List<Map<String, dynamic>> coursesMap) {
  return coursesMap.map((map) => MyCourse(
    id: map['id'] as String?,
    title: map['title'] as String?,
    description: map['description'] as String?,
    instructor: map['instructor'] as String?,
    imageHeader: map['imageHeader'] as String?,
    slugName: map['slugName'] as String?,
    purchaseDate: map['purchaseDate'] as String?,
    courses: (map['courses'] as List<dynamic>?)?.map((c) => CourseReference(
      courseId: c['courseId'] as String?,
    )).toList(),
  )).toList();
}
