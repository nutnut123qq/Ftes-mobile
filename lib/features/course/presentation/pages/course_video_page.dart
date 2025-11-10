import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/constants/app_constants.dart' as app_constants;
import '../../../../widgets/youtube_player_widget.dart';
import '../viewmodels/course_video_viewmodel.dart';
import '../../domain/constants/video_constants.dart';
import 'web_hls_helper.dart';

class CourseVideoPage extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;
  final String courseTitle;
  final String videoUrl;
  final String courseId;
  final String? type; // VIDEO, DOCUMENT, EXERCISE

  const CourseVideoPage({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.courseTitle,
    required this.videoUrl,
    required this.courseId,
    this.type,
  });

  @override
  State<CourseVideoPage> createState() => _CourseVideoPageState();
}

class _CourseVideoPageState extends State<CourseVideoPage> {
  VideoPlayerController? _controller;
  bool _isLoadingVideo = true;
  bool _isYouTubeVideo = false;
  String? _hlsVideoUrl; // For web platform HLS playback

  @override
  void initState() {
    super.initState();
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideo();
    });
  }

  /// Optimized video initialization with parallel async operations
  Future<void> _initializeVideo() async {
    try {
      if (mounted) {
        setState(() {
          _isLoadingVideo = true;
        });
      }

      // Check lesson type - if not VIDEO, skip video loading and show popup
      if (widget.type != null && widget.type != 'VIDEO') {
        print('📄 Lesson type is ${widget.type}, not VIDEO. Showing content popup.');
        if (mounted) {
          setState(() {
            _isLoadingVideo = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showContentDialog();
          });
        }
        return;
      }

      // Get userId and access token in parallel
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(app_constants.AppConstants.keyUserId);

      if (userId == null || userId.isEmpty) {
        _showNotEnrolledError();
        return;
      }

      // Initialize video via optimized ViewModel method
      final viewModel = Provider.of<CourseVideoViewModel>(context, listen: false);
      final canWatch = await viewModel.initializeVideo(
        userId,
        widget.courseId,
        widget.videoUrl,
      );

      if (!canWatch) {
        _showNotEnrolledError();
        return;
      }

      // Load video based on type
      final videoType = viewModel.videoType;

      if (videoType == VideoConstants.videoTypeYoutube || videoType == VideoConstants.videoTypeVimeo) {
        // External video (YouTube/Vimeo) - use web player
        if (mounted) {
          setState(() {
            _isYouTubeVideo = true;
            _isLoadingVideo = false;
          });
        }
      } else if (videoType == VideoConstants.videoTypeExternal) {
        // Direct URL - play directly
        await _setupDirectVideo();
      } else {
        // Internal HLS video - load playlist from API
        await _setupHlsVideo();
      }
    } catch (e) {
      print('❌ Error initializing video: $e');
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
      }
    }
  }

  Future<void> _setupHlsVideo() async {
    try {
      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(app_constants.AppConstants.keyAccessToken);
      
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Access token not found');
      }
      
      print('🎥 Setting up internal HLS video: ${widget.videoUrl}');
      
      // Load video playlist via ViewModel (calls API)
      final viewModel = Provider.of<CourseVideoViewModel>(context, listen: false);
      await viewModel.loadVideoPlaylist(widget.videoUrl);
      
      if (viewModel.errorMessage != null) {
        // Check if it's a 404 error (API not implemented or video not found)
        if (viewModel.errorMessage!.contains('404') || viewModel.errorMessage!.contains('Not Found')) {
          throw Exception(VideoConstants.errorApiNotImplemented);
        }
        throw Exception(viewModel.errorMessage);
      }
      
      if (viewModel.videoPlaylist == null) {
        throw Exception(VideoConstants.errorVideoLoadFailed);
      }
      
      // Get video playlist from API
      final playlist = viewModel.videoPlaylist!;
      
      String? videoUrl;
      // Tất cả platforms ưu tiên proxy URL (chỉ có proxy là dùng được)
      if (playlist.proxyPlaylistUrl != null && playlist.proxyPlaylistUrl!.isNotEmpty) {
        videoUrl = playlist.proxyPlaylistUrl;
        print('✅ Using proxy URL (only proxy is available): $videoUrl');
      } else if (playlist.cdnPlaylistUrl.isNotEmpty) {
        videoUrl = playlist.cdnPlaylistUrl;
        print('⚠️ Fallback to CDN URL: $videoUrl');
      } else if (playlist.presignedUrl != null && playlist.presignedUrl!.isNotEmpty) {
        videoUrl = playlist.presignedUrl;
        print('⚠️ Fallback to presigned URL: $videoUrl');
      } else {
        throw Exception('Không tìm thấy URL video hợp lệ từ server');
      }
      
      // For web platform, use HLS player directly (HTML5 video supports HLS natively)
      if (kIsWeb) {
        // Web doesn't support VideoPlayerController for HLS properly, use HLS URL directly
        _hlsVideoUrl = videoUrl!;
        print('🌐 Web platform - Using HLS URL for HTML5 video player');
        print('   $_hlsVideoUrl');
      } else {
        // Mobile: dùng VideoPlayerController.networkUrl (hỗ trợ HLS native)
          print('📱 Mobile platform - Initializing VideoPlayerController with HLS');
          print('   URL: $videoUrl');
          print('⚠️ Note: If publicly available m3u8 fails, backend must transform m3u8 segments to proxy');
          
          // Initialize VideoPlayerController với HLS URL
          // networkUrl() là API mới hỗ trợ HLS native trên Android/iOS
          // Proxy URL: cần Authorization header để proxy có thể fetch từ S3
          // Presigned URL: S3 signed URL có auth trong query params, không cần header
          final isPresigned = playlist.presignedUrl != null && 
                              playlist.presignedUrl!.isNotEmpty && 
                              videoUrl == playlist.presignedUrl;
          
          final isProxy = playlist.proxyPlaylistUrl != null && 
                          playlist.proxyPlaylistUrl!.isNotEmpty && 
                          videoUrl == playlist.proxyPlaylistUrl;
          
          print('🔑 Is presigned URL: $isPresigned');
          print('🔑 Is proxy URL: $isProxy');
          
          // Note: BunnyCDN requires Referer header to bypass Hotlink Protection
          // Headers are forwarded to all segment requests by ExoPlayer
          final Map<String, String> headers = {
            'Referer': 'https://ftes.vn',
            'User-Agent': 'Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0 Mobile Safari/537.36',
          };
          
          print('🔑 Using headers: Referer + User-Agent for BunnyCDN Hotlink Protection bypass');
          
          _controller = VideoPlayerController.networkUrl(
            Uri.parse(videoUrl!),
            httpHeaders: headers,
          );
          
          // Initialize và play video
          await _controller!.initialize();
          await _controller!.play();
          
          // Add listener to update UI when video position changes
          _controller!.addListener(() {
            if (mounted) {
              setState(() {
                // This will trigger UI update when video position changes
              });
            }
          });
          
          print('✅ Mobile video initialized and playing');
      }
      
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
      }
    } catch (e) {
      print('❌ Error setting up HLS video: $e');
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
        
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lỗi phát video'),
            content: Text('Không thể tải video.\n\n${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close video page
                },
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _setupDirectVideo() async {
    try {
      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(app_constants.AppConstants.keyAccessToken);
      
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Access token not found');
      }
      
      print('🎥 Setting up direct video URL: ${widget.videoUrl}');
      
      // Initialize video player with auth header
      // ignore: deprecated_member_use
      _controller = VideoPlayerController.network(
        widget.videoUrl,
        httpHeaders: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      
      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
      }
      
      _controller!.play();
    } catch (e) {
      print('❌ Error setting up direct video: $e');
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lỗi phát video'),
            content: Text('Không thể phát video.\n\n${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showNotEnrolledError() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(VideoConstants.notEnrolledTitle),
        content: const Text(VideoConstants.notEnrolledMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close video page
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up web video wrapper element
    if (kIsWeb) {
      getWebHlsHelper().cleanupWrapper();
    }
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller?.dispose();
    super.dispose();
  }

  void _showContentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E293B), // Dark blue color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.type ?? 'Content',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey, height: 24),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Html(
                      data: widget.videoUrl,
                      style: {
                        "body": Style(
                          color: Colors.white,
                          margin: Margins.zero,
                        ),
                        "a": Style(
                          color: const Color(0xFF0961F5), // Blue links
                          textDecoration: TextDecoration.underline,
                        ),
                        "p": Style(
                          margin: Margins.only(bottom: 8),
                        ),
                        "ul": Style(
                          margin: Margins.only(bottom: 8),
                          padding: HtmlPaddings.zero,
                        ),
                        "li": Style(
                          margin: Margins.only(bottom: 4),
                        ),
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoContent() {
    // Check if lesson type is not VIDEO - show document icon
    if (widget.type != null && widget.type != 'VIDEO') {
      return GestureDetector(
        onTap: _showContentDialog,
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 100,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              widget.lessonTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to view content',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      );
    }

    // Show external video player (YouTube/Vimeo) if external video
    if (_isYouTubeVideo) {
      final viewModel = Provider.of<CourseVideoViewModel>(context, listen: false);
      final videoType = viewModel.videoType;
      
      // For both YouTube and Vimeo, we use YouTubePlayerWidget
      // (it can handle both via iframe) - make it smaller and more compact
      return Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(40.0), // Add padding to make smaller
          child: Center(
            child: YouTubePlayerWidget(
              videoUrl: widget.videoUrl,
              videoType: videoType ?? VideoConstants.videoTypeYoutube,
            ),
          ),
        ),
      );
    }

    // HLS - Web: HTML5 layer
    if (kIsWeb && _hlsVideoUrl != null) {
      return _buildWebHlsPlayer(_hlsVideoUrl!);
    }

    // Show video player if initialized (for mobile/desktop HLS hoặc direct video)
    if (_controller != null && _controller!.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: _buildVideoPlayerWithControls(),
        ),
      );
    }

    // Show loading indicator
    if (_isLoadingVideo) {
      return _buildLoadingIndicator();
    }

    // Show error or empty state
    return _buildEmptyState();
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0961F5)),
      ),
    );
  }

  Widget _buildVideoPlayerWithControls() {
    return Stack(
      children: [
        // Video player
        VideoPlayer(_controller!),
        
        // Custom video controls overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              // Toggle play/pause when tapping video
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Progress bar with seek functionality
                  GestureDetector(
                    onTapDown: (details) async {
                      // Seek to tapped position
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final double x = details.globalPosition.dx;
                      final double boxLeft = box.localToGlobal(Offset.zero).dx;
                      final double localX = x - boxLeft;
                      final double width = box.size.width;
                      final double percentage = (localX / width).clamp(0.0, 1.0);
                      
                      if (_controller!.value.duration.inMilliseconds > 0) {
                        final Duration newPosition = Duration(
                          milliseconds: (percentage * _controller!.value.duration.inMilliseconds).round(),
                        );
                        await _controller!.seekTo(newPosition);
                      }
                    },
                    child: Container(
                      height: 32, // Larger touch area
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        height: 2,
                        color: Colors.white.withOpacity(0.3),
                        child: Stack(
                          children: [
                            // Current position indicator
                            if (_controller!.value.position.inSeconds < _controller!.value.duration.inSeconds)
                              FractionallySizedBox(
                                widthFactor: _controller!.value.duration.inMilliseconds > 0
                                    ? _controller!.value.position.inMilliseconds / 
                                      _controller!.value.duration.inMilliseconds
                                    : 0.0,
                                child: Container(
                                  height: 2,
                                  color: Color(0xFF0961F5),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Control buttons
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        // Play/Pause button
                        IconButton(
                          icon: Icon(
                            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_controller!.value.isPlaying) {
                                _controller!.pause();
                              } else {
                                _controller!.play();
                              }
                            });
                          },
                        ),
                        
                        // Time display
                        Expanded(
                          child: Text(
                            '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  void _initializeHlsPlayer(String hlsUrl) {
    if (!kIsWeb) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWebHlsHelper().initHlsPlayer(hlsUrl);
    });
  }
  
  Widget _buildWebHlsPlayer(String hlsUrl) {
    _initializeHlsPlayer(hlsUrl);
    // Return a container with low opacity to ensure Flutter widgets render on top
    return Container(
      color: Colors.transparent.withOpacity(0.01),
      width: double.infinity,
      height: double.infinity,
    );
  }
  
  // Removed legacy web HLS builder (unused)

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
            const Text(
              'Video not available',
              style: TextStyle(
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Transparent layer to ensure Flutter widgets render above video
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: ColoredBox(
                  color: Colors.transparent,
                ),
              ),
            ),
            // Video area
            Positioned.fill(
              child: _buildVideoContent(),
            ),
            
            // Back button - small and compact
            Positioned(
              top: 20,
              left: 20,
              child: IgnorePointer(
                ignoring: false,
                child: GestureDetector(
                  onTap: () {
                    print('Back button tapped');
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            
            // Course title - hidden to avoid blocking screen
            // Commented out: Positioned(
            //   right: 20,
            //   top: 150,
            //   child: Transform.rotate(
            //     angle: 1.5708,
            //     child: SizedBox(
            //       width: 200,
            //       child: Text(
            //         widget.courseTitle,
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 18,
            //           fontWeight: FontWeight.w600,
            //           fontFamily: 'Jost',
            //         ),
            //         textAlign: TextAlign.center,
            //         maxLines: 2,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ),
            // ),
            
            // Bottom indicator
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E6EA),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

