import 'package:flutter/material.dart';
import '../../../../core/utils/text_styles.dart';
import '../constants/course_ui_constants.dart';
import '../../domain/entities/course_detail.dart';

class CourseInfoCard extends StatelessWidget {
  final CourseDetail? courseDetail;
  final String fallbackTitle;
  final String fallbackCategory;

  const CourseInfoCard({
    super.key,
    required this.courseDetail,
    required this.fallbackTitle,
    required this.fallbackCategory,
  });

  @override
  Widget build(BuildContext context) {
    final title = courseDetail?.title ?? fallbackTitle;
    final category = courseDetail?.categoryName ?? fallbackCategory;
    final totalLessons =
        courseDetail?.parts.fold<int>(0, (sum, p) => sum + p.lessons.length) ??
        0;
    final price = courseDetail?.salePrice ?? courseDetail?.totalPrice;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CourseUiConstants.horizontalMargin,
        vertical: CourseUiConstants.cardPadding,
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
          Text(
            category,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF0961F5),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (price != null && price > 0)
            Text(
              _formatPrice(price),
              style: AppTextStyles.heading3.copyWith(
                color: const Color(0xFF0961F5),
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Text(
              'Miễn phí',
              style: AppTextStyles.heading3.copyWith(
                color: const Color(0xFF00C851),
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFB800), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    courseDetail?.avgStar.toStringAsFixed(1) ?? '0',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people, color: Color(0xFF666666), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${courseDetail?.totalUser ?? 0} học viên',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_circle_outline,
                    color: Color(0xFF666666),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$totalLessons bài học',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    final str = price.toStringAsFixed(0);
    // ignore: deprecated_member_use
    return '${str.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}đ';
  }
}
