import 'package:flutter/material.dart';
import '../models/cart_response.dart';
import '../services/cart_service.dart';

/// Provider to manage shopping cart state
class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  // Cart items
  List<CartItemResponse> _cartItems = [];
  List<CartItemResponse> get cartItems => _cartItems;

  // Cart count
  int _cartCount = 0;
  int get cartCount => _cartCount;

  // Cart total information
  CartTotalResponse? _cartTotal;
  CartTotalResponse? get cartTotal => _cartTotal;

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAddingToCart = false;
  bool get isAddingToCart => _isAddingToCart;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  // Track which courses are in cart (for UI state)
  final Set<String> _courseIdsInCart = {};
  Set<String> get courseIdsInCart => _courseIdsInCart;

  /// Check if a course is in cart
  bool isCourseInCart(String courseId) {
    return _courseIdsInCart.contains(courseId);
  }

  /// Add course to cart
  Future<bool> addToCart(String courseId) async {
    try {
      _isAddingToCart = true;
      _errorMessage = null;
      notifyListeners();

      final success = await _cartService.addToCart(courseId);
      
      if (success) {
        _courseIdsInCart.add(courseId);
        // Refresh cart count and items
        await Future.wait([
          loadCartCount(),
          loadCartItems(),
        ]);
      }

      _isAddingToCart = false;
      notifyListeners();
      
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isAddingToCart = false;
      notifyListeners();
      return false;
    }
  }

  /// Remove item from cart
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Find the item before removing to get courseId
      final itemToRemove = _cartItems.firstWhere(
        (item) => item.id == cartItemId,
        orElse: () => CartItemResponse(),
      );
      final courseIdToRemove = itemToRemove.courseId;

      final success = await _cartService.removeCartItem(cartItemId);
      
      if (success) {
        // Remove from local list
        _cartItems.removeWhere((item) => item.id == cartItemId);
        
        // Remove course ID from tracking set
        if (courseIdToRemove != null) {
          _courseIdsInCart.remove(courseIdToRemove);
        }

        // Refresh cart count and total
        await Future.wait([
          loadCartCount(),
          loadCartTotal(),
        ]);
      }

      _isLoading = false;
      notifyListeners();
      
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load cart items (with pagination)
  Future<void> loadCartItems({int pageNumber = 1, int pageSize = 20}) async {
    try {
      if (pageNumber == 1) {
        _isLoading = true;
        _cartItems = [];
        _courseIdsInCart.clear();
      }
      
      _errorMessage = null;
      notifyListeners();

      final response = await _cartService.getCartItems(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      if (pageNumber == 1) {
        _cartItems = response.data ?? [];
      } else {
        _cartItems.addAll(response.data ?? []);
      }

      // Update tracking set
      for (var item in _cartItems) {
        if (item.courseId != null) {
          _courseIdsInCart.add(item.courseId!);
        }
      }

      _currentPage = pageNumber;
      _totalPages = response.totalPage ?? 1;
      _hasMore = _currentPage < _totalPages;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more cart items
  Future<void> loadMoreCartItems() async {
    if (!_hasMore || _isLoading) return;
    await loadCartItems(pageNumber: _currentPage + 1);
  }

  /// Load cart count
  Future<void> loadCartCount() async {
    try {
      _cartCount = await _cartService.countCart();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load cart total with optional coupon
  Future<void> loadCartTotal({String? couponCode}) async {
    try {
      _cartTotal = await _cartService.calculateCartTotal(
        couponCode: couponCode,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Clear entire cart
  Future<bool> clearCart() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await _cartService.clearCart();
      
      if (success) {
        _cartItems = [];
        _courseIdsInCart.clear();
        _cartCount = 0;
        _cartTotal = null;
      }

      _isLoading = false;
      notifyListeners();
      
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Refresh all cart data
  Future<void> refreshCart() async {
    await Future.wait([
      loadCartItems(),
      loadCartCount(),
      loadCartTotal(),
    ]);
  }

  /// Initialize cart (call when app starts)
  Future<void> initializeCart() async {
    await Future.wait([
      loadCartItems(),
      loadCartCount(),
    ]);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
