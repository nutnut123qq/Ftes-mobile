import 'package:flutter/foundation.dart';

/// Video-related constants and utilities
class VideoConstants {
  // Video type detection patterns
  static const List<String> youtubePatterns = [
    'youtube.com/watch',
    'youtu.be/',
    'youtube.com/embed/',
    'youtube.com/v/',
  ];
  
  static const List<String> vimeoPatterns = [
    'vimeo.com/',
    'player.vimeo.com/',
  ];
  
  // Video types
  static const String videoTypeYouTube = 'youtube';
  static const String videoTypeYoutube = 'youtube'; // Alias for compatibility
  static const String videoTypeVimeo = 'vimeo';
  static const String videoTypeInternal = 'internal';
  static const String videoTypeHls = 'hls'; // HLS streaming video
  static const String videoTypeExternal = 'external'; // External video URL
  static const String videoTypeUnknown = 'unknown';
  
  // Error messages
  static const String errorNotEnrolled = 'Bạn chưa đăng ký khóa học này';
  static const String errorApiNotImplemented = 'API chưa được triển khai';
  static const String errorVideoLoadFailed = 'Không thể tải video';
  
  // Dialog messages
  static const String notEnrolledTitle = 'Chưa đăng ký';
  static const String notEnrolledMessage = 'Bạn cần đăng ký khóa học này để xem video';
  
  /// Detect video type from URL or ID
  static String detectVideoType(String videoUrl) {
    if (videoUrl.isEmpty) {
      return videoTypeUnknown;
    }
    
    // Check if it's a full URL (starts with http/https)
    if (videoUrl.startsWith('http://') || videoUrl.startsWith('https://')) {
      // Check YouTube patterns
      for (final pattern in youtubePatterns) {
        if (videoUrl.contains(pattern)) {
          return videoTypeYouTube;
        }
      }
      
      // Check Vimeo patterns
      for (final pattern in vimeoPatterns) {
        if (videoUrl.contains(pattern)) {
          return videoTypeVimeo;
        }
      }
      
      return videoTypeUnknown;
    }
    
    // If not a URL, assume it's an internal video ID
    return videoTypeInternal;
  }
  
  /// Extract YouTube video ID from URL
  static String? extractYouTubeId(String url) {
    if (url.isEmpty) return null;
    
    try {
      // Pattern 1: https://www.youtube.com/watch?v=VIDEO_ID
      if (url.contains('youtube.com/watch')) {
        final uri = Uri.parse(url);
        return uri.queryParameters['v'];
      }
      
      // Pattern 2: https://youtu.be/VIDEO_ID
      if (url.contains('youtu.be/')) {
        final uri = Uri.parse(url);
        final segments = uri.pathSegments;
        if (segments.isNotEmpty) {
          return segments[0].split('?')[0]; // Remove query params if any
        }
      }
      
      // Pattern 3: https://www.youtube.com/embed/VIDEO_ID
      if (url.contains('youtube.com/embed/')) {
        final uri = Uri.parse(url);
        final segments = uri.pathSegments;
        if (segments.length >= 2 && segments[0] == 'embed') {
          return segments[1].split('?')[0];
        }
      }
      
      // Pattern 4: https://www.youtube.com/v/VIDEO_ID
      if (url.contains('youtube.com/v/')) {
        final uri = Uri.parse(url);
        final segments = uri.pathSegments;
        if (segments.length >= 2 && segments[0] == 'v') {
          return segments[1].split('?')[0];
        }
      }
    } catch (e) {
      debugPrint('❌ Error extracting YouTube ID: $e');
    }
    
    return null;
  }
  
  /// Extract Vimeo video ID from URL
  static String? extractVimeoId(String url) {
    if (url.isEmpty) return null;
    
    try {
      // Pattern 1: https://vimeo.com/VIDEO_ID
      if (url.contains('vimeo.com/')) {
        final uri = Uri.parse(url);
        final segments = uri.pathSegments;
        if (segments.isNotEmpty) {
          // Get last segment and remove any query params
          return segments.last.split('?')[0];
        }
      }
      
      // Pattern 2: https://player.vimeo.com/video/VIDEO_ID
      if (url.contains('player.vimeo.com/video/')) {
        final uri = Uri.parse(url);
        final segments = uri.pathSegments;
        if (segments.length >= 2 && segments[0] == 'video') {
          return segments[1].split('?')[0];
        }
      }
    } catch (e) {
      debugPrint('❌ Error extracting Vimeo ID: $e');
    }
    
    return null;
  }
  
  /// Check if URL is YouTube video
  static bool isYouTubeVideo(String url) {
    return detectVideoType(url) == videoTypeYouTube;
  }
  
  /// Check if URL is Vimeo video
  static bool isVimeoVideo(String url) {
    return detectVideoType(url) == videoTypeVimeo;
  }
  
  /// Check if it's internal video (not external URL)
  static bool isInternalVideo(String videoId) {
    return detectVideoType(videoId) == videoTypeInternal;
  }
  
  /// Get YouTube embed URL from video ID
  static String getYouTubeEmbedUrl(String videoId) {
    return 'https://www.youtube.com/embed/$videoId';
  }
  
  /// Get Vimeo embed URL from video ID
  static String getVimeoEmbedUrl(String videoId) {
    return 'https://player.vimeo.com/video/$videoId';
  }
}
