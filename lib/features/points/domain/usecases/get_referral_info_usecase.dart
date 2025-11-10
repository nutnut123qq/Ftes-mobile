import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/referral_info.dart';
import '../repositories/points_repository.dart';

class GetReferralInfoUseCase implements UseCase<ReferralInfo, NoParams> {
  final PointsRepository repository;

  GetReferralInfoUseCase(this.repository);

  @override
  Future<Either<Failure, ReferralInfo>> call(NoParams params) {
    return repository.getReferralInfo();
  }
}
