import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/constants/app_constants.dart' as app_constants;
import '../../../../widgets/youtube_player_widget.dart';
import '../viewmodels/course_video_viewmodel.dart';
import '../../domain/constants/video_constants.dart';

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
      
      // Only use proxy URL - backend configured CDN to serve segments through proxy
      final playlist = viewModel.videoPlaylist!;
      
      String? videoUrl;
      if (playlist.proxyPlaylistUrl != null && playlist.proxyPlaylistUrl!.isNotEmpty) {
        // Proxy URL is already a full URL from datasource
        videoUrl = playlist.proxyPlaylistUrl!;
        print('✅ Using proxy URL: $videoUrl');
      } else {
        throw Exception('Không tìm thấy URL video hợp lệ từ server');
      }
      
      // For web platform, use HLS player directly (HTML5 video supports HLS natively)
      if (kIsWeb) {
        // Web doesn't support VideoPlayerController for HLS properly, use HLS URL directly
        if (videoUrl != null) {
          _hlsVideoUrl = videoUrl;
          print('🌐 Web platform - Using HLS URL for HTML5 video player');
          print('   $_hlsVideoUrl');
        } else {
          throw Exception('Không tìm thấy URL video hợp lệ từ server');
        }
      } else {
        // For mobile/desktop platforms, use VideoPlayerController with proxy URL
        try {
          print('🎥 Initializing video player with proxy URL');
          print('   $videoUrl');
          
          // Initialize video player with auth header
          // ignore: deprecated_member_use
          _controller = VideoPlayerController.network(
            videoUrl!,
            httpHeaders: {
              'Authorization': 'Bearer $accessToken',
            },
          );
          
          await _controller!.initialize();
          
          print('✅ Successfully initialized video player');
          
        } catch (e) {
          print('❌ Failed to initialize video player: $e');
          throw Exception('Không thể tải video: $e');
        }
      }
      
      if (mounted) {
        setState(() {
          _isLoadingVideo = false;
        });
      }
      
      // Play video (only for mobile/desktop, web uses HTML5 player)
      if (!kIsWeb && _controller != null) {
        _controller!.play();
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
      try {
        final wrapper = html.document.getElementById('hls-video-wrapper');
        wrapper?.remove();
      } catch (e) {
        print('Error cleaning up video: $e');
      }
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

    // Show HLS video for web platform using HTML5 video player
    if (kIsWeb && _hlsVideoUrl != null) {
      return _buildWebHlsPlayer(_hlsVideoUrl!);
    }

    // Show video player if initialized (for mobile/desktop)
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

  void _initializeHlsPlayer(String hlsUrl) {
    if (!kIsWeb) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final old = html.document.getElementById('hls-video-wrapper');
        old?.remove();
        
        // Create wrapper div positioned properly
        final wrapper = html.DivElement()
          ..id = 'hls-video-wrapper'
          ..style.position = 'fixed'
          ..style.top = '0'
          ..style.left = '0'
          ..style.width = '100vw'
          ..style.height = '100vh'
          ..style.zIndex = '0'
          ..style.backgroundColor = 'black';
        
        // Create video element
        final video = html.VideoElement()
          ..id = 'hls-video-player'
          ..controls = true
          ..autoplay = true
          ..muted = false
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = 'contain';
        
        wrapper.append(video);
        
        // Append wrapper to Flutter container
        final appContainer = html.document.querySelector('flt-scene-host') ?? html.document.body;
        appContainer?.append(wrapper);
        js.context.callMethod('eval', ['''
          var v = document.getElementById('hls-video-player');
          var src = "$hlsUrl";
          console.log('🎥 Initializing HLS with URL:', src);
          if (typeof Hls !== 'undefined' && Hls.isSupported()) {
            console.log('✅ Using HLS.js');
            var hls = new Hls({debug: true});
            hls.loadSource(src);
            hls.attachMedia(v);
            hls.on(Hls.Events.MANIFEST_PARSED, () => v.play());
            hls.on(Hls.Events.FRAGMENT_LOADED, (e, d) => console.log('📦 Fragment:', d.frag.url));
          } else if (v.canPlayType('application/vnd.apple.mpegurl')) {
            console.log('🍎 Using Safari HLS');
            v.src = src;
            v.play();
          }
        ''']);
      } catch (e) {
        print('❌ HLS init error: $e');
      }
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
  
  Widget _buildWebHlsPlayer_OLD(String hlsUrl) {
    // For web, use HLS.js to handle HLS video playback
    // HLS.js will parse m3u8 and load segments automatically
    return Center(
      child: Html(
        data: '''
          <video 
            id="hls-video-player" 
            controls 
            autoplay 
            playsinline
            style="width: 100%; height: 100%; object-fit: contain;"
          >
            Your browser does not support the video tag or HLS streaming.
          </video>
          <script>
            (function() {
              var video = document.getElementById('hls-video-player');
              var videoSrc = "$hlsUrl";
              
              if (Hls.isSupported()) {
                // Use HLS.js for non-Safari browsers (Chrome, Edge, Firefox)
                console.log('Using HLS.js for video playback');
                var hls = new Hls({
                  enableWorker: true,
                  lowLatencyMode: false,
                  backBufferLength: 90
                });
                
                hls.loadSource(videoSrc);
                hls.attachMedia(video);
                
                hls.on(Hls.Events.MANIFEST_PARSED, function() {
                  console.log('HLS manifest parsed, starting playback');
                  video.play().catch(function(error) {
                    console.log('Auto-play failed:', error);
                  });
                });
                
                hls.on(Hls.Events.ERROR, function(event, data) {
                  console.error('HLS error:', data);
                  if (data.fatal) {
                    switch (data.type) {
                      case Hls.ErrorTypes.NETWORK_ERROR:
                        console.error('Network error, trying to recover...');
                        hls.startLoad();
                        break;
                      case Hls.ErrorTypes.MEDIA_ERROR:
                        console.error('Media error, trying to recover...');
                        hls.recoverMediaError();
                        break;
                      default:
                        console.error('Fatal error, destroying player');
                        hls.destroy();
                        break;
                    }
                  }
                });
              } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
                // Safari native HLS support
                console.log('Using Safari native HLS support');
                video.src = videoSrc;
                video.play().catch(function(error) {
                  console.log('Auto-play failed:', error);
                });
              } else {
                console.error('HLS is not supported');
                video.innerHTML = 'HLS video playback is not supported in your browser.';
              }
            })();
          </script>
        ''',
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

