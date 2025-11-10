import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../repositories/feedback_repository.dart';

class GetAverageRatingUseCase
    implements UseCase<double, GetAverageRatingParams> {
  final FeedbackRepository repository;

  GetAverageRatingUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(GetAverageRatingParams params) async {
    return repository.getAverageRating(
      courseId: params.courseId,
      sampleSize: params.sampleSize,
    );
  }
}

class GetAverageRatingParams {
  final int courseId;
  final int sampleSize;

  GetAverageRatingParams({required this.courseId, this.sampleSize = 100});
}
