import 'dart:convert';
import '../models/cart_response.dart';
import '../utils/api_constants.dart';
import 'http_client.dart';

/// Cart Service để xử lý các API liên quan đến giỏ hàng
class CartService {
  final HttpClient _http = HttpClient();

  CartService() {
    _http.initialize();
  }

  /// Add course to cart
  /// [courseId] - ID của khóa học cần thêm vào giỏ
  /// Returns true nếu thành công
  Future<bool> addToCart(String courseId) async {
    try {
      final request = AddToCartRequest(courseId: courseId);
      
      final resp = await _http.post(
        ApiConstants.cartEndpoint,
        body: request.toJson(),
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return true;
      }

      // Check for specific error messages
      final data = jsonDecode(resp.body);
      final message = data['messageDTO']?['message'] ?? 'Failed to add to cart';
      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  /// Get all cart items with pagination
  /// [pageNumber] - Trang hiện tại (default: 1)
  /// [pageSize] - Số lượng items mỗi trang (default: 10)
  /// [sortField] - Field để sort (optional)
  /// [sortOrder] - Thứ tự sort: 'ASC' hoặc 'DESC' (default: 'ASC')
  Future<PagingCartItemResponse> getCartItems({
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

      final resp = await _http.get(
        ApiConstants.cartEndpoint,
        queryParameters: queryParams,
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body);
        
        // Handle response wrapping
        final resultData = data['result'] ?? data['data'] ?? data;
        
        return PagingCartItemResponse.fromJson(resultData);
      }

      throw Exception('Failed to load cart items: ${resp.statusCode}');
    } catch (e) {
      throw Exception('Failed to load cart items: $e');
    }
  }

  /// Count cart items
  /// Returns số lượng items trong giỏ hàng
  Future<int> countCart() async {
    try {
      final resp = await _http.get(ApiConstants.cartCountEndpoint);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body);
        
        // Handle response wrapping
        final count = data['result'] ?? data['data'] ?? 0;
        
        return count is int ? count : int.tryParse(count.toString()) ?? 0;
      }

      throw Exception('Failed to count cart items: ${resp.statusCode}');
    } catch (e) {
      throw Exception('Failed to count cart items: $e');
    }
  }

  /// Remove item from cart
  /// [cartItemId] - ID của cart item cần xóa
  /// Returns true nếu thành công
  Future<bool> removeCartItem(String cartItemId) async {
    try {
      final resp = await _http.delete(
        '${ApiConstants.cartEndpoint}/$cartItemId',
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return true;
      }

      // Check for specific error messages
      final data = jsonDecode(resp.body);
      final message = data['messageDTO']?['message'] ?? 'Failed to remove cart item';
      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to remove cart item: $e');
    }
  }

  /// Calculate cart totals with optional coupon
  /// [couponCode] - Mã giảm giá (optional)
  /// Returns CartTotalResponse với thông tin tổng tiền, giảm giá
  Future<CartTotalResponse> calculateCartTotal({String? couponCode}) async {
    try {
      final queryParams = couponCode != null && couponCode.isNotEmpty
          ? {'couponName': couponCode}
          : null;

      final resp = await _http.get(
        ApiConstants.cartTotalEndpoint,
        queryParameters: queryParams,
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body);
        
        // Handle response wrapping
        final resultData = data['result'] ?? data['data'] ?? data;
        
        return CartTotalResponse.fromJson(resultData);
      }

      throw Exception('Failed to calculate cart total: ${resp.statusCode}');
    } catch (e) {
      throw Exception('Failed to calculate cart total: $e');
    }
  }

  /// Clear all items in cart (by removing them one by one)
  /// Useful khi checkout thành công
  Future<bool> clearCart() async {
    try {
      // Get all cart items
      final cartItems = await getCartItems(pageSize: 100); // Get all items
      
      if (cartItems.data == null || cartItems.data!.isEmpty) {
        return true;
      }

      // Remove each item
      for (final item in cartItems.data!) {
        if (item.id != null) {
          await removeCartItem(item.id!);
        }
      }

      return true;
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}
