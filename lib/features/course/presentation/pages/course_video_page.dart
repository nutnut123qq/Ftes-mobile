import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
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

  const CourseVideoPage({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.courseTitle,
    required this.videoUrl,
    required this.courseId,
  });

  @override
  State<CourseVideoPage> createState() => _CourseVideoPageState();
}

class _CourseVideoPageState extends State<CourseVideoPage> {
  VideoPlayerController? _controller;
  bool _isLoadingVideo = true;
  bool _isYouTubeVideo = false;

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

  Future<void> _initializeVideo() async {
    try {
      setState(() {
        _isLoadingVideo = true;
      });

      // Get userId
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(app_constants.AppConstants.keyUserId);

      if (userId == null || userId.isEmpty) {
        _showNotEnrolledError();
        return;
      }

      // Check enrollment and load video
      final viewModel = Provider.of<CourseVideoViewModel>(context, listen: false);
      final canWatch = await viewModel.checkEnrollmentAndLoadVideo(
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
        setState(() {
          _isYouTubeVideo = true;
          _isLoadingVideo = false;
        });
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
      
      // Get best URL from playlist (priority: proxyPlaylistUrl > cdnPlaylistUrl > presignedUrl)
      final playlist = viewModel.videoPlaylist!;
      String? videoUrl;
      
      if (playlist.proxyPlaylistUrl != null && playlist.proxyPlaylistUrl!.isNotEmpty) {
        // Build full URL for proxy if it's a relative path
        videoUrl = playlist.proxyPlaylistUrl!.startsWith('http')
            ? playlist.proxyPlaylistUrl
            : '${app_constants.AppConstants.videoStreamBaseUrl}${playlist.proxyPlaylistUrl}';
        print('🎥 Using proxy URL');
      } else if (playlist.cdnPlaylistUrl.isNotEmpty) {
        videoUrl = playlist.cdnPlaylistUrl;
        print('🎥 Using CDN URL');
      } else if (playlist.presignedUrl != null && playlist.presignedUrl!.isNotEmpty) {
        videoUrl = playlist.presignedUrl;
        print('🎥 Using presigned URL');
      }
      
      if (videoUrl == null || videoUrl.isEmpty) {
        throw Exception('Không tìm thấy URL video hợp lệ từ server');
      }
      
      print('🎥 Final HLS URL: $videoUrl');
      
      // Initialize video player with auth header
      // ignore: deprecated_member_use
      _controller = VideoPlayerController.network(
        videoUrl,
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildVideoContent() {
    // Show external video player (YouTube/Vimeo) if external video
    if (_isYouTubeVideo) {
      final viewModel = Provider.of<CourseVideoViewModel>(context, listen: false);
      final videoType = viewModel.videoType;
      
      // For both YouTube and Vimeo, we use YouTubePlayerWidget
      // (it can handle both via iframe)
      return Stack(
        children: [
          YouTubePlayerWidget(
            videoUrl: widget.videoUrl,
            videoType: videoType ?? VideoConstants.videoTypeYoutube,
          ),
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
          children: [
            // Video area
            Positioned.fill(
              child: _buildVideoContent(),
            ),
            
            // Back button
            Positioned(
              top: 20,
              right: 20,
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
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            
            // Course title
            Positioned(
              right: 20,
              top: 150,
              child: Transform.rotate(
                angle: 1.5708,
                child: SizedBox(
                  width: 200,
                  child: Text(
                    widget.courseTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Jost',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            
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

