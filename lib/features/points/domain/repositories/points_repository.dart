import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import '../entities/invited_user.dart';
import '../entities/point_transaction.dart';
import '../entities/points_chart.dart';
import '../entities/points_summary.dart';
import '../entities/referral_info.dart';
import '../entities/referral_stats.dart';
import '../entities/set_referral_command.dart';
import '../entities/withdraw_points_command.dart';

abstract class PointsRepository {
  Future<Either<Failure, PointsSummary>> getPointsSummary();
  Future<Either<Failure, List<PointTransaction>>> getTransactions({
    int page,
    int size,
  });
  Future<Either<Failure, ReferralInfo>> getReferralInfo();
  Future<Either<Failure, ReferralStats>> getReferralStats();
  Future<Either<Failure, List<InvitedUser>>> getInvitedUsers({
    int page,
    int size,
  });
  Future<Either<Failure, PointsChart>> getPointsChart();
  Future<Either<Failure, bool>> withdrawPoints(WithdrawPointsCommand command);
  Future<Either<Failure, bool>> setReferral(SetReferralCommand command);
}
