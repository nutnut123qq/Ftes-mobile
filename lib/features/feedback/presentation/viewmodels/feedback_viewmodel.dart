import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/constants/feedback_constants.dart';
import '../../domain/entities/feedback.dart';
import '../../domain/entities/feedback_page.dart';
import '../../domain/usecases/feedback_usecases.dart';

class FeedbackViewModel extends ChangeNotifier {
  final GetCourseFeedbacksUseCase _getCourseFeedbacksUseCase;
  final CreateFeedbackUseCase _createFeedbackUseCase;
  final UpdateFeedbackUseCase _updateFeedbackUseCase;
  final DeleteFeedbackUseCase _deleteFeedbackUseCase;
  final GetAverageRatingUseCase _getAverageRatingUseCase;

  FeedbackViewModel({
    required GetCourseFeedbacksUseCase getCourseFeedbacksUseCase,
    required CreateFeedbackUseCase createFeedbackUseCase,
    required UpdateFeedbackUseCase updateFeedbackUseCase,
    required DeleteFeedbackUseCase deleteFeedbackUseCase,
    required GetAverageRatingUseCase getAverageRatingUseCase,
  }) : _getCourseFeedbacksUseCase = getCourseFeedbacksUseCase,
       _createFeedbackUseCase = createFeedbackUseCase,
       _updateFeedbackUseCase = updateFeedbackUseCase,
       _deleteFeedbackUseCase = deleteFeedbackUseCase,
       _getAverageRatingUseCase = getAverageRatingUseCase;

  List<FeedbackEntity> _feedbacks = [];
  List<FeedbackEntity> get feedbacks => List.unmodifiable(_feedbacks);

  double _averageRating = 0;
  double get averageRating => _averageRating;

  int _currentPage = FeedbackConstants.defaultPageNumber;
  int get currentPage => _currentPage;

  int _totalPages = 0;
  int get totalPages => _totalPages;

  int _totalElements = 0;
  int get totalElements => _totalElements;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int? _currentCourseId;

  Future<void> loadFeedbacks(
    int courseId, {
    bool refresh = false,
    int pageSize = FeedbackConstants.defaultPageSize,
  }) async {
    if (_isLoading || _isLoadingMore) return;

    if (refresh || _currentCourseId != courseId) {
      _resetState();
      _currentCourseId = courseId;
    }

    if (!_hasMore && !refresh) return;

    if (_currentPage == FeedbackConstants.defaultPageNumber) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    _setError(null);
    notifyListeners();

    final result = await _getCourseFeedbacksUseCase(
      GetCourseFeedbacksParams(
        courseId: courseId,
        page: _currentPage,
        size: pageSize,
      ),
    );

    result.fold(
      (failure) => _handleFailure(failure),
      (page) => _handleFeedbackPage(page, append: _currentPage > 0),
    );

    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refresh(int courseId) {
    return loadFeedbacks(courseId, refresh: true);
  }

  Future<void> loadAverageRating(int courseId) async {
    final result = await _getAverageRatingUseCase(
      GetAverageRatingParams(courseId: courseId),
    );

    result.fold(
      (failure) {
        if (kDebugMode) {
          print('⚠️ loadAverageRating error: ${failure.message}');
        }
      },
      (value) {
        _averageRating = value;
        notifyListeners();
      },
    );
  }

  Future<bool> createFeedback({
    required int userId,
    required int courseId,
    required int rating,
    required String comment,
  }) async {
    _isSubmitting = true;
    _setError(null);
    notifyListeners();

    final result = await _createFeedbackUseCase(
      CreateFeedbackParams(
        userId: userId,
        courseId: courseId,
        rating: rating,
        comment: comment,
      ),
    );

    return result.fold(
      (failure) {
        _isSubmitting = false;
        _setError(failure.message);
        notifyListeners();
        return false;
      },
      (feedback) {
        _feedbacks.insert(0, feedback);
        _totalElements++;
        _isSubmitting = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> updateFeedback({
    required int feedbackId,
    required int rating,
    required String comment,
    int? courseId,
  }) async {
    _isSubmitting = true;
    _setError(null);
    notifyListeners();

    final result = await _updateFeedbackUseCase(
      UpdateFeedbackParams(
        feedbackId: feedbackId,
        rating: rating,
        comment: comment,
      ),
    );

    return result.fold(
      (failure) {
        _isSubmitting = false;
        _setError(failure.message);
        notifyListeners();
        return false;
      },
      (feedback) async {
        final index = _feedbacks.indexWhere((item) => item.id == feedbackId);
        if (index != -1) {
          _feedbacks[index] = feedback;
        }
        _isSubmitting = false;
        notifyListeners();

        if (courseId != null) {
          await loadAverageRating(courseId);
        }
        return true;
      },
    );
  }

  Future<bool> deleteFeedback({required int feedbackId, int? courseId}) async {
    _setError(null);
    notifyListeners();

    final result = await _deleteFeedbackUseCase(
      DeleteFeedbackParams(feedbackId: feedbackId),
    );

    return result.fold(
      (failure) {
        _setError(failure.message);
        notifyListeners();
        return false;
      },
      (_) async {
        _feedbacks.removeWhere((item) => item.id == feedbackId);
        if (_totalElements > 0) {
          _totalElements--;
        }
        notifyListeners();
        if (courseId != null) {
          await loadAverageRating(courseId);
        }
        return true;
      },
    );
  }

  void clear() {
    _resetState();
    notifyListeners();
  }

  void _handleFeedbackPage(FeedbackPage page, {bool append = false}) {
    if (append) {
      _feedbacks.addAll(page.items);
    } else {
      _feedbacks = page.items;
    }

    _totalElements = page.totalElements;
    _totalPages = page.totalPages;
    _hasMore = !page.isLast;
    if (_hasMore) {
      _currentPage = page.currentPage + 1;
    }
  }

  void _handleFailure(Failure failure) {
    _setError(failure.message);
    if (kDebugMode) {
      print('❌ FeedbackViewModel failure: ${failure.message}');
    }
  }

  void _setError(String? message) {
    _errorMessage = message;
  }

  void _resetState() {
    _feedbacks = [];
    _averageRating = 0;
    _currentPage = FeedbackConstants.defaultPageNumber;
    _totalPages = 0;
    _totalElements = 0;
    _hasMore = true;
    _isLoading = false;
    _isLoadingMore = false;
    _isSubmitting = false;
    _errorMessage = null;
  }
}
