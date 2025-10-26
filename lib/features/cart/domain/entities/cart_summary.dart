import 'package:equatable/equatable.dart';
import 'cart_item.dart';

/// Cart Summary entity representing aggregated cart information
class CartSummary extends Equatable {
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final List<CartItem> items;

  const CartSummary({
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
    required this.items,
  });

  /// Calculate total price of all items
  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.finalPrice);
  }

  /// Calculate total discount amount
  double get totalDiscount {
    return items.fold(0.0, (sum, item) {
      return sum + (item.price - item.finalPrice);
    });
  }

  /// Get total number of items
  int get itemCount => items.length;

  @override
  List<Object?> get props => [
        totalElements,
        totalPages,
        currentPage,
        items,
      ];
}
