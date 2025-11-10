import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/exceptions.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/network/network_info.dart';
import '../../domain/constants/points_constants.dart';
import '../../domain/entities/invited_user.dart';
import '../../domain/entities/point_transaction.dart';
import '../../domain/entities/points_chart.dart';
import '../../domain/entities/points_summary.dart';
import '../../domain/entities/referral_info.dart';
import '../../domain/entities/referral_stats.dart';
import '../../domain/entities/set_referral_command.dart';
import '../../domain/entities/withdraw_points_command.dart';
import '../../domain/repositories/points_repository.dart';
import '../datasources/points_remote_datasource.dart';
import '../models/withdraw_points_request_model.dart';

class PointsRepositoryImpl implements PointsRepository {
  final PointsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PointsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PointsSummary>> getPointsSummary() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(PointsConstants.errorLoadSummary));
      }
      final model = await remoteDataSource.getPointsSummary();
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(_mapException(e, PointsConstants.errorLoadSummary));
    }
  }

  @override
  Future<Either<Failure, List<PointTransaction>>> getTransactions({
    int page = 0,
    int size = 20,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(
          NetworkFailure(PointsConstants.errorLoadTransactions),
        );
      }
      final models = await remoteDataSource.getTransactions(
        page: page,
        size: size,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on AppException catch (e) {
      return Left(_mapException(e, PointsConstants.errorLoadTransactions));
    }
  }

  @override
  Future<Either<Failure, ReferralInfo>> getReferralInfo() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(PointsConstants.errorLoadReferral));
      }
      final model = await remoteDataSource.getReferralInfo();
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(_mapException(e, PointsConstants.errorLoadReferral));
    }
  }

  @override
  Future<Either<Failure, ReferralStats>> getReferralStats() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(PointsConstants.errorLoadReferral));
      }
      final model = await remoteDataSource.getReferralStats();
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(_mapException(e, PointsConstants.errorLoadReferral));
    }
  }

  @override
  Future<Either<Failure, List<InvitedUser>>> getInvitedUsers({
    int page = 0,
    int size = 20,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(
          NetworkFailure(PointsConstants.errorLoadInvitedUsers),
        );
      }
      final models = await remoteDataSource.getInvitedUsers(
        page: page,
        size: size,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on AppException catch (e) {
      return Left(_mapException(e, PointsConstants.errorLoadInvitedUsers));
    }
  }

  @override
  Future<Either<Failure, PointsChart>> getPointsChart() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(PointsConstants.errorLoadChart));
      }
      final model = await remoteDataSource.getPointsChart();
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(_mapException(e, PointsConstants.errorLoadChart));
    }
  }

  @override
  Future<Either<Failure, bool>> withdrawPoints(
    WithdrawPointsCommand command,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(PointsConstants.errorWithdraw));
      }
      final ok = await remoteDataSource.withdrawPoints(
        WithdrawPointsRequestModel(
          amount: command.amount,
          bankAccount: command.bankAccount,
          bankName: command.bankName,
        ),
      );
      return Right(ok);
    } on AppException catch (e) {
      return Left(_mapException(e, PointsConstants.errorWithdraw));
    }
  }

  @override
  Future<Either<Failure, bool>> setReferral(SetReferralCommand command) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(PointsConstants.errorSetReferral));
      }
      final ok = await remoteDataSource.setReferral(command.referralCode);
      return Right(ok);
    } on AppException catch (e) {
      return Left(_mapException(e, PointsConstants.errorSetReferral));
    }
  }

  Failure _mapException(AppException e, String fallback) {
    if (e is NetworkException) return NetworkFailure(e.message);
    if (e is ValidationException) return ValidationFailure(e.message);
    if (e is AuthException) return AuthFailure(e.message);
    return ServerFailure(e.message.isNotEmpty ? e.message : fallback);
  }
}
