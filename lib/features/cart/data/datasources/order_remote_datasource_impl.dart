import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/order_model.dart';
import '../models/order_summary_model.dart';
import '../models/create_order_request_model.dart';
import 'order_remote_datasource.dart';

/// Remote data source implementation for Order feature
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient _apiClient;

  OrderRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<OrderModel> createOrder({
    required List<String> courseIds,
    String? couponName,
    bool usePoint = false,
  }) async {
    try {
      print('📦 Creating order with ${courseIds.length} courses');

      final request = CreateOrderRequestModel(
        courseIds: courseIds,
        couponName: couponName,
        usePoint: usePoint,
      );

      final response = await _apiClient.post(
        AppConstants.orderEndpoint,
        data: request.toJson(),
      );

      print('📥 Create order response status: ${response.statusCode}');
      print('📥 Create order response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          final result = data['result'] ?? data['data'] ?? data;
          print('📥 Parsed order result: $result');
          return OrderModel.fromJson(result);
        }
        throw ServerException(
          data?['messageDTO']?['message'] ?? 'Failed to create order',
        );
      } else {
        throw ServerException(
          response.data?['messageDTO']?['message'] ??
              'Failed to create order',
        );
      }
    } catch (e) {
      print('❌ Create order error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to create order: ${e.toString()}');
    }
  }

  @override
  Future<OrderSummaryModel> getOrderById(String orderId) async {
    try {
      print('📦 Getting order by ID: $orderId');

      if (orderId.isEmpty) {
        throw ValidationException('Order ID cannot be empty');
      }

      final endpoint = '${AppConstants.orderEndpoint}/$orderId';
      final response = await _apiClient.get(endpoint);

      print('📥 Get order by ID response status: ${response.statusCode}');
      print('📥 Get order by ID response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          final result = data['result'] ?? data['data'] ?? data;
          return OrderSummaryModel.fromJson(result);
        }
        throw ServerException(
          data?['messageDTO']?['message'] ?? 'Failed to get order',
        );
      } else {
        throw ServerException(
          response.data?['messageDTO']?['message'] ?? 'Failed to get order',
        );
      }
    } catch (e) {
      print('❌ Get order by ID error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to get order: ${e.toString()}');
    }
  }

  @override
  Future<List<OrderSummaryModel>> getAllOrders() async {
    try {
      print('📦 Getting all orders');

      final response = await _apiClient.get(AppConstants.orderEndpoint);

      print('📥 Get all orders response status: ${response.statusCode}');
      print('📥 Get all orders response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          final result = data['result'] ?? data['data'] ?? data;
          if (result is List) {
            return result
                .map((json) => OrderSummaryModel.fromJson(json))
                .toList();
          }
        }
        throw ServerException(
          data?['messageDTO']?['message'] ?? 'Invalid response format',
        );
      } else {
        throw ServerException(
          response.data?['messageDTO']?['message'] ?? 'Failed to get orders',
        );
      }
    } catch (e) {
      print('❌ Get all orders error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to get orders: ${e.toString()}');
    }
  }

  @override
  Future<bool> cancelPendingOrders() async {
    try {
      print('📦 Canceling pending orders');

      final response = await _apiClient.delete(
        AppConstants.orderCancelEndpoint,
      );

      print('📥 Cancel pending orders response status: ${response.statusCode}');
      print('📥 Cancel pending orders response data: ${response.data}');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException(
          response.data?['messageDTO']?['message'] ??
              'Failed to cancel orders',
        );
      }
    } catch (e) {
      print('❌ Cancel pending orders error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to cancel orders: ${e.toString()}');
    }
  }
}
