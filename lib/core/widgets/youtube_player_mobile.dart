// Mobile implementation - stubs for conditional imports
import 'package:flutter/material.dart';

Widget buildWebYouTubePlayer(String videoId) {
  // This should never be called on mobile
  // YouTube player is handled by youtube_player_flutter directly
  return const SizedBox.shrink();
}

Widget buildWebExternalPlayer(String embedUrl) {
  // For Vimeo on mobile - show message that it's not supported yet
  // TODO: Add webview_flutter or flutter_inappwebview to support Vimeo on mobile
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: Colors.white54,
          ),
          SizedBox(height: 16),
          Text(
            'Vimeo video player',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Vimeo videos are currently only supported on web platform.\nPlease use a web browser to watch this video.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}

