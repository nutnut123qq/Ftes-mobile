import 'package:flutter/material.dart';
import '../../../../core/utils/text_styles.dart';
import '../../domain/entities/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;
  final bool isRemoving;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    this.isRemoving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: cartItem.courseImage.isNotEmpty
                ? Image.network(
                    cartItem.courseImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  )
                : _buildPlaceholderImage(),
          ),
          
          const SizedBox(width: 12),
          
          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.courseName,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  cartItem.course.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF666666),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Rating and Level
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.amber[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      cartItem.course.avgStar.toStringAsFixed(1),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0961F5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        cartItem.course.level,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF0961F5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Price
                Row(
                  children: [
                    if (cartItem.discountPercentage > 0) ...[
                      Text(
                        '${cartItem.price.toStringAsFixed(0)}đ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF999999),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '${cartItem.finalPrice.toStringAsFixed(0)}đ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF0961F5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (cartItem.discountPercentage > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${cartItem.discountPercentage.toStringAsFixed(0)}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Remove Button
          IconButton(
            onPressed: isRemoving ? null : onRemove,
            icon: isRemoving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 24,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.school,
        color: Color(0xFF0961F5),
        size: 32,
      ),
    );
  }
}
