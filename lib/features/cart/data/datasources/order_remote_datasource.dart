import '../models/order_model.dart';
import '../models/order_summary_model.dart';

/// Abstract remote data source interface for Order feature
abstract class OrderRemoteDataSource {
  /// Create new order
  Future<OrderModel> createOrder({
    required List<String> courseIds,
    String? couponName,
    bool usePoint = false,
  });

  /// Get order by ID
  Future<OrderSummaryModel> getOrderById(String orderId);

  /// Get all orders for current user
  Future<List<OrderSummaryModel>> getAllOrders();

  /// Cancel pending orders
  Future<bool> cancelPendingOrders();
}
