import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/points_summary.dart';
import '../repositories/points_repository.dart';

class GetPointsSummaryUseCase implements UseCase<PointsSummary, NoParams> {
  final PointsRepository repository;

  GetPointsSummaryUseCase(this.repository);

  @override
  Future<Either<Failure, PointsSummary>> call(NoParams params) async {
    return repository.getPointsSummary();
  }
}
