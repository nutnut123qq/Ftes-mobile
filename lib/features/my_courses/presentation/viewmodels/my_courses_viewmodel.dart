import 'package:flutter/foundation.dart';
import '../../domain/entities/my_course.dart';
import '../../domain/usecases/get_user_courses_usecase.dart';

/// ViewModel for My Courses feature
class MyCoursesViewModel extends ChangeNotifier {
  final GetUserCoursesUseCase _getUserCoursesUseCase;

  MyCoursesViewModel({
    required GetUserCoursesUseCase getUserCoursesUseCase,
  }) : _getUserCoursesUseCase = getUserCoursesUseCase;

  List<MyCourse> _myCourses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<MyCourse> get myCourses => _myCourses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch user's enrolled courses
  Future<void> fetchUserCourses(String userId) async {
    _setLoading(true);
    _clearError();

    final result = await _getUserCoursesUseCase(userId);
    result.fold(
      (failure) => _setError(failure.message),
      (courses) => _setCourses(courses),
    );

    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setCourses(List<MyCourse> courses) {
    _myCourses = courses;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all data
  void clear() {
    _myCourses = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
