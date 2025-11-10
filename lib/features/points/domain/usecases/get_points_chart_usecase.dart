import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/points_chart.dart';
import '../repositories/points_repository.dart';

class GetPointsChartUseCase implements UseCase<PointsChart, NoParams> {
  final PointsRepository repository;

  GetPointsChartUseCase(this.repository);

  @override
  Future<Either<Failure, PointsChart>> call(NoParams params) {
    return repository.getPointsChart();
  }
}
