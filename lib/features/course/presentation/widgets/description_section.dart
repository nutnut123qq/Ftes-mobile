import 'package:flutter/material.dart';
import '../../../../utils/text_styles.dart';
import '../constants/course_ui_constants.dart';

class DescriptionSection extends StatelessWidget {
  final String description;

  const DescriptionSection({super.key, required this.description});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giới thiệu khóa học',
            style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            description.isNotEmpty ? description : 'Không có mô tả',
            style: AppTextStyles.bodyMedium.copyWith(color: CourseUiConstants.textSecondary),
          ),
        ],
      ),
    );
  }
}


