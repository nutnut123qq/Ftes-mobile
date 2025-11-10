import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import '../entities/feedback.dart';
import '../entities/feedback_page.dart';

/// Repository cho tính năng feedback
abstract class FeedbackRepository {
  Future<Either<Failure, FeedbackPage>> getFeedbacks({
    required int courseId,
    int page,
    int size,
  });

  Future<Either<Failure, FeedbackEntity>> createFeedback({
    required int userId,
    required int courseId,
    required int rating,
    required String comment,
  });

  Future<Either<Failure, FeedbackEntity>> updateFeedback({
    required int feedbackId,
    required int rating,
    required String comment,
  });

  Future<Either<Failure, bool>> deleteFeedback({required int feedbackId});

  Future<Either<Failure, double>> getAverageRating({
    required int courseId,
    int sampleSize,
  });
}
