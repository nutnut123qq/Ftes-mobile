import 'package:flutter/material.dart';
import '../../../../core/utils/text_styles.dart';
import '../constants/course_ui_constants.dart';

class DescriptionSection extends StatelessWidget {
  final String description;

  const DescriptionSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CourseUiConstants.horizontalMargin,
        vertical: 16,
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
            style: AppTextStyles.bodyMedium.copyWith(
              color: CourseUiConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}





