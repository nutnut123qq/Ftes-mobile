import 'dart:convert';
import '../models/order_response.dart';
import '../core/constants/app_constants.dart';
import 'http_client.dart';

/// Order Service để xử lý các API liên quan đến đơn hàng
class OrderService {
  final HttpClient _http = HttpClient();

  OrderService() {
    _http.initialize();
  }

  /// Create new order
  /// [courseIds] - Danh sách ID của các khóa học cần mua
  /// [couponCode] - Mã giảm giá (optional)
  /// Returns OrderResponse với thông tin đơn hàng đã tạo
  Future<OrderResponse> createOrder({
    required List<String> courseIds,
    String? couponCode,
  }) async {
    try {
      final request = OrderRequest(
        courseIds: courseIds,
        couponCode: couponCode,
      );

      final resp = await _http.post(
        AppConstants.orderEndpoint,
        body: request.toJson(),
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body);
        
        // Check if backend returned error message despite 200 status
        if (data['success'] == false || 
            (data['messageDTO']?['message'] != null && 
             data['messageDTO']['message'].toString().toLowerCase().contains('failed'))) {
          final message = data['messageDTO']?['message'] ?? 'Failed to create order';
          throw Exception(message);
        }
        
        // Handle response wrapping
        final resultData = data['result'] ?? data['data'] ?? data;
        
        return OrderResponse.fromJson(resultData);
      }

      // Check for specific error messages
      final data = jsonDecode(resp.body);
      final message = data['messageDTO']?['message'] ?? 'Failed to create order';
      throw Exception(message);
    } catch (e) {
      // Re-throw without wrapping if it's already an Exception with message
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to create order: $e');
    }
  }

  /// Get all orders for current user
  /// Returns danh sách tất cả đơn hàng của người dùng
  Future<List<OrderViewResponse>> getAllOrders() async {
    try {
      final resp = await _http.get(
        AppConstants.orderEndpoint,
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body);
        
        // Handle response wrapping
        final resultData = data['result'] ?? data['data'] ?? data;
        
        if (resultData is List) {
          return resultData
              .map((json) => OrderViewResponse.fromJson(json))
              .toList();
        }

        throw Exception('Invalid response format');
      }

      throw Exception('Failed to load orders: ${resp.statusCode}');
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  /// Get order by ID
  /// [orderId] - ID của đơn hàng
  /// Returns OrderViewResponse với thông tin chi tiết đơn hàng
  Future<OrderViewResponse> getOrderById(String orderId) async {
    try {
      if (orderId.isEmpty) {
        throw Exception('Order ID cannot be empty');
      }
      
      final endpoint = '${AppConstants.orderEndpoint}/$orderId';
      final resp = await _http.get(endpoint);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body);
        
        // Handle response wrapping
        final resultData = data['result'] ?? data['data'] ?? data;
        
        return OrderViewResponse.fromJson(resultData);
      }

      throw Exception('Failed to load order: ${resp.statusCode}');
    } catch (e) {
      throw Exception('Failed to load order: $e');
    }
  }

  /// Cancel pending orders
  /// Hủy tất cả đơn hàng đang pending của người dùng
  /// Returns true nếu thành công
  Future<bool> cancelPendingOrders() async {
    try {
      final resp = await _http.delete(
        AppConstants.orderCancelEndpoint,
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return true;
      }

      // Check for specific error messages
      final data = jsonDecode(resp.body);
      final message = data['messageDTO']?['message'] ?? 'Failed to cancel orders';
      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to cancel orders: $e');
    }
  }

  /// Get orders with pagination for admin (requires admin role)
  /// [pageNumber] - Trang hiện tại (default: 1)
  /// [pageSize] - Số lượng items mỗi trang (default: 10)
  /// [sortField] - Field để sort (optional)
  /// [sortOrder] - Thứ tự sort: 'ASC' hoặc 'DESC' (default: 'ASC')
  Future<PagingOrderResponse> getOrdersForAdmin({
    int pageNumber = 1,
    int pageSize = 10,
    String? sortField,
    String sortOrder = 'ASC',
  }) async {
    try {
      final queryParams = {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'sortOrder': sortOrder,
      };

      if (sortField != null && sortField.isNotEmpty) {
        queryParams['sortField'] = sortField;
      }

      final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.orderEndpoint}/admin')
          .replace(queryParameters: queryParams);

      final resp = await _http.get(uri.toString());

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body);
        
        // Handle response wrapping
        final resultData = data['result'] ?? data['data'] ?? data;
        
        return PagingOrderResponse.fromJson(resultData);
      }

      throw Exception('Failed to load orders: ${resp.statusCode}');
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  /// Delete order by admin (requires admin role)
  /// [orderId] - ID của đơn hàng cần xóa
  /// Returns true nếu thành công
  Future<bool> deleteOrderByAdmin(String orderId) async {
    try {
      final resp = await _http.delete(
        '${AppConstants.orderEndpoint}/admin/$orderId',
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return true;
      }

      // Check for specific error messages
      final data = jsonDecode(resp.body);
      final message = data['messageDTO']?['message'] ?? 'Failed to delete order';
      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }
}
