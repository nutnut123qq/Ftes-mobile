import 'package:flutter/material.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/utils/colors.dart';

/// Widget for category filter
class CategoryFilterWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryFilterWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.lightBlue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: AppTextStyles.body1.copyWith(
            color: isSelected ? Colors.white : const Color(0xFF202244),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
