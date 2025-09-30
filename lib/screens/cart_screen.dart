import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample cart items data
  final List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      title: 'Thiết kế UI/UX',
      instructor: 'Alex Maxwell',
      price: 499,
      originalPrice: 799,
      imageUrl: 'https://via.placeholder.com/80x80/000000/FFFFFF?text=UI',
      rating: 4.2,
      students: 7830,
    ),
    CartItem(
      id: '2',
      title: 'Thiết kế đồ họa',
      instructor: 'Sarah Johnson',
      price: 399,
      originalPrice: 599,
      imageUrl: 'https://via.placeholder.com/80x80/000000/FFFFFF?text=GD',
      rating: 4.5,
      students: 5420,
    ),
    CartItem(
      id: '3',
      title: 'Phát triển Web',
      instructor: 'Mike Chen',
      price: 599,
      originalPrice: 899,
      imageUrl: 'https://via.placeholder.com/80x80/000000/FFFFFF?text=WD',
      rating: 4.8,
      students: 12000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Header
            _buildHeader(),
            
            const SizedBox(height: 20),
            
            // Cart Items
            Expanded(
              child: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartItems(),
            ),
            
            // Checkout Section
            if (_cartItems.isNotEmpty) _buildCheckoutSection(),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 2),
    );
  }

  Widget _buildHeader() {
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
          if (_cartItems.isNotEmpty)
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

  Widget _buildCartItems() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        return _buildCartItem(item, index);
      },
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: Color(0xFF0961F5),
              size: 40,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'bởi ${item.instructor}',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.rating}',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${item.students} học viên)',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF545454),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${item.price}',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF0961F5),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹${item.originalPrice}',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF545454),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Remove Button
          GestureDetector(
            onTap: () => _removeItem(index),
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

  Widget _buildCheckoutSection() {
    final totalPrice = _cartItems.fold(0, (sum, item) => sum + item.price);
    final originalTotal = _cartItems.fold(0, (sum, item) => sum + item.originalPrice);
    final savings = originalTotal - totalPrice;

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
          // Price Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng (${_cartItems.length} mục)',
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
                    '₹$totalPrice',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF0961F5),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (savings > 0)
                    Text(
                      'Bạn tiết kiệm ₹$savings',
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
              onPressed: _proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0961F5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
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

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
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
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _cartItems.clear();
              });
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

  void _proceedToCheckout() {
    // Navigate to payment screen
    Navigator.pushNamed(context, '/payment');
  }
}

class CartItem {
  final String id;
  final String title;
  final String instructor;
  final int price;
  final int originalPrice;
  final String imageUrl;
  final double rating;
  final int students;

  CartItem({
    required this.id,
    required this.title,
    required this.instructor,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.rating,
    required this.students,
  });
}
