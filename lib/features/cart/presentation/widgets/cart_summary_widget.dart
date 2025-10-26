import 'package:flutter/material.dart';
import '../../../../utils/text_styles.dart';
import '../../domain/entities/cart_item.dart';

class CartSummaryWidget extends StatelessWidget {
  final List<CartItem> cartItems;
  final VoidCallback? onCheckout;

  const CartSummaryWidget({
    super.key,
    required this.cartItems,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.finalPrice);
    final totalDiscount = cartItems.fold(0.0, (sum, item) => sum + (item.price - item.finalPrice));
    final itemCount = cartItems.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Item Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng số khóa học:',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF666666),
                ),
              ),
              Text(
                '$itemCount khóa học',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          
          if (totalDiscount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiết kiệm:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF666666),
                  ),
                ),
                Text(
                  '-${totalDiscount.toStringAsFixed(0)}đ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 8),
          
          // Divider
          Container(
            height: 1,
            color: const Color(0xFFE9ECEF),
          ),
          
          const SizedBox(height: 8),
          
          // Total Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng:',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              Text(
                '${totalPrice.toStringAsFixed(0)}đ',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0961F5),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Checkout Button
          if (onCheckout != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0961F5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Thanh toán',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
