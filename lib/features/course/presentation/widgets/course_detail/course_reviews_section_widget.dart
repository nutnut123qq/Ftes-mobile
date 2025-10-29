import 'package:flutter/material.dart';
import '../../../../../utils/text_styles.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';

/// Widget for displaying course reviews section
class CourseReviewsSectionWidget extends StatelessWidget {
  final double avgStar;
  final int totalUser;

  const CourseReviewsSectionWidget({
    super.key,
    required this.avgStar,
    required this.totalUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: CourseUIConstants.sectionMargin),
      padding: const EdgeInsets.all(CourseUIConstants.sectionPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(CourseUIConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(CourseUIConstants.shadowOpacity),
            blurRadius: CourseUIConstants.shadowBlurRadius,
            offset: const Offset(0, CourseUIConstants.shadowOffset),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CourseConstants.titleReviews,
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: CourseUIConstants.spacingLarge),
          Row(
            children: [
              Text(
                avgStar.toStringAsFixed(1),
                style: AppTextStyles.heading2.copyWith(
                  color: const Color(0xFF0961F5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: CourseUIConstants.spacingSmall),
              ...List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: index < avgStar.round()
                      ? const Color(0xFFFFB800)
                      : const Color(0xFFE0E0E0),
                  size: CourseUIConstants.iconSizeMedium,
                );
              }),
              const SizedBox(width: CourseUIConstants.spacingSmall),
              Text(
                '($totalUser ${CourseConstants.labelReviews})',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

