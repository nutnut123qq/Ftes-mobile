import 'package:flutter/material.dart';
import '../../../../../utils/text_styles.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';

/// Widget for displaying course description section
class CourseDescriptionSectionWidget extends StatelessWidget {
  final String? description;

  const CourseDescriptionSectionWidget({
    super.key,
    this.description,
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
            CourseConstants.titleCourseIntroduction,
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: CourseUIConstants.spacingMedium),
          Text(
            description ?? CourseConstants.defaultDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

