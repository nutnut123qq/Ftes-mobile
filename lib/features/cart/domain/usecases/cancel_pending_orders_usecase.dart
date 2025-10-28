import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/order_repository.dart';

/// Use case to cancel pending orders
class CancelPendingOrdersUseCase implements UseCase<bool, NoParams> {
  final OrderRepository repository;

  CancelPendingOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.cancelPendingOrders();
  }
}



