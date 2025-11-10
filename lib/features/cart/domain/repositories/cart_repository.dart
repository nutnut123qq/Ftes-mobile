import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_summary.dart';

/// Abstract repository interface for Cart feature
abstract class CartRepository {
  /// Add course to cart
  Future<Either<Failure, bool>> addToCart(String courseId);

  /// Get cart items with pagination
  Future<Either<Failure, CartSummary>> getCartItems({
    int pageNumber = 1,
    int pageSize = 10,
    String? sortField,
    String sortOrder = 'ASC',
  });

  /// Get cart count
  Future<Either<Failure, int>> getCartCount();

  /// Remove item from cart
  Future<Either<Failure, bool>> removeFromCart(String cartItemId);
}
