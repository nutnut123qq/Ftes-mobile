import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order.dart' as order_entity;
import '../../domain/repositories/order_repository.dart';

/// Use case to create a new order
class CreateOrderUseCase implements UseCase<order_entity.Order, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, order_entity.Order>> call(CreateOrderParams params) async {
    return await repository.createOrder(
      courseIds: params.courseIds,
      couponName: params.couponName,
      usePoint: params.usePoint,
    );
  }
}

/// Parameters for create order use case
class CreateOrderParams {
  final List<String> courseIds;
  final String? couponName;
  final bool usePoint;

  CreateOrderParams({
    required this.courseIds,
    this.couponName,
    this.usePoint = false,
  });
}
