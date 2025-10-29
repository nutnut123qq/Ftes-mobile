import 'package:flutter/material.dart';
import '../../../../../utils/text_styles.dart';
import '../../../domain/entities/part.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/entities/exercise.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';
import 'part_section_widget.dart';

/// Widget for displaying course curriculum
class CourseCurriculumWidget extends StatelessWidget {
  final List<Part> parts;
  final String courseId;
  final String courseTitle;
  final Function(Exercise) onExerciseTap;
  final Function(Lesson) onLessonContentTap;

  const CourseCurriculumWidget({
    super.key,
    required this.parts,
    required this.courseId,
    required this.courseTitle,
    required this.onExerciseTap,
    required this.onLessonContentTap,
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
            CourseConstants.titleCurriculum,
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: CourseUIConstants.spacingLarge),
          ...parts.map((part) => PartSectionWidget(
                part: part,
                courseId: courseId,
                courseTitle: courseTitle,
                onExerciseTap: onExerciseTap,
                onLessonContentTap: onLessonContentTap,
              )),
        ],
      ),
    );
  }
}

