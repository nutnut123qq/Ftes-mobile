import 'package:flutter/foundation.dart';
import '../models/feedback_response.dart';
import '../models/create_feedback_request.dart';
import '../models/update_feedback_request.dart';
import '../services/feedback_service.dart';

class FeedbackProvider with ChangeNotifier {
  final FeedbackService _feedbackService = FeedbackService();

  // State for feedback list
  List<FeedbackResponse> _feedbacks = [];
  List<FeedbackResponse> get feedbacks => _feedbacks;

  // Pagination state
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  bool _hasMore = true;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  bool get hasMore => _hasMore;

  // Loading states
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isSubmitting = false;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isSubmitting => _isSubmitting;

  // Error state
  String? _error;
  String? get error => _error;

  // Current course average rating
  double _averageRating = 0.0;
  double get averageRating => _averageRating;

  /// Load feedbacks for a course with pagination
  Future<void> loadFeedbacks(int courseId, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _feedbacks.clear();
      _hasMore = true;
    }

    if (_isLoading || _isLoadingMore || !_hasMore) return;

    try {
      if (_currentPage == 0) {
        _isLoading = true;
        _error = null;
      } else {
        _isLoadingMore = true;
      }
      notifyListeners();

      final response = await _feedbackService.getFeedbacksByCourseId(
        courseId,
        page: _currentPage,
        size: 10,
      );

      if (_currentPage == 0) {
        _feedbacks = response.content;
      } else {
        _feedbacks.addAll(response.content);
      }

      _totalPages = response.totalPages;
      _totalElements = response.totalElements;
      _hasMore = !response.last;

      if (_hasMore) {
        _currentPage++;
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error loading feedbacks: $e');
      }
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Load average rating for a course
  Future<void> loadAverageRating(int courseId) async {
    try {
      _averageRating = await _feedbackService.getAverageRating(courseId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading average rating: $e');
      }
    }
  }

  /// Create a new feedback
  Future<bool> createFeedback(CreateFeedbackRequest request) async {
    try {
      _isSubmitting = true;
      _error = null;
      notifyListeners();

      final newFeedback = await _feedbackService.createFeedback(request);
      
      // Add to beginning of list
      _feedbacks.insert(0, newFeedback);
      _totalElements++;
      
      // Recalculate average rating
      await loadAverageRating(request.courseId);

      _isSubmitting = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      
      if (kDebugMode) {
        print('Error creating feedback: $e');
      }
      return false;
    }
  }

  /// Update existing feedback
  Future<bool> updateFeedback(
    int feedbackId,
    UpdateFeedbackRequest request,
    int courseId,
  ) async {
    try {
      _isSubmitting = true;
      _error = null;
      notifyListeners();

      final updatedFeedback = await _feedbackService.updateFeedback(
        feedbackId,
        request,
      );

      // Update in list
      final index = _feedbacks.indexWhere((f) => f.id == feedbackId);
      if (index != -1) {
        _feedbacks[index] = updatedFeedback;
      }

      // Recalculate average rating
      await loadAverageRating(courseId);

      _isSubmitting = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      
      if (kDebugMode) {
        print('Error updating feedback: $e');
      }
      return false;
    }
  }

  /// Delete feedback
  Future<bool> deleteFeedback(int feedbackId, int courseId) async {
    try {
      _error = null;
      notifyListeners();

      await _feedbackService.deleteFeedback(feedbackId);

      // Remove from list
      _feedbacks.removeWhere((f) => f.id == feedbackId);
      _totalElements--;

      // Recalculate average rating
      await loadAverageRating(courseId);

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      
      if (kDebugMode) {
        print('Error deleting feedback: $e');
      }
      return false;
    }
  }

  /// Clear all data
  void clear() {
    _feedbacks.clear();
    _currentPage = 0;
    _totalPages = 0;
    _totalElements = 0;
    _hasMore = true;
    _isLoading = false;
    _isLoadingMore = false;
    _isSubmitting = false;
    _error = null;
    _averageRating = 0.0;
    notifyListeners();
  }
}
