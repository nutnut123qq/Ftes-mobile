import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart' as order_entity;
import '../entities/order_summary.dart';

/// Repository interface for Order feature
abstract class OrderRepository {
  /// Create a new order
  Future<Either<Failure, order_entity.Order>> createOrder({
    required List<String> courseIds,
    String? couponName,
    bool usePoint = false,
  });

  /// Get order by ID
  Future<Either<Failure, OrderSummary>> getOrderById(String orderId);

  /// Get all orders for current user
  Future<Either<Failure, List<OrderSummary>>> getAllOrders();

  /// Cancel all pending orders
  Future<Either<Failure, bool>> cancelPendingOrders();
}
