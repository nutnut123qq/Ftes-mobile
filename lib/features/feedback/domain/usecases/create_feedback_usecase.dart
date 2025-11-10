import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/feedback.dart';
import '../repositories/feedback_repository.dart';

class CreateFeedbackUseCase
    implements UseCase<FeedbackEntity, CreateFeedbackParams> {
  final FeedbackRepository repository;

  CreateFeedbackUseCase(this.repository);

  @override
  Future<Either<Failure, FeedbackEntity>> call(
    CreateFeedbackParams params,
  ) async {
    return repository.createFeedback(
      userId: params.userId,
      courseId: params.courseId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class CreateFeedbackParams {
  final int userId;
  final int courseId;
  final int rating;
  final String comment;

  CreateFeedbackParams({
    required this.userId,
    required this.courseId,
    required this.rating,
    required this.comment,
  });
}
