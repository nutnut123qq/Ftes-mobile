import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/referral_stats.dart';
import '../repositories/points_repository.dart';

class GetReferralStatsUseCase implements UseCase<ReferralStats, NoParams> {
  final PointsRepository repository;

  GetReferralStatsUseCase(this.repository);

  @override
  Future<Either<Failure, ReferralStats>> call(NoParams params) {
    return repository.getReferralStats();
  }
}
