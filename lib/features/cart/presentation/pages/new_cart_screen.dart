import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/text_styles.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary_widget.dart';
import '../../../../core/di/injection_container.dart' as di;

/// New Cart Screen using clean architecture cart module
class NewCartScreen extends StatefulWidget {
  const NewCartScreen({super.key});

  @override
  State<NewCartScreen> createState() => _NewCartScreenState();
}

class _NewCartScreenState extends State<NewCartScreen> {
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    // Cart data will be loaded in Consumer builder
  }

  @override
  void dispose() {
    // Cleanup if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<CartViewModel>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF0961F5),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Giỏ hàng',
            style: AppTextStyles.heading3.copyWith(
              color: const Color(0xFF0961F5),
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<CartViewModel>(
          builder: (context, viewModel, child) {
            // Load cart data on first build only
            if (!_hasLoadedData && !viewModel.isLoading) {
              _hasLoadedData = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  viewModel.loadCartItems();
                  viewModel.loadCartCount();
                }
              });
            }
            
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0961F5),
                ),
              );
            }

            if (viewModel.cartItems.isEmpty) {
              return _buildEmptyCart();
            }

            return Column(
              children: [
                // Cart Items List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = viewModel.cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CartItemWidget(
                          cartItem: item,
                          onRemove: () => viewModel.removeFromCart(item.cartItemId),
                        ),
                      );
                    },
                  ),
                ),
                
                // Cart Summary
                CartSummaryWidget(
                  cartItems: viewModel.cartItems,
                  onCheckout: () => _handleCheckout(viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleCheckout(CartViewModel viewModel) {
    if (viewModel.cartItems.isEmpty) return;
    
    // TODO: Navigate to checkout screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng thanh toán đang được phát triển'),
        backgroundColor: Color(0xFF0961F5),
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
            'Giỏ hàng trống',
            style: AppTextStyles.heading3.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thêm khóa học vào giỏ hàng để tiếp tục',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0961F5),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Tiếp tục mua sắm',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
