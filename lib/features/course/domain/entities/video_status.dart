/// Video Status entity for tracking video processing state
class VideoStatus {
  final String videoId;
  final String status; // "ready", "processing", "failed", "pending"
  final String? message;

  const VideoStatus({
    required this.videoId,
    required this.status,
    this.message,
  });

  bool get isReady => status == "ready";
  bool get isProcessing => status == "processing";
  bool get isFailed => status == "failed";
  bool get isPending => status == "pending";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VideoStatus &&
        other.videoId == videoId &&
        other.status == status &&
        other.message == message;
  }

  @override
  int get hashCode {
    return videoId.hashCode ^ status.hashCode ^ (message?.hashCode ?? 0);
  }

  @override
  String toString() {
    return 'VideoStatus(videoId: $videoId, status: $status, message: $message)';
  }
}

