import '../models/cart_item_model.dart';
import '../models/cart_summary_model.dart';

/// Abstract remote data source interface for Cart feature
abstract class CartRemoteDataSource {
  /// Add course to cart
  Future<bool> addToCart(String courseId);

  /// Get cart items with pagination
  Future<CartSummaryModel> getCartItems({
    int pageNumber = 1,
    int pageSize = 10,
    String? sortField,
    String sortOrder = 'ASC',
  });

  /// Get cart count
  Future<int> getCartCount();

  /// Remove item from cart
  Future<bool> removeFromCart(String cartItemId);
}
