import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../repositories/feedback_repository.dart';

class DeleteFeedbackUseCase implements UseCase<bool, DeleteFeedbackParams> {
  final FeedbackRepository repository;

  DeleteFeedbackUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteFeedbackParams params) async {
    return repository.deleteFeedback(feedbackId: params.feedbackId);
  }
}

class DeleteFeedbackParams {
  final int feedbackId;

  DeleteFeedbackParams({required this.feedbackId});
}
