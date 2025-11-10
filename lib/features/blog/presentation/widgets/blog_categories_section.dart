import 'package:flutter/material.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/text_styles.dart';
import '../../domain/entities/blog_category.dart';
import '../../domain/constants/blog_constants.dart';

/// Blog categories section widget
class BlogCategoriesSection extends StatelessWidget {
  final List<BlogCategory> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const BlogCategoriesSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          BlogConstants.allCategoriesLabel,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // "Tất cả" option
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _CategoryChip(
                  label: BlogConstants.allCategoriesLabel,
                  isSelected: selectedCategory == null,
                  onTap: () => onCategorySelected(null),
                ),
              ),
              // Dynamic categories from API
              ...categories.map((category) {
                final isSelected = selectedCategory == category.name;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CategoryChip(
                    label: category.name,
                    isSelected: isSelected,
                    onTap: () => onCategorySelected(category.name),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
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
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyText.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

