import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import for web
import 'youtube_player_web.dart' if (dart.library.io) 'youtube_player_mobile.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YouTubePlayerWidget({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  YoutubePlayerController? _controller;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    
    if (!kIsWeb && _videoId != null) {
      // Mobile only
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) {
      return const Center(
        child: Text('Invalid YouTube URL'),
      );
    }

    if (kIsWeb) {
      // Web platform
      return buildWebYouTubePlayer(_videoId!);
    } else {
      // Mobile platform
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
