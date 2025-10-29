import 'package:flutter/material.dart';
import '../../../../../utils/text_styles.dart';
import '../../../domain/entities/exercise.dart';
import '../../../domain/constants/course_ui_constants.dart';

/// Widget for displaying an exercise item
class ExerciseItemWidget extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseItemWidget({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: CourseUIConstants.lessonItemPaddingHorizontal,
          vertical: CourseUIConstants.lessonItemPaddingVertical,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.quiz_outlined,
              color: Color(0xFF666666),
              size: CourseUIConstants.iconSizeLarge,
            ),
            const SizedBox(width: CourseUIConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (exercise.description.isNotEmpty) ...[
                    const SizedBox(height: CourseUIConstants.spacingTiny),
                    Text(
                      exercise.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

