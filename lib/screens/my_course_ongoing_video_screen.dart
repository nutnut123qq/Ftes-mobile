import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../providers/video_provider.dart';
import '../widgets/youtube_player_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCourseOngoingVideoScreen extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;
  final String courseTitle;
  final String videoUrl; // This can be videoId for HLS streaming
  final int currentTime;
  final int totalTime;

  const MyCourseOngoingVideoScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.courseTitle,
    required this.videoUrl,
    this.currentTime = 0,
    this.totalTime = 0,
  });

  @override
  State<MyCourseOngoingVideoScreen> createState() => _MyCourseOngoingVideoScreenState();
}

class _MyCourseOngoingVideoScreenState extends State<MyCourseOngoingVideoScreen> {
  int _currentTime = 274; // 04:34 in seconds
  int _totalTime = 2194; // 36:34 in seconds
  VideoPlayerController? _controller;
  VideoStatus? _videoStatus;
  bool _isLoadingVideo = true;
  bool _isYouTubeVideo = false;
  String? _youtubeVideoUrl;

  @override
  void initState() {
    super.initState();
    // Ensure valid time values
    _currentTime = widget.currentTime >= 0 ? widget.currentTime : 274;
    _totalTime = widget.totalTime > 0 ? widget.totalTime : 2194;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeVideo();
    });
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _initializeVideo() async {
    try {
      setState(() {
        _isLoadingVideo = true;
      });

      // Get video URL (could be videoId or direct URL)
      String videoIdentifier = widget.videoUrl;
      
      // If no videoUrl passed, fetch lesson detail to get video
      if (videoIdentifier.isEmpty && mounted) {
        final courseProvider = Provider.of<CourseProvider>(context, listen: false);
        final lesson = await courseProvider.fetchLessonById(widget.lessonId);
        videoIdentifier = lesson?.videoUrl ?? '';
      }

      if (videoIdentifier.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoadingVideo = false;
          });
        }
        return;
      }

      // Check if this is a direct URL (YouTube, HTTP, etc.) or videoId
      if (_isYouTubeUrl(videoIdentifier)) {
        // YouTube URL - use YouTube player
        await _setupYouTubePlayer(videoIdentifier);
      } else if (_isDirectVideoUrl(videoIdentifier)) {
        // Direct video URL - play immediately
        await _setupVideoPlayer(videoIdentifier);
      } else {
        // Possible videoId - check status for HLS streaming
        if (!mounted) return;
        final videoProvider = Provider.of<VideoProvider>(context, listen: false);
        
        try {
          final status = await videoProvider.fetchVideoStatus(videoIdentifier);
          
          if (status != null && mounted) {
            setState(() {
              _videoStatus = status;
            });

            // If video is ready, fetch playlist from API
            if (status.isReady) {
              final playlist = await videoProvider.fetchVideoPlaylist(videoIdentifier, presign: true);
              if (playlist != null) {
                final playlistUrl = playlist.getBestUrl();
                if (playlistUrl != null && playlistUrl.isNotEmpty) {
                  await _setupVideoPlayer(playlistUrl);
                } else {
                  // Fallback to direct proxy URL
                  final fallbackUrl = videoProvider.getPlaylistUrl(videoIdentifier);
                  await _setupVideoPlayer(fallbackUrl);
                }
              }
            } else if (status.isProcessing) {
              // Monitor status until ready
              videoProvider.monitorVideoStatus(
                videoIdentifier,
                onUpdate: (updatedStatus) async {
                  if (mounted) {
                    setState(() {
                      _videoStatus = updatedStatus;
                    });
                    
                    if (updatedStatus.isReady) {
                      final playlist = await videoProvider.fetchVideoPlaylist(videoIdentifier, presign: true);
                      if (playlist != null) {
                        final playlistUrl = playlist.getBestUrl();
                        if (playlistUrl != null && playlistUrl.isNotEmpty) {
                          _setupVideoPlayer(playlistUrl);
                        } else {
                          final fallbackUrl = videoProvider.getPlaylistUrl(videoIdentifier);
                          _setupVideoPlayer(fallbackUrl);
                        }
                      }
                    }
                  }
                },
              );
            }
          } else {
            // Not a valid videoId, treat as direct URL
            await _setupVideoPlayer(videoIdentifier);
          }
        } catch (e) {
          // Error checking status, assume it's a direct URL
          await _setupVideoPlayer(videoIdentifier);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
      }
    }
  }

  Future<void> _setupVideoPlayer(String url) async {
    try {
      // Get access token for HLS streaming
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      
      // Use network() with httpHeaders instead of networkUrl()
      if (accessToken != null && accessToken.isNotEmpty) {
        // ignore: deprecated_member_use
        _controller = VideoPlayerController.network(
          url,
          httpHeaders: {
            'Authorization': 'Bearer $accessToken',
          },
        );
      } else {
        // Fallback to networkUrl if no token (shouldn't happen for authenticated users)
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      }
      
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
      }
      _controller!.play();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
      }
    }
  }

  Future<void> _setupYouTubePlayer(String url) async {
    try {
      if (mounted) {
        setState(() {
          _youtubeVideoUrl = url;
          _isYouTubeVideo = true;
          _isLoadingVideo = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Reset to portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller?.dispose();
    // Stop video monitoring
    Provider.of<VideoProvider>(context, listen: false).stopMonitoring();
    super.dispose();
  }

  // Helper to detect YouTube URLs
  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  // Helper to detect direct video URLs (non-videoId)
  bool _isDirectVideoUrl(String url) {
    return _isYouTubeUrl(url) || url.startsWith('http') || url.endsWith('.mp4');
  }

  Widget _buildVideoContent() {
    // Show YouTube player if YouTube video
    if (_isYouTubeVideo && _youtubeVideoUrl != null) {
      return Stack(
        children: [
          YouTubePlayerWidget(videoUrl: _youtubeVideoUrl!),
          // Block all pointer events on video
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: IgnorePointer(
                ignoring: false,
                child: Container(),
              ),
            ),
          ),
        ],
      );
    }

    // Show video player if initialized
    if (_controller != null && _controller!.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      );
    }

    // Show processing status if available
    if (_videoStatus != null && _videoStatus!.isProcessing) {
      return _buildProcessingIndicator();
    }

    // Show loading indicator
    if (_isLoadingVideo) {
      return _buildLoadingIndicator();
    }

    // Show error or empty state
    return _buildEmptyState();
  }

  Widget _buildProcessingIndicator() {
    final progress = _videoStatus?.getProgressPercentage() ?? 0;
    final statusText = _videoStatus?.status ?? 'processing';
    
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0961F5)),
            ),
            const SizedBox(height: 16),
            Text(
              'Processing Video...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: $statusText',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            // Progress bar
            Container(
              width: 200,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0961F5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$progress%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0961F5)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Video not available',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use different layout for Web vs Mobile
    if (kIsWeb && _isYouTubeVideo) {
      return _buildWebLayout(context);
    }
    return _buildMobileLayout(context);
  }
  
  // Web layout: Buttons OUTSIDE video area to avoid iframe z-index issues
  Widget _buildWebLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Video container - takes available space
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _buildVideoContent(),
                ),
              ),
            ),
          ),
          
          // Control bar - BELOW video (no iframe blocking)
          Container(
            height: 80,
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Back button
                PointerInterceptor(
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                
                // Play/Pause (if needed)
                PointerInterceptor(
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Handle play/pause
                    },
                  ),
                ),
                
                // Fullscreen button
                PointerInterceptor(
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Handle fullscreen toggle
                    },
                  ),
                ),
                
                // Menu button
                PointerInterceptor(
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context, 
                        AppConstants.routeChatMessages,
                        arguments: {
                          'lessonId': widget.lessonId,
                          'lessonTitle': widget.lessonTitle,
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Mobile layout: Original overlay design
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Video area - LOWEST LAYER
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: false, // Allow video to receive touches
                child: _buildVideoContent(),
              ),
            ),
            
            // HIGHEST LAYER - All interactive elements
            // Left zone
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 100,
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (_) {
                  // Left zone interaction
                },
                child: AbsorbPointer(
                  absorbing: false,
                  child: Container(
                    child: Stack(
                      children: [
                        if (_controller != null && _controller!.value.isInitialized)
                          Positioned(
                            left: 20,
                            top: 100,
                            bottom: 100,
                            child: Container(
                              width: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Color(0xFFE8F1FF),
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: 8,
                                      height: MediaQuery.of(context).size.height * 0.22,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF167F71),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: MediaQuery.of(context).size.height * 0.22 - 8,
                                    left: -4,
                                    child: Container(
                                      width: 0,
                                      height: 0,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.transparent,
                                            width: 8,
                                          ),
                                          right: BorderSide(
                                            color: Colors.transparent,
                                            width: 8,
                                          ),
                                          bottom: BorderSide(
                                            color: Colors.white,
                                            width: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Positioned(
                          left: 35,
                          top: 120,
                          child: Transform.rotate(
                            angle: 1.5708,
                            child: Text(
                              _formatTime(_currentTime),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Jost',
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 35,
                          bottom: 120,
                          child: Transform.rotate(
                            angle: 1.5708,
                            child: Text(
                              _formatTime(_totalTime),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Jost',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Right zone with back button
            Positioned(
              right: 0,
              top: 0,
              height: 120,
              width: 100,
              child: Container(
                color: Colors.green.withOpacity(0.3), // More visible debug color
                child: Stack(
                  children: [
                    // Back/Close button  
                    Positioned(
                      top: 20,
                      right: 20,
                      child: PointerInterceptor(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom zone with buttons
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 120,
              child: Container(
                child: Stack(
                  children: [
                    // Fullscreen button
                    Positioned(
                      left: 20,
                      bottom: 50,
                      child: PointerInterceptor(
                        child: GestureDetector(
                          onTap: () {
                            // Handle fullscreen toggle
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Menu button
                    Positioned(
                      right: 20,
                      bottom: 50,
                      child: PointerInterceptor(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              AppConstants.routeChatMessages,
                              arguments: {
                                'lessonId': widget.lessonId,
                                'lessonTitle': widget.lessonTitle,
                              },
                            );
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Transform.rotate(
                              angle: 1.5708,
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Home indicator
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 134,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Color(0xFFE2E6EA),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Course title on right side
            Positioned(
              right: 20,
              top: 150,
              bottom: 150,
              child: Center(
                child: Transform.rotate(
                  angle: 1.5708,
                  child: SizedBox(
                    width: 200,
                    height: 30,
                    child: Text(
                      widget.courseTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Jost',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatTime(int seconds) {
    // Handle invalid values
    if (seconds < 0) {
      return '00:00';
    }
    
    try {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00:00';
    }
  }

}