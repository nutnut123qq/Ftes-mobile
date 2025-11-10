import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/feedback.dart';
import '../repositories/feedback_repository.dart';

class UpdateFeedbackUseCase
    implements UseCase<FeedbackEntity, UpdateFeedbackParams> {
  final FeedbackRepository repository;

  UpdateFeedbackUseCase(this.repository);

  @override
  Future<Either<Failure, FeedbackEntity>> call(
    UpdateFeedbackParams params,
  ) async {
    return repository.updateFeedback(
      feedbackId: params.feedbackId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class UpdateFeedbackParams {
  final int feedbackId;
  final int rating;
  final String comment;

  UpdateFeedbackParams({
    required this.feedbackId,
    required this.rating,
    required this.comment,
  });
}
