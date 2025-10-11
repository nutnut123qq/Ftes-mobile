import 'dart:convert';
import 'dart:io';
import '../models/feedback_response.dart';
import '../models/create_feedback_request.dart';
import '../models/update_feedback_request.dart';
import 'http_client.dart';

class FeedbackService {
  final HttpClient _httpClient = HttpClient();

  /// Create a new feedback/review
  /// POST /api/feedbacks
  Future<FeedbackResponse> createFeedback(CreateFeedbackRequest request) async {
    try {
      final response = await _httpClient.post(
        '/api/feedbacks',
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return FeedbackResponse.fromJson(data);
      } else {
        throw HttpException(
          'Failed to create feedback: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error creating feedback: $e');
    }
  }

  /// Get feedback by ID
  /// GET /api/feedbacks/{id}
  Future<FeedbackResponse> getFeedbackById(int feedbackId) async {
    try {
      final response = await _httpClient.get(
        '/api/feedbacks/$feedbackId',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FeedbackResponse.fromJson(data);
      } else {
        throw HttpException(
          'Failed to get feedback: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error getting feedback: $e');
    }
  }

  /// Update existing feedback
  /// PUT /api/feedbacks/{id}
  Future<FeedbackResponse> updateFeedback(
    int feedbackId,
    UpdateFeedbackRequest request,
  ) async {
    try {
      final response = await _httpClient.put(
        '/api/feedbacks/$feedbackId',
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FeedbackResponse.fromJson(data);
      } else {
        throw HttpException(
          'Failed to update feedback: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error updating feedback: $e');
    }
  }

  /// Delete feedback
  /// DELETE /api/feedbacks/{id}
  Future<void> deleteFeedback(int feedbackId) async {
    try {
      final response = await _httpClient.delete(
        '/api/feedbacks/$feedbackId',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpException(
          'Failed to delete feedback: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting feedback: $e');
    }
  }

  /// Get feedbacks by course ID with pagination
  /// GET /api/feedbacks/course/{courseId}
  Future<FeedbackListResponse> getFeedbacksByCourseId(
    int courseId, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _httpClient.get(
        '/api/feedbacks/course/$courseId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FeedbackListResponse.fromJson(data);
      } else {
        throw HttpException(
          'Failed to get feedbacks: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error getting feedbacks: $e');
    }
  }

  /// Get average rating for a course
  Future<double> getAverageRating(int courseId) async {
    try {
      final feedbacks = await getFeedbacksByCourseId(courseId, size: 100);
      
      if (feedbacks.content.isEmpty) {
        return 0.0;
      }

      final totalRating = feedbacks.content.fold<int>(
        0,
        (sum, feedback) => sum + feedback.rating,
      );

      return totalRating / feedbacks.content.length;
    } catch (e) {
      return 0.0;
    }
  }
}
