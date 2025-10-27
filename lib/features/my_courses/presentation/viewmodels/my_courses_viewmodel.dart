import 'package:flutter/foundation.dart';
import '../../domain/entities/my_course.dart';
import '../../domain/usecases/get_user_courses_usecase.dart';

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
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (courses) {
        _allCourses = courses;
        // If there's an active search, reapply it
        if (_searchQuery.isNotEmpty) {
          _performSearch(_searchQuery);
        }
      },
    );

    _isLoading = false;
    notifyListeners(); // Only once at end
  }

  /// Search courses by title, description, or instructor
  void searchCourses(String query) {
    _searchQuery = query.trim();
    
    if (_searchQuery.isEmpty) {
      // Show all courses when search is empty
      _filteredCourses = [];
      notifyListeners();
      return;
    }

    _performSearch(_searchQuery);
    notifyListeners();
  }

  /// Internal method to perform search without notifying
  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();
    
    _filteredCourses = _allCourses.where((course) {
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
