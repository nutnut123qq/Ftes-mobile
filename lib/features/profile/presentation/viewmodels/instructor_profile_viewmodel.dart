import 'package:flutter/foundation.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/instructor_course.dart';
import '../../domain/usecases/get_instructor_profile_usecase.dart';
import '../../domain/usecases/get_instructor_courses_usecase.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../../../../core/error/failures.dart';

/// ViewModel for Instructor Profile operations
/// Optimized with parallel API calls and minimal notifyListeners
class InstructorProfileViewModel extends ChangeNotifier {
  final GetInstructorProfileByUsernameUseCase _getInstructorProfileUseCase;
  final GetInstructorCoursesUseCase _getInstructorCoursesUseCase;
  final GetParticipantsCountUseCase _getParticipantsCountUseCase;

  InstructorProfileViewModel({
    required GetInstructorProfileByUsernameUseCase getInstructorProfileUseCase,
    required GetInstructorCoursesUseCase getInstructorCoursesUseCase,
    required GetParticipantsCountUseCase getParticipantsCountUseCase,
  })  : _getInstructorProfileUseCase = getInstructorProfileUseCase,
        _getInstructorCoursesUseCase = getInstructorCoursesUseCase,
        _getParticipantsCountUseCase = getParticipantsCountUseCase;

  // State variables
  Profile? _profile;
  List<InstructorCourse> _courses = [];
  int _participantsCount = 0;
  bool _isLoading = false;
  bool _isLoadingCourses = false;
  bool _isLoadingStats = false;
  String? _errorMessage;

  // Getters
  Profile? get profile => _profile;
  List<InstructorCourse> get courses => _courses;
  int get participantsCount => _participantsCount;
  bool get isLoading => _isLoading;
  bool get isLoadingCourses => _isLoadingCourses;
  bool get isLoadingStats => _isLoadingStats;
  String? get errorMessage => _errorMessage;
  bool get hasCourses => _courses.isNotEmpty;

  /// Initialize instructor profile with parallel loading
  /// Minimizes notifyListeners calls for better performance
  Future<void> initialize(String username) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    try {
      // First load profile
      await _loadProfileInternal(username);
      
      // Then load courses and stats in parallel if profile loaded
      if (_profile != null) {
        await Future.wait([
          _loadCoursesInternal(_profile!.userId),
          _loadParticipantsInternal(_profile!.userId),
        ]);
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners(); // Only once at end
  }

  /// Internal method to load profile without notifying listeners
  Future<void> _loadProfileInternal(String username) async {
    final result = await _getInstructorProfileUseCase(username);
    result.fold(
      (failure) => throw Exception(_mapFailureToMessage(failure)),
      (profile) => _profile = profile,
    );
  }

  /// Internal method to load courses without notifying listeners
  Future<void> _loadCoursesInternal(String userId) async {
    _isLoadingCourses = true;

    final result = await _getInstructorCoursesUseCase(userId);
    result.fold(
      (failure) {
        _courses = [];
        _isLoadingCourses = false;
      },
      (courses) {
        _courses = courses;
        _isLoadingCourses = false;
      },
    );
  }

  /// Internal method to load participants count without notifying listeners
  Future<void> _loadParticipantsInternal(String instructorId) async {
    _isLoadingStats = true;

    final result = await _getParticipantsCountUseCase(instructorId);
    result.fold(
      (failure) {
        _participantsCount = 0;
        _isLoadingStats = false;
      },
      (count) {
        _participantsCount = count;
        _isLoadingStats = false;
      },
    );
  }

  /// Refresh instructor profile data
  Future<void> refresh(String username) async {
    await initialize(username);
  }

  /// Clear all data
  void clear() {
    _profile = null;
    _courses = [];
    _participantsCount = 0;
    _isLoading = false;
    _isLoadingCourses = false;
    _isLoadingStats = false;
    _errorMessage = null;
    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else {
      return 'An unexpected error occurred';
    }
  }
}
