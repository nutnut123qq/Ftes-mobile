import 'package:flutter/foundation.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_course_detail_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/check_enrollment_usecase.dart';

/// ViewModel for Course Detail feature
class CourseDetailViewModel extends ChangeNotifier {
  final GetCourseDetailUseCase _getCourseDetailUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final CheckEnrollmentUseCase _checkEnrollmentUseCase;

  CourseDetailViewModel({
    required GetCourseDetailUseCase getCourseDetailUseCase,
    required GetProfileUseCase getProfileUseCase,
    required CheckEnrollmentUseCase checkEnrollmentUseCase,
  }) : _getCourseDetailUseCase = getCourseDetailUseCase,
       _getProfileUseCase = getProfileUseCase,
       _checkEnrollmentUseCase = checkEnrollmentUseCase;

  CourseDetail? _courseDetail;
  Profile? _mentorProfile;
  bool? _isEnrolled;
  bool _isLoading = false;
  bool _isLoadingProfile = false;
  bool _isCheckingEnrollment = false;
  String? _errorMessage;

  // Getters
  CourseDetail? get courseDetail => _courseDetail;
  Profile? get mentorProfile => _mentorProfile;
  bool? get isEnrolled => _isEnrolled;
  bool get isLoading => _isLoading;
  bool get isLoadingProfile => _isLoadingProfile;
  bool get isCheckingEnrollment => _isCheckingEnrollment;
  String? get errorMessage => _errorMessage;

  /// Fetch course detail by slug
  Future<void> fetchCourseDetailBySlug(String slugName, String? userId) async {
    _setLoading(true);
    _clearError();

    final params = CourseDetailParams(slugName: slugName, userId: userId);
    final result = await _getCourseDetailUseCase(params);
    
    result.fold(
      (failure) => _setError(failure.message),
      (courseDetail) {
        _setCourseDetail(courseDetail);
        // Fetch mentor profile and check enrollment after course detail is loaded
        if (userId != null && userId.isNotEmpty) {
          fetchMentorProfile(courseDetail.userId);
          checkEnrollment(userId, courseDetail.id);
        }
      },
    );

    _setLoading(false);
  }

  /// Fetch mentor profile by userId
  Future<void> fetchMentorProfile(String userId) async {
    _setLoadingProfile(true);

    final params = GetProfileParams(userId: userId);
    final result = await _getProfileUseCase(params);
    
    result.fold(
      (failure) {
        print('❌ Failed to fetch mentor profile: ${failure.message}');
        _setLoadingProfile(false);
      },
      (profile) {
        _setMentorProfile(profile);
        _setLoadingProfile(false);
      },
    );
  }

  /// Check enrollment status
  Future<void> checkEnrollment(String userId, String courseId) async {
    _setCheckingEnrollment(true);

    final params = CheckEnrollmentParams(userId: userId, courseId: courseId);
    final result = await _checkEnrollmentUseCase(params);
    
    result.fold(
      (failure) {
        print('❌ Failed to check enrollment: ${failure.message}');
        _setEnrollmentStatus(null);
        _setCheckingEnrollment(false);
      },
      (isEnrolled) {
        _setEnrollmentStatus(isEnrolled);
        _setCheckingEnrollment(false);
      },
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingProfile(bool loading) {
    _isLoadingProfile = loading;
    notifyListeners();
  }

  void _setCheckingEnrollment(bool checking) {
    _isCheckingEnrollment = checking;
    notifyListeners();
  }

  void _setMentorProfile(Profile profile) {
    _mentorProfile = profile;
    notifyListeners();
  }

  void _setEnrollmentStatus(bool? isEnrolled) {
    _isEnrolled = isEnrolled;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setCourseDetail(CourseDetail courseDetail) {
    _courseDetail = courseDetail;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all data
  void clear() {
    _courseDetail = null;
    _mentorProfile = null;
    _isEnrolled = null;
    _isLoading = false;
    _isLoadingProfile = false;
    _isCheckingEnrollment = false;
    _errorMessage = null;
    notifyListeners();
  }
}
