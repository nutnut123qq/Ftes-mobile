import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import for web
import 'youtube_player_web.dart' if (dart.library.io) 'youtube_player_mobile.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? videoType; // 'youtube', 'vimeo', etc.

  const YouTubePlayerWidget({
    Key? key,
    required this.videoUrl,
    this.videoType = 'youtube',
  }) : super(key: key);

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  YoutubePlayerController? _controller;
  String? _videoId;
  bool _isVimeo = false;

  @override
  void initState() {
    super.initState();
    
    // Check if it's Vimeo or YouTube
    _isVimeo = widget.videoType == 'vimeo';
    
    if (_isVimeo) {
      // Extract Vimeo ID
      _videoId = _extractVimeoId(widget.videoUrl);
    } else {
      // Extract YouTube ID
      _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    }
    
    if (!kIsWeb && _videoId != null && !_isVimeo) {
      // Mobile YouTube player (only for YouTube, not Vimeo)
      _controller = YoutubePlayerController(
        initialVideoId: _videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
        ),
      );
    }
  }

  String? _extractVimeoId(String url) {
    final vimeoRegex = RegExp(r'(?:vimeo\.com/)(\d+)');
    final match = vimeoRegex.firstMatch(url);
    return match?.group(1);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) {
      return Center(
        child: Text('Invalid ${_isVimeo ? 'Vimeo' : 'YouTube'} URL'),
      );
    }

    if (kIsWeb) {
      // Web platform - use iframe for both YouTube and Vimeo
      if (_isVimeo) {
        return buildWebVimeoPlayer(_videoId!);
      } else {
        return buildWebYouTubePlayer(_videoId!);
      }
    } else {
      // Mobile platform
      if (_isVimeo) {
        // For Vimeo on mobile, use WebView (via buildWebVimeoPlayer)
        return buildWebVimeoPlayer(_videoId!);
      } else {
        // YouTube on mobile - use native player
        if (_controller == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFF0961F5),
          progressColors: const ProgressBarColors(
            playedColor: Color(0xFF0961F5),
            handleColor: Color(0xFF0961F5),
          ),
        );
      }
    }
  }
  
  Widget buildWebVimeoPlayer(String vimeoId) {
    // Use the existing web player with Vimeo embed URL
    return buildWebExternalPlayer('https://player.vimeo.com/video/$vimeoId?title=0&byline=0&portrait=0&badge=0');
  }
}
