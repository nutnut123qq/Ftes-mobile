import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../entities/point_transaction.dart';
import '../repositories/points_repository.dart';

class GetPointTransactionsUseCase
    implements UseCase<List<PointTransaction>, GetPointTransactionsParams> {
  final PointsRepository repository;

  GetPointTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PointTransaction>>> call(
    GetPointTransactionsParams params,
  ) async {
    return repository.getTransactions(page: params.page, size: params.size);
  }
}

class GetPointTransactionsParams {
  final int page;
  final int size;

  GetPointTransactionsParams({this.page = 0, this.size = 20});
}
