import 'package:flutter/material.dart';
import '../../../../utils/text_styles.dart';
import '../constants/course_ui_constants.dart';

class ReviewsSection extends StatelessWidget {
  final double rating;
  final int totalReviews;

  const ReviewsSection({super.key, required this.rating, required this.totalReviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: CourseUiConstants.horizontalMargin),
      padding: const EdgeInsets.all(CourseUiConstants.cardPadding),
      decoration: BoxDecoration(
        color: CourseUiConstants.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: CourseUiConstants.cardShadow,
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Color(0xFFFFB800), size: 24),
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text('($totalReviews đánh giá)', style: AppTextStyles.bodyMedium.copyWith(color: CourseUiConstants.textSecondary)),
        ],
      ),
    );
  }
}


