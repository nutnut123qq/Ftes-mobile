import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/bottom_navigation_bar.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/constants/cart_constants.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Load cart data when screen opens (with caching)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<CartViewModel>(context, listen: false);
      // Use initialize() for cache-first loading
      viewModel.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Consumer<CartViewModel>(
          builder: (context, viewModel, child) {
            final cartItems = viewModel.cartItems;
            final isLoading = viewModel.isLoading;
            final errorMessage = viewModel.errorMessage;
            final successMessage = viewModel.successMessage;
            
            // Show success/error messages
            if (successMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(successMessage),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
                viewModel.clearSuccess();
              });
            }
            
            if (errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
                viewModel.clearError();
              });
            }
            
            return Column(
              children: [
                const SizedBox(height: 20),
                
                // Header
                _buildHeader(cartItems.isNotEmpty),
                
                const SizedBox(height: 20),
                
                // Cart Items or Loading
                Expanded(
                  child: isLoading && cartItems.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0961F5),
                          ),
                        )
                      : cartItems.isEmpty
                          ? _buildEmptyCart()
                          : _buildCartItems(viewModel),
                ),
                
                // Checkout Section
                if (cartItems.isNotEmpty) _buildCheckoutSection(viewModel),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 2),
    );
  }

  Widget _buildHeader(bool hasItems) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF0961F5),
            ),
          ),
          Expanded(
            child:               Text(
                'Giỏ hàng',
                style: AppTextStyles.heading3.copyWith(
                  color: const Color(0xFF0961F5),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
          ),
          if (hasItems)
            Consumer<CartViewModel>(
              builder: (context, viewModel, child) {
                return TextButton(
                  onPressed: () => _showClearCartDialog(context, viewModel),
                  child: Text(
                    'Xóa tất cả',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            CartConstants.emptyCartTitle,
            style: AppTextStyles.heading3.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CartConstants.emptyCartMessage,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppConstants.routeHome),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0961F5),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Khám phá khóa học',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(CartViewModel viewModel) {
    return RefreshIndicator(
      onRefresh: () => viewModel.refreshCart(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: viewModel.cartItems.length + (viewModel.hasMore ? 1 : 0),
        // Add cacheExtent for smoother scrolling
        cacheExtent: 500,
        itemBuilder: (context, index) {
          if (index == viewModel.cartItems.length) {
            // Load more button
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ElevatedButton(
                  onPressed: viewModel.isLoading ? null : () => viewModel.loadMoreCartItems(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0961F5),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Tải thêm',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            );
          }
          
          final cartItem = viewModel.cartItems[index];
          return CartItemWidget(
            cartItem: cartItem,
            onRemove: () => viewModel.removeFromCart(cartItem.cartItemId),
            isRemoving: viewModel.isRemovingFromCart,
          );
        },
      ),
    );
  }

  Widget _buildCheckoutSection(CartViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          CartSummaryWidget(cartItems: viewModel.cartItems),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleCheckout(viewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0961F5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Thanh toán',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa giỏ hàng'),
        content: const Text('Bạn có chắc chắn muốn xóa tất cả khóa học khỏi giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.clearCart();
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckout(CartViewModel viewModel) async {
    try {
      // Create order
      final order = await viewModel.createOrder();
      
      if (order != null && order.orderId != null && order.orderId!.isNotEmpty) {
        // Navigate to payment screen
        if (mounted) {
          Navigator.pushNamed(
            context,
            AppConstants.routePayment,
            arguments: {
              'orderId': order.orderId,
              'qrCodeUrl': order.qrCodeUrl,
              'description': order.description,
            },
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.errorMessage ?? 'Không thể tạo đơn hàng'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}
