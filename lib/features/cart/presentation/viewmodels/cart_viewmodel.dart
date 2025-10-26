import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_summary.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/get_cart_count_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/constants/cart_constants.dart';
import '../../../../core/usecases/usecase.dart';

/// ViewModel for Cart feature
class CartViewModel extends ChangeNotifier {
  final AddToCartUseCase _addToCartUseCase;
  final GetCartItemsUseCase _getCartItemsUseCase;
  final GetCartCountUseCase _getCartCountUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;

  CartViewModel({
    required AddToCartUseCase addToCartUseCase,
    required GetCartItemsUseCase getCartItemsUseCase,
    required GetCartCountUseCase getCartCountUseCase,
    required RemoveFromCartUseCase removeFromCartUseCase,
  }) : _addToCartUseCase = addToCartUseCase,
       _getCartItemsUseCase = getCartItemsUseCase,
       _getCartCountUseCase = getCartCountUseCase,
       _removeFromCartUseCase = removeFromCartUseCase;

  // State
  List<CartItem> _cartItems = [];
  int _cartCount = 0;
  bool _isLoading = false;
  bool _isAddingToCart = false;
  bool _isRemovingFromCart = false;
  String? _errorMessage;
  String? _successMessage;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  // Track which courses are in cart (for UI state)
  final Set<String> _courseIdsInCart = {};

  // Getters
  List<CartItem> get cartItems => _cartItems;
  int get cartCount => _cartCount;
  bool get isLoading => _isLoading;
  bool get isAddingToCart => _isAddingToCart;
  bool get isRemovingFromCart => _isRemovingFromCart;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get hasMore => _hasMore;
  Set<String> get courseIdsInCart => _courseIdsInCart;

  /// Check if a course is in cart
  bool isCourseInCart(String courseId) {
    return _courseIdsInCart.contains(courseId);
  }

  /// Add course to cart
  Future<bool> addToCart(String courseId) async {
    try {
      _isAddingToCart = true;
      _clearMessages();
      notifyListeners();

      final params = AddToCartParams(courseId: courseId);
      final result = await _addToCartUseCase(params);
      
      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (success) {
          if (success) {
            _courseIdsInCart.add(courseId);
            _setSuccess(CartConstants.addToCartSuccess);
            // Update cart count locally instead of calling API
            _cartCount = _cartCount + 1;
            notifyListeners();
          }
          return success;
        },
      );
    } finally {
      _isAddingToCart = false;
      notifyListeners();
    }
  }

  /// Remove item from cart
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      _isRemovingFromCart = true;
      _clearMessages();
      notifyListeners();

      // Find the item before removing to get courseId
      final itemToRemove = _cartItems.firstWhere(
        (item) => item.cartItemId == cartItemId,
        orElse: () => CartItem(
          cartItemId: '',
          courseId: '',
          courseName: '',
          courseImage: '',
          price: 0,
          salePrice: 0,
          createdAt: '',
          course: CourseInfo(
            id: '',
            title: '',
            totalPrice: 0,
            salePrice: 0,
            imageHeader: '',
            createdBy: '',
            slugName: '',
            avgStar: 0,
            description: '',
            level: '',
          ),
        ),
      );

      final params = RemoveFromCartParams(cartItemId: cartItemId);
      final result = await _removeFromCartUseCase(params);
      
      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (success) {
          if (success) {
            // Remove from local list
            _cartItems.removeWhere((item) => item.cartItemId == cartItemId);
            
            // Remove course ID from tracking set
            _courseIdsInCart.remove(itemToRemove.courseId);

            _setSuccess(CartConstants.removeFromCartSuccess);
            // Update cart count locally instead of calling API
            _cartCount = _cartCount > 0 ? _cartCount - 1 : 0;
            notifyListeners();
          }
          return success;
        },
      );
    } finally {
      _isRemovingFromCart = false;
      notifyListeners();
    }
  }

  /// Load cart items with pagination
  Future<void> loadCartItems({
    int pageNumber = 1,
    int pageSize = CartConstants.defaultPageSize,
    String? sortField,
    String sortOrder = CartConstants.defaultSortOrder,
  }) async {
    try {
      if (pageNumber == 1) {
        _setLoading(true);
        _cartItems = [];
        _courseIdsInCart.clear();
      }
      
      _clearMessages();
      notifyListeners();

      final params = GetCartItemsParams(
        pageNumber: pageNumber,
        pageSize: pageSize,
        sortField: sortField,
        sortOrder: sortOrder,
      );
      
      final result = await _getCartItemsUseCase(params);
      
      result.fold(
        (failure) => _setError(failure.message),
        (cartSummary) {
          if (pageNumber == 1) {
            _cartItems = cartSummary.items;
          } else {
            _cartItems.addAll(cartSummary.items);
          }

          // Update tracking set
          for (var item in _cartItems) {
            _courseIdsInCart.add(item.courseId);
          }

          _currentPage = cartSummary.currentPage;
          _totalPages = cartSummary.totalPages;
          _hasMore = _currentPage < _totalPages;
        },
      );
    } finally {
      _setLoading(false);
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
      final result = await _getCartCountUseCase(NoParams());
      
      result.fold(
        (failure) => _setError(failure.message),
        (count) => _cartCount = count,
      );
    } catch (e) {
      _setError('Failed to load cart count: $e');
    }
    notifyListeners();
  }

  /// Refresh all cart data
  Future<void> refreshCart() async {
    await Future.wait([
      loadCartItems(),
      loadCartCount(),
    ]);
  }

  /// Initialize cart (call when app starts)
  Future<void> initializeCart() async {
    await Future.wait([
      loadCartItems(),
      loadCartCount(),
    ]);
  }

  /// Clear entire cart
  Future<bool> clearCart() async {
    try {
      _setLoading(true);
      _clearMessages();
      notifyListeners();

      // Remove each item
      final List<String> cartItemIds = _cartItems.map((item) => item.cartItemId).toList();
      
      for (final cartItemId in cartItemIds) {
        await removeFromCart(cartItemId);
      }

      _cartItems = [];
      _courseIdsInCart.clear();
      _cartCount = 0;

      return true;
    } catch (e) {
      _setError('Failed to clear cart: $e');
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String error) {
    _errorMessage = error;
    _successMessage = null;
  }

  void _setSuccess(String success) {
    _successMessage = success;
    _errorMessage = null;
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear success message
  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  /// Clear all data
  void clear() {
    _cartItems = [];
    _courseIdsInCart.clear();
    _cartCount = 0;
    _isLoading = false;
    _isAddingToCart = false;
    _isRemovingFromCart = false;
    _errorMessage = null;
    _successMessage = null;
    _currentPage = 1;
    _totalPages = 1;
    _hasMore = true;
    notifyListeners();
  }

  @override
  void dispose() {
    // Cleanup any resources if needed
    super.dispose();
  }
}
