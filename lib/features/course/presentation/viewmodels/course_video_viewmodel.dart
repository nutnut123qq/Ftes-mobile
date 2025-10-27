import 'package:flutter/foundation.dart';
import '../../domain/entities/video_playlist.dart';
import '../../domain/entities/video_status.dart';
import '../../domain/usecases/check_enrollment_usecase.dart';
import '../../domain/usecases/get_video_playlist_usecase.dart';
import '../../domain/usecases/get_video_status_usecase.dart';
import '../../domain/constants/video_constants.dart';

/// ViewModel for Course Video Player feature
class CourseVideoViewModel extends ChangeNotifier {
  final CheckEnrollmentUseCase _checkEnrollmentUseCase;
  final GetVideoPlaylistUseCase _getVideoPlaylistUseCase;
  final GetVideoStatusUseCase _getVideoStatusUseCase;

  CourseVideoViewModel({
    required CheckEnrollmentUseCase checkEnrollmentUseCase,
    required GetVideoPlaylistUseCase getVideoPlaylistUseCase,
    required GetVideoStatusUseCase getVideoStatusUseCase,
  }) : _checkEnrollmentUseCase = checkEnrollmentUseCase,
       _getVideoPlaylistUseCase = getVideoPlaylistUseCase,
       _getVideoStatusUseCase = getVideoStatusUseCase;

  VideoPlaylist? _videoPlaylist;
  VideoStatus? _videoStatus;
  bool? _isEnrolled;
  bool _isLoading = false;
  bool _isCheckingEnrollment = false;
  String? _errorMessage;
  String? _videoType;

  // Getters
  VideoPlaylist? get videoPlaylist => _videoPlaylist;
  VideoStatus? get videoStatus => _videoStatus;
  bool? get isEnrolled => _isEnrolled;
  bool get isLoading => _isLoading;
  bool get isCheckingEnrollment => _isCheckingEnrollment;
  String? get errorMessage => _errorMessage;
  String? get videoType => _videoType;

  /// Check enrollment and load video
  Future<bool> checkEnrollmentAndLoadVideo(String userId, String courseId, String videoId) async {
    _setCheckingEnrollment(true);
    _clearError();

    // First check enrollment
    final enrollmentParams = CheckEnrollmentParams(userId: userId, courseId: courseId);
    final enrollmentResult = await _checkEnrollmentUseCase(enrollmentParams);

    return enrollmentResult.fold(
      (failure) {
        _setError(failure.message);
        _setCheckingEnrollment(false);
        return false;
      },
      (isEnrolled) async {
        if (!isEnrolled) {
          _setError(VideoConstants.errorNotEnrolled);
          _setCheckingEnrollment(false);
          return false;
        }

        _setEnrollmentStatus(true);

        // Determine video type based on video field
        _videoType = getVideoTypeFromField(videoId);
        
        print('🎬 Video type detected: $_videoType for video: $videoId');
        
        _setCheckingEnrollment(false);
        return true;
      },
    );
  }

  /// Load video playlist for HLS
  Future<void> loadVideoPlaylist(String videoId) async {
    _setLoading(true);
    _clearError();

    final params = GetVideoPlaylistParams(videoId: videoId, presign: true);
    final result = await _getVideoPlaylistUseCase(params);

    result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
      },
      (playlist) {
        _videoPlaylist = playlist;
        _setLoading(false);
      },
    );
  }

  /// Check video status
  Future<void> checkVideoStatus(String videoId) async {
    final params = GetVideoStatusParams(videoId: videoId);
    final result = await _getVideoStatusUseCase(params);

    result.fold(
      (failure) {
        print('❌ Failed to check video status: ${failure.message}');
      },
      (status) {
        _videoStatus = status;
        notifyListeners();
      },
    );
  }

  /// Check if URL is YouTube
  bool isYouTubeUrl(String url) {
    final youtubeRegex = RegExp(r'(?:youtube\.com/(?:watch\?v=|embed/|v/|shorts/)|youtu\.be/)([a-zA-Z0-9_-]{11})');
    return youtubeRegex.hasMatch(url);
  }

  /// Extract YouTube video ID from URL
  String? extractYouTubeId(String url) {
    final youtubeRegex = RegExp(r'(?:youtube\.com/(?:watch\?v=|embed/|v/|shorts/)|youtu\.be/)([a-zA-Z0-9_-]{11})');
    final match = youtubeRegex.firstMatch(url);
    return match?.group(1);
  }

  /// Check if URL is Vimeo
  bool isVimeoUrl(String url) {
    final vimeoRegex = RegExp(r'(?:vimeo\.com/)(\d+)');
    return vimeoRegex.hasMatch(url);
  }

  /// Extract Vimeo video ID from URL
  String? extractVimeoId(String url) {
    final vimeoRegex = RegExp(r'(?:vimeo\.com/)(\d+)');
    final match = vimeoRegex.firstMatch(url);
    return match?.group(1);
  }

  /// Get video type: internal, youtube, vimeo, external
  String getVideoTypeFromField(String videoField) {
    if (videoField.startsWith('http://') || videoField.startsWith('https://')) {
      if (isYouTubeUrl(videoField)) return VideoConstants.videoTypeYoutube;
      if (isVimeoUrl(videoField)) return 'vimeo';
      return 'external';
    }
    // If not a URL, it's an internal video ID
    return VideoConstants.videoTypeHls;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCheckingEnrollment(bool checking) {
    _isCheckingEnrollment = checking;
    notifyListeners();
  }

  void _setEnrollmentStatus(bool isEnrolled) {
    _isEnrolled = isEnrolled;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all data
  void clear() {
    _videoPlaylist = null;
    _videoStatus = null;
    _isEnrolled = null;
    _isLoading = false;
    _isCheckingEnrollment = false;
    _errorMessage = null;
    _videoType = null;
    notifyListeners();
  }
}

