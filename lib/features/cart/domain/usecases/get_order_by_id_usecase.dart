import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order_summary.dart';
import '../../domain/repositories/order_repository.dart';

/// Use case to get order by ID
class GetOrderByIdUseCase implements UseCase<OrderSummary, GetOrderByIdParams> {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  @override
  Future<Either<Failure, OrderSummary>> call(GetOrderByIdParams params) async {
    return await repository.getOrderById(params.orderId);
  }
}

/// Parameters for get order by ID use case
class GetOrderByIdParams {
  final String orderId;

  GetOrderByIdParams(this.orderId);
}


