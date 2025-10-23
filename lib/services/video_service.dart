import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'http_client.dart';
import '../utils/api_constants.dart';

/// Video Service - Handle video upload, status check, and streaming
/// Based on VIDEO_FETCH_GUIDE.md
class VideoService {
  final HttpClient _httpClient = HttpClient();

  /// Upload video file
  /// POST /api/videos
  Future<VideoUploadResponse> uploadVideo({
    required File videoFile,
    String? videoId,
    int hlsTime = 4, // seconds per segment
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/videos');
      var request = http.MultipartRequest('POST', uri);
      
      // Add file
      request.files.add(
        await http.MultipartFile.fromPath('file', videoFile.path),
      );
      
      // Add optional parameters
      if (videoId != null) {
        request.fields['videoId'] = videoId;
      }
      request.fields['hlsTime'] = hlsTime.toString();
      
      // Add auth token
      final token = await _httpClient.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return VideoUploadResponse.fromJson(data);
      } else {
        throw Exception('Failed to upload video: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error uploading video: $e');
    }
  }

  /// Get video processing status
  /// GET /api/videos/{videoId}/status
  Future<VideoStatus> getVideoStatus(String videoId) async {
    try {
      final response = await _httpClient.get('/api/videos/$videoId/status');
      final data = json.decode(response.body);
      return VideoStatus.fromJson(data);
    } catch (e) {
      throw Exception('Error getting video status: $e');
    }
  }

  /// Get HLS master playlist URL
  String getPlaylistUrl(String videoId) {
    return '${ApiConstants.baseUrl}/api/videos/stream/$videoId/master.m3u8';
  }

  /// Get segment URL
  String getSegmentUrl(String videoId, String fileName) {
    return '${ApiConstants.baseUrl}/api/videos/stream/$videoId/$fileName';
  }

  /// Monitor video status until ready
  /// Polls every 2 seconds
  Stream<VideoStatus> monitorVideoStatus(String videoId) async* {
    while (true) {
      try {
        final status = await getVideoStatus(videoId);
        yield status;
        
        // Stop polling if ready or error
        if (status.status == 'ready' || status.status == 'error') {
          break;
        }
        
        // Wait 2 seconds before next poll
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        yield VideoStatus(
          videoId: videoId,
          status: 'error',
          message: 'Error monitoring status: $e',
        );
        break;
      }
    }
  }

  /// Health check
  /// GET /api/videos/health
  Future<bool> healthCheck() async {
    try {
      await _httpClient.get('/api/videos/health');
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Video Upload Response Model
class VideoUploadResponse {
  final String videoId;
  final String message;
  final String? status;

  VideoUploadResponse({
    required this.videoId,
    required this.message,
    this.status,
  });

  factory VideoUploadResponse.fromJson(Map<String, dynamic> json) {
    return VideoUploadResponse(
      videoId: json['videoId'] as String,
      message: json['message'] as String,
      status: json['status'] as String?,
    );
  }
}

/// Video Status Model
class VideoStatus {
  final String videoId;
  final String status; // queued, encoding, uploading, ready, streaming, error
  final String? message;
  final int? progress; // 0-100
  final Map<String, dynamic>? metadata;

  VideoStatus({
    required this.videoId,
    required this.status,
    this.message,
    this.progress,
    this.metadata,
  });

  factory VideoStatus.fromJson(Map<String, dynamic> json) {
    return VideoStatus(
      videoId: json['videoId'] as String,
      status: json['status'] as String,
      message: json['message'] as String?,
      progress: json['progress'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Get progress percentage based on status
  int getProgressPercentage() {
    if (progress != null) return progress!;
    
    switch (status) {
      case 'queued':
        return 10;
      case 'encoding':
        return 50;
      case 'uploading':
        return 80;
      case 'ready':
      case 'streaming':
        return 100;
      case 'error':
        return 0;
      default:
        return 0;
    }
  }

  bool get isReady => status == 'ready' || status == 'streaming';
  bool get isProcessing => status == 'queued' || status == 'encoding' || status == 'uploading';
  bool get hasError => status == 'error';
}
