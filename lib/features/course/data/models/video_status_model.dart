import '../../domain/entities/video_status.dart';

/// Video Status Model for API response mapping
class VideoStatusModel {
  final String videoId;
  final String status;
  final String? message;

  const VideoStatusModel({
    required this.videoId,
    required this.status,
    this.message,
  });

  factory VideoStatusModel.fromJson(Map<String, dynamic> json) {
    return VideoStatusModel(
      videoId: json['videoId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'status': status,
      'message': message,
    };
  }

  VideoStatus toEntity() {
    return VideoStatus(
      videoId: videoId,
      status: status,
      message: message,
    );
  }
}

