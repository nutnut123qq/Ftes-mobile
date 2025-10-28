import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order_summary.dart';
import '../../domain/repositories/order_repository.dart';

/// Use case to get all orders
class GetAllOrdersUseCase implements UseCase<List<OrderSummary>, NoParams> {
  final OrderRepository repository;

  GetAllOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderSummary>>> call(NoParams params) async {
    return await repository.getAllOrders();
  }
}



