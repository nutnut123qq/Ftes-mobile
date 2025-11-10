import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/withdraw_points_command.dart';
import '../repositories/points_repository.dart';

class WithdrawPointsUseCase implements UseCase<bool, WithdrawPointsCommand> {
  final PointsRepository repository;

  WithdrawPointsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(WithdrawPointsCommand params) {
    return repository.withdrawPoints(params);
  }
}
