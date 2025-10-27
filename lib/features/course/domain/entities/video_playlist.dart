/// Video Playlist entity for HLS streaming
class VideoPlaylist {
  final String videoId;
  final String cdnPlaylistUrl;
  final String? presignedUrl;
  final String? proxyPlaylistUrl;

  const VideoPlaylist({
    required this.videoId,
    required this.cdnPlaylistUrl,
    this.presignedUrl,
    this.proxyPlaylistUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VideoPlaylist &&
        other.videoId == videoId &&
        other.cdnPlaylistUrl == cdnPlaylistUrl &&
        other.presignedUrl == presignedUrl &&
        other.proxyPlaylistUrl == proxyPlaylistUrl;
  }

  @override
  int get hashCode {
    return videoId.hashCode ^
        cdnPlaylistUrl.hashCode ^
        (presignedUrl?.hashCode ?? 0) ^
        (proxyPlaylistUrl?.hashCode ?? 0);
  }

  @override
  String toString() {
    return 'VideoPlaylist(videoId: $videoId, cdnPlaylistUrl: $cdnPlaylistUrl)';
  }
}

