import 'package:flutter/foundation.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_course_detail_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/check_enrollment_usecase.dart';
import '../../domain/usecases/get_video_playlist_usecase.dart';

/// ViewModel for Course Detail feature
class CourseDetailViewModel extends ChangeNotifier {
  final GetCourseDetailUseCase _getCourseDetailUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final CheckEnrollmentUseCase _checkEnrollmentUseCase;
  final GetVideoPlaylistUseCase _getVideoPlaylistUseCase;

  CourseDetailViewModel({
    required GetCourseDetailUseCase getCourseDetailUseCase,
    required GetProfileUseCase getProfileUseCase,
    required CheckEnrollmentUseCase checkEnrollmentUseCase,
    required GetVideoPlaylistUseCase getVideoPlaylistUseCase,
  }) : _getCourseDetailUseCase = getCourseDetailUseCase,
       _getProfileUseCase = getProfileUseCase,
       _checkEnrollmentUseCase = checkEnrollmentUseCase,
       _getVideoPlaylistUseCase = getVideoPlaylistUseCase;

  CourseDetail? _courseDetail;
  Profile? _mentorProfile;
  bool? _isEnrolled;
  bool _isLoading = false;
  bool _isLoadingProfile = false;
  bool _isCheckingEnrollment = false;
  String? _errorMessage;
  DateTime? _lastInitializeAt;
  String? _lastSlug;
  final Set<String> _prefetchedVideoIds = {};

  // Getters
  CourseDetail? get courseDetail => _courseDetail;
  Profile? get mentorProfile => _mentorProfile;
  bool? get isEnrolled => _isEnrolled;
  bool get isLoading => _isLoading;
  bool get isLoadingProfile => _isLoadingProfile;
  bool get isCheckingEnrollment => _isCheckingEnrollment;
  String? get errorMessage => _errorMessage;

  /// Initialize - fetch all data with optimized batch updates
  /// Minimizes notifyListeners() calls for better performance
  Future<void> initialize(String slugName, String? userId) async {
    // Debounce rapid initialize calls for the same slug
    final now = DateTime.now();
    if (_lastSlug == slugName && _lastInitializeAt != null &&
        now.difference(_lastInitializeAt!).inMilliseconds < 300) {
      return;
    }
    _lastSlug = slugName;
    _lastInitializeAt = now;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Only once at start

    // Fetch course detail first
    await _fetchCourseDetailInternal(slugName, userId);

    // Then fetch mentor profile and check enrollment in parallel if course loaded
    if (_courseDetail != null && userId != null && userId.isNotEmpty) {
      await Future.wait([
        _fetchMentorProfileInternal(_courseDetail!.userId),
        _checkEnrollmentInternal(userId, _courseDetail!.id),
      ]);
    }

    // Prefetch first video playlist to warm cache (non-blocking)
    _prefetchFirstVideo();

    _isLoading = false;
    notifyListeners(); // Only once at end
  }

  /// Internal method to fetch course detail without notifying listeners
  Future<void> _fetchCourseDetailInternal(String slugName, String? userId) async {
    final params = CourseDetailParams(slugName: slugName, userId: userId);
    final result = await _getCourseDetailUseCase(params);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (courseDetail) {
        _courseDetail = courseDetail;
      },
    );
  }

  void _prefetchFirstVideo() {
    final course = _courseDetail;
    if (course == null) return;
    if (course.parts.isEmpty) return;
    final firstPart = course.parts.first;
    if (firstPart.lessons.isEmpty) return;
    final firstVideoLesson = firstPart.lessons.firstWhere(
      (l) => (l.type == null || l.type == 'VIDEO') && l.video.isNotEmpty,
      orElse: () => firstPart.lessons.first,
    );
    final videoId = firstVideoLesson.video;
    if (videoId.isEmpty || _prefetchedVideoIds.contains(videoId)) return;
    _prefetchedVideoIds.add(videoId);
    // Fire-and-forget; presign=false to allow caching
    _getVideoPlaylistUseCase(GetVideoPlaylistParams(videoId: videoId, presign: false));
  }

  /// Internal method to fetch mentor profile without notifying listeners
  Future<void> _fetchMentorProfileInternal(String userId) async {
    _isLoadingProfile = true;

    final params = GetProfileParams(userId: userId);
    final result = await _getProfileUseCase(params);

    result.fold(
      (failure) {
        debugPrint('❌ Failed to fetch mentor profile: ${failure.message}');
        _isLoadingProfile = false;
      },
      (profile) {
        _mentorProfile = profile;
        _isLoadingProfile = false;
      },
    );
  }

  /// Internal method to check enrollment without notifying listeners
  Future<void> _checkEnrollmentInternal(String userId, String courseId) async {
    _isCheckingEnrollment = true;

    final params = CheckEnrollmentParams(userId: userId, courseId: courseId);
    final result = await _checkEnrollmentUseCase(params);

    result.fold(
      (failure) {
        debugPrint('❌ Failed to check enrollment: ${failure.message}');
        _isEnrolled = null;
        _isCheckingEnrollment = false;
      },
      (isEnrolled) {
        _isEnrolled = isEnrolled;
        _isCheckingEnrollment = false;
      },
    );
  }

  /// Public method - Fetch course detail by slug (legacy support)
  /// Use initialize() for better performance
  Future<void> fetchCourseDetailBySlug(String slugName, String? userId) async {
    _setLoading(true);
    _clearError();

    await _fetchCourseDetailInternal(slugName, userId);

    // Fetch mentor profile and check enrollment after course detail is loaded
    if (_courseDetail != null && userId != null && userId.isNotEmpty) {
      await Future.wait([
        _fetchMentorProfileInternal(_courseDetail!.userId),
        _checkEnrollmentInternal(userId, _courseDetail!.id),
      ]);
    }

    _setLoading(false);
  }

  /// Public method - Fetch mentor profile by userId (legacy support)
  Future<void> fetchMentorProfile(String userId) async {
    _setLoadingProfile(true);
    await _fetchMentorProfileInternal(userId);
    _setLoadingProfile(false);
  }

  /// Public method - Check enrollment status (legacy support)
  Future<void> checkEnrollment(String userId, String courseId) async {
    _setCheckingEnrollment(true);
    await _checkEnrollmentInternal(userId, courseId);
    _setCheckingEnrollment(false);
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

  void _clearError() {
    _errorMessage = null;
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
