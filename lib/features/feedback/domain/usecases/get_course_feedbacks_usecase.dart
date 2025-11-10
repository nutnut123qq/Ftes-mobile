import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/feedback_page.dart';
import '../repositories/feedback_repository.dart';

class GetCourseFeedbacksUseCase
    implements UseCase<FeedbackPage, GetCourseFeedbacksParams> {
  final FeedbackRepository repository;

  GetCourseFeedbacksUseCase(this.repository);

  @override
  Future<Either<Failure, FeedbackPage>> call(
    GetCourseFeedbacksParams params,
  ) async {
    return repository.getFeedbacks(
      courseId: params.courseId,
      page: params.page,
      size: params.size,
    );
  }
}

class GetCourseFeedbacksParams {
  final int courseId;
  final int page;
  final int size;

  GetCourseFeedbacksParams({
    required this.courseId,
    this.page = 0,
    this.size = 10,
  });
}
