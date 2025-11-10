import 'package:flutter/material.dart';
import '../../../../utils/text_styles.dart';
import '../constants/course_ui_constants.dart';

class EnrollButton extends StatelessWidget {
  final bool isEnrolled;
  final bool isLoading;
  final double price;
  final VoidCallback onTap;

  const EnrollButton({
    super.key,
    required this.isEnrolled,
    required this.isLoading,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(CourseUiConstants.horizontalMargin),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: CourseUiConstants.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CourseUiConstants.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  isEnrolled
                      ? 'Vào học'
                      : (price > 0 ? 'Thêm vào giỏ hàng' : 'Tham gia miễn phí'),
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}




