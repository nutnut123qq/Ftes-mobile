import 'package:flutter/foundation.dart';
import '../services/video_service.dart';
import 'dart:async';

// Export VideoPlaylistResponse for consumers
export '../services/video_service.dart' show VideoPlaylistResponse, VideoStatus;

/// Video Provider - Manages video state and streaming
class VideoProvider with ChangeNotifier {
  final VideoService _videoService = VideoService();

  // Video status tracking
  final Map<String, VideoStatus> _videoStatuses = {};
  VideoStatus? _currentVideoStatus;
  
  VideoStatus? get currentVideoStatus => _currentVideoStatus;
  
  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  // Error state
  String? _error;
  String? get error => _error;
  
  // Stream subscription
  StreamSubscription<VideoStatus>? _statusSubscription;

  /// Get video status
  VideoStatus? getVideoStatus(String videoId) {
    return _videoStatuses[videoId];
  }

  /// Fetch video status once
  Future<VideoStatus?> fetchVideoStatus(String videoId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final status = await _videoService.getVideoStatus(videoId);
      _videoStatuses[videoId] = status;
      _currentVideoStatus = status;
      
      _isLoading = false;
      notifyListeners();
      
      return status;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Monitor video status continuously
  /// Updates every 2 seconds until ready or error
  void monitorVideoStatus(String videoId, {Function(VideoStatus)? onUpdate}) {
    // Cancel existing subscription
    _statusSubscription?.cancel();
    
    _statusSubscription = _videoService.monitorVideoStatus(videoId).listen(
      (status) {
        _videoStatuses[videoId] = status;
        _currentVideoStatus = status;
        notifyListeners();
        
        // Call callback if provided
        onUpdate?.call(status);
        
        // Log status for debugging
        debugPrint('Video $videoId status: ${status.status} (${status.getProgressPercentage()}%)');
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
        debugPrint('Error monitoring video status: $error');
      },
      onDone: () {
        debugPrint('Video monitoring completed for $videoId');
      },
    );
  }

  /// Stop monitoring video status
  void stopMonitoring() {
    _statusSubscription?.cancel();
    _statusSubscription = null;
  }

  /// Get video playlist (preferred method - calls API to get URLs)
  Future<VideoPlaylistResponse?> fetchVideoPlaylist(String videoId, {bool presign = true}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final playlist = await _videoService.getVideoPlaylist(videoId, presign: presign);
      
      _isLoading = false;
      notifyListeners();
      
      return playlist;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Get HLS playlist URL for video (fallback - prefer using fetchVideoPlaylist)
  String getPlaylistUrl(String videoId) {
    return _videoService.getPlaylistUrl(videoId);
  }

  /// Check if video is ready to play
  bool isVideoReady(String videoId) {
    final status = _videoStatuses[videoId];
    return status?.isReady ?? false;
  }

  /// Check if video is processing
  bool isVideoProcessing(String videoId) {
    final status = _videoStatuses[videoId];
    return status?.isProcessing ?? false;
  }

  /// Check if video has error
  bool hasVideoError(String videoId) {
    final status = _videoStatuses[videoId];
    return status?.hasError ?? false;
  }

  /// Get progress percentage
  int getVideoProgress(String videoId) {
    final status = _videoStatuses[videoId];
    return status?.getProgressPercentage() ?? 0;
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear video status
  void clearVideoStatus(String videoId) {
    _videoStatuses.remove(videoId);
    if (_currentVideoStatus?.videoId == videoId) {
      _currentVideoStatus = null;
    }
    notifyListeners();
  }

  /// Health check
  Future<bool> checkHealth() async {
    try {
      return await _videoService.healthCheck();
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }
}
