import 'package:flutter/material.dart';
import '../../../../core/utils/text_styles.dart';
import '../constants/course_ui_constants.dart';
import '../../domain/entities/course_detail.dart';

class CourseInfoCard extends StatelessWidget {
  final CourseDetail? courseDetail;
  final String fallbackTitle;
  final String fallbackCategory;
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CourseInfoCard({
    super.key,
    required this.courseDetail,
    required this.fallbackTitle,
    required this.fallbackCategory,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final title = courseDetail?.title ?? fallbackTitle;
    final category = courseDetail?.categoryName ?? fallbackCategory;
    final totalLessons = courseDetail?.parts.fold<int>(0, (sum, p) => sum + p.lessons.length) ?? 0;
    final price = courseDetail?.salePrice ?? courseDetail?.totalPrice;

    return Container(
      margin: const EdgeInsets.all(CourseUiConstants.horizontalMargin),
      padding: const EdgeInsets.all(CourseUiConstants.cardPadding),
      decoration: BoxDecoration(
        color: CourseUiConstants.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: CourseUiConstants.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.heading2.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF0961F5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFB800), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    courseDetail?.avgStar.toStringAsFixed(1) ?? '0',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(Icons.people, color: Color(0xFF666666), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${courseDetail?.totalUser ?? 0} học viên',
                    style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF666666)),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(Icons.play_circle_outline, color: Color(0xFF666666), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$totalLessons bài học',
                    style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF666666)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (price != null && price > 0) ...[
                Text(
                  _formatPrice(price),
                  style: AppTextStyles.heading3.copyWith(
                    color: const Color(0xFF0961F5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                Text(
                  'Miễn phí',
                  style: AppTextStyles.heading3.copyWith(
                    color: const Color(0xFF00C851),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                final isSelected = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTabSelected(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        tab,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? const Color(0xFF0961F5) : const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    final str = price.toStringAsFixed(0);
    return '${str.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}đ';
  }
}


