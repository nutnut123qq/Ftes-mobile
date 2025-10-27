import '../../domain/entities/video_playlist.dart';

/// Video Playlist Model for API response mapping
class VideoPlaylistModel {
  final String videoId;
  final String cdnPlaylistUrl;
  final String? presignedUrl;
  final String? proxyPlaylistUrl;

  const VideoPlaylistModel({
    required this.videoId,
    required this.cdnPlaylistUrl,
    this.presignedUrl,
    this.proxyPlaylistUrl,
  });

  factory VideoPlaylistModel.fromJson(Map<String, dynamic> json) {
    return VideoPlaylistModel(
      videoId: json['videoId'] as String? ?? '',
      cdnPlaylistUrl: json['cdnPlaylistUrl'] as String? ?? '',
      presignedUrl: json['presignedUrl'] as String?,
      proxyPlaylistUrl: json['proxyPlaylistUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'cdnPlaylistUrl': cdnPlaylistUrl,
      'presignedUrl': presignedUrl,
      'proxyPlaylistUrl': proxyPlaylistUrl,
    };
  }

  VideoPlaylist toEntity() {
    return VideoPlaylist(
      videoId: videoId,
      cdnPlaylistUrl: cdnPlaylistUrl,
      presignedUrl: presignedUrl,
      proxyPlaylistUrl: proxyPlaylistUrl,
    );
  }
}

