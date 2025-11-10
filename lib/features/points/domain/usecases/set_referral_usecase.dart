import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/set_referral_command.dart';
import '../repositories/points_repository.dart';

class SetReferralUseCase implements UseCase<bool, SetReferralCommand> {
  final PointsRepository repository;

  SetReferralUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SetReferralCommand params) {
    return repository.setReferral(params);
  }
}
