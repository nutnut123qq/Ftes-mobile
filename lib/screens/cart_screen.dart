import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/providers/cart_provider.dart';
import 'package:ftes/providers/enrollment_provider.dart';
import 'package:ftes/models/cart_response.dart';
import 'package:ftes/services/order_service.dart';
import 'package:ftes/routes/app_routes.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  final OrderService _orderService = OrderService();
  bool _isCreatingOrder = false;
  
  double _getCheckoutSectionHeight(CartProvider cartProvider) {
    // Approximate height: coupon row + spacing + summary + spacing + button + padding
    return 280; // Adjusted for checkout section content
  }

  @override
  void initState() {
    super.initState();
    // Load cart data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).refreshCart();
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            final cartItems = cartProvider.cartItems;
            final isLoading = cartProvider.isLoading;
            
            return Stack(
              children: [
                // Cart Items List
                Column(
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
                              : _buildCartItems(cartItems),
                    ),
                    
                    // Spacer for checkout section
                    if (cartItems.isNotEmpty) 
                      SizedBox(height: _getCheckoutSectionHeight(cartProvider)),
                  ],
                ),
                
                // Checkout Section (floating at bottom)
                if (cartItems.isNotEmpty) 
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildCheckoutSection(cartProvider),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF202244),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Giỏ hàng của tôi',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (hasItems)
            GestureDetector(
              onTap: _clearCart,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Xóa tất cả',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF0961F5),
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Giỏ hàng của bạn trống',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm một số khóa học để bắt đầu',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF545454),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0961F5),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Duyệt khóa học',
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(List<CartItemResponse> cartItems) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<CartProvider>(context, listen: false).refreshCart();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return _buildCartItem(item);
        },
      ),
    );
  }

  Widget _buildCartItem(CartItemResponse item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course Image
          GestureDetector(
            onTap: () {
              if (item.courseSlug != null) {
                Navigator.pushNamed(
                  context,
                  '/course-detail',
                  arguments: item.courseSlug,
                );
              }
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.courseImage != null && item.courseImage!.isNotEmpty
                    ? Image.network(
                        item.courseImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.play_circle_outline,
                            color: Color(0xFF0961F5),
                            size: 40,
                          );
                        },
                      )
                    : const Icon(
                        Icons.play_circle_outline,
                        color: Color(0xFF0961F5),
                        size: 40,
                      ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.courseTitle ?? 'Untitled Course',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Instructor name
                if (item.instructorName != null)
                  Text(
                    'Giảng viên: ${item.instructorName}',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF545454),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 8),
                
                // Price section
                Text(
                  '\$${item.finalPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF0961F5),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          
          // Remove Button
          GestureDetector(
            onTap: () => _removeItem(item),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(CartProvider cartProvider) {
    final cartItems = cartProvider.cartItems;
    final cartTotal = cartProvider.cartTotal;
    
    // Calculate totals from cart items if cartTotal is not available
    final totalPrice = cartTotal?.total ?? 
        cartItems.fold<double>(0.0, (sum, item) => sum + item.finalPrice);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Coupon Code Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mã giảm giá',
                    hintStyle: AppTextStyles.body1.copyWith(
                      color: const Color(0xFFB4BDC4),
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8F1FF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8F1FF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF0961F5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (_couponController.text.trim().isNotEmpty) {
                    _applyCoupon(_couponController.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0961F5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Áp dụng',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Price Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng (${cartItems.length} mục)',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${totalPrice.toStringAsFixed(0)}',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF0961F5),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isCreatingOrder ? null : _proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0961F5),
                disabledBackgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isCreatingOrder
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Tiến hành thanh toán',
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyCoupon(String couponCode) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.loadCartTotal(couponCode: couponCode);
    
    if (cartProvider.errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(cartProvider.errorMessage!),
            backgroundColor: const Color(0xFFF44336),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã áp dụng mã giảm giá'),
            backgroundColor: Color(0xFF4CAF50),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _removeItem(CartItemResponse item) async {
    if (item.id == null) return;
    
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final success = await cartProvider.removeFromCart(item.id!);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa "${item.courseTitle}" khỏi giỏ hàng'),
          backgroundColor: const Color(0xFF4CAF50),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cartProvider.errorMessage ?? 'Không thể xóa khóa học'),
          backgroundColor: const Color(0xFFF44336),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Xóa giỏ hàng',
          style: AppTextStyles.heading1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa tất cả mục khỏi giỏ hàng?',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF545454),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              final success = await cartProvider.clearCart();
              
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa tất cả khóa học khỏi giỏ hàng'),
                    backgroundColor: Color(0xFF4CAF50),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (!success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(cartProvider.errorMessage ?? 'Không thể xóa giỏ hàng'),
                    backgroundColor: const Color(0xFFF44336),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(
              'Xóa',
              style: AppTextStyles.body1.copyWith(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _proceedToCheckout() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final enrollmentProvider = Provider.of<EnrollmentProvider>(context, listen: false);
    final cartItems = cartProvider.cartItems;
    
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng trống')),
      );
      return;
    }
    
    setState(() {
      _isCreatingOrder = true;
    });
    
    try {
      // Trước khi tạo đơn mới, hủy mọi đơn đang pending để tránh trạng thái sai
      try {
        await _orderService.cancelPendingOrders();
      } catch (_) {
        // Bỏ qua lỗi hủy nếu có, tiếp tục tạo đơn mới
      }

      // Get course IDs from cart
      final courseIds = cartItems
          .map((item) => item.courseId)
          .where((id) => id != null)
          .cast<String>()
          .toList();
      
      // Clear enrollment cache for courses in cart to ensure fresh check
      for (final courseId in courseIds) {
        await enrollmentProvider.refreshEnrollmentStatus(courseId);
      }
      
      // Get coupon code if entered
      final couponCode = _couponController.text.trim().isNotEmpty
          ? _couponController.text.trim()
          : null;
      
      // Create order
      final orderResponse = await _orderService.createOrder(
        courseIds: courseIds,
        couponCode: couponCode,
      );
      
      setState(() {
        _isCreatingOrder = false;
      });
      
      // Navigate to payment screen with orderId and qrCodeUrl
      if (orderResponse.orderId != null && orderResponse.orderId!.isNotEmpty) {
        if (!mounted) return;
        AppRoutes.navigateToPayment(
          context, 
          orderId: orderResponse.orderId!,
          qrCodeUrl: orderResponse.qrCodeUrl,
          description: orderResponse.description,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tạo đơn hàng. Vui lòng thử lại.')),
        );
      }
    } catch (e) {
      setState(() {
        _isCreatingOrder = false;
      });
      
      if (!mounted) return;
      
      // Extract clean error message
      String errorMessage = 'Không thể tạo đơn hàng. Vui lòng thử lại.';
      if (e.toString().contains('course bought')) {
        errorMessage = 'Bạn đã mua khóa học này rồi!';
      } else {
        final match = RegExp(r'Exception: (.+)$').firstMatch(e.toString());
        if (match != null) {
          errorMessage = match.group(1) ?? errorMessage;
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
