import 'package:flutter/material.dart';
import '../../../../../utils/text_styles.dart';
import '../../../domain/entities/part.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/entities/exercise.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';
import 'lesson_item_widget.dart';
import 'exercise_item_widget.dart';

/// Widget for displaying an expandable part section
class PartSectionWidget extends StatefulWidget {
  final Part part;
  final String courseId;
  final String courseTitle;
  final Function(Exercise) onExerciseTap;
  final Function(Lesson) onLessonContentTap;

  const PartSectionWidget({
    super.key,
    required this.part,
    required this.courseId,
    required this.courseTitle,
    required this.onExerciseTap,
    required this.onLessonContentTap,
  });

  @override
  State<PartSectionWidget> createState() => _PartSectionWidgetState();
}

class _PartSectionWidgetState extends State<PartSectionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CourseUIConstants.spacingMedium),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius:
            BorderRadius.circular(CourseUIConstants.borderRadiusSmall),
      ),
      child: Column(
        children: [
          _buildPartHeader(),
          if (_isExpanded) ...[
            const Divider(height: 1),
            _buildLessons(),
            if (widget.part.exercises.isNotEmpty) ...[
              const Divider(height: 1),
              _buildExercisesHeader(),
              _buildExercises(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildPartHeader() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(CourseUIConstants.partItemPadding),
        child: Row(
          children: [
            Icon(
              _isExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
              color: const Color(0xFF666666),
            ),
            const SizedBox(width: CourseUIConstants.spacingSmall),
            Expanded(
              child: Text(
                '${widget.part.name} - ${widget.part.description}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${widget.part.lessons.length} ${CourseConstants.labelLessons}${widget.part.exercises.isNotEmpty ? ', ${widget.part.exercises.length} bài tập' : ''}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessons() {
    final sortedLessons = widget.part.lessons.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: sortedLessons.map((lesson) {
        // Check if lesson type is not VIDEO
        if (lesson.type != null && lesson.type != 'VIDEO') {
          return ExerciseItemWidget(
            exercise: Exercise(
              id: lesson.id,
              type: lesson.type ?? 'DOCUMENT',
              title: lesson.title,
              description: lesson.description,
              question: lesson.video, // Use video field as content
              expectedOutput: '',
              criteria: '',
              fileExtension: '',
              checkLogic: false,
              checkPerform: false,
              checkEdgeCase: false,
              order: lesson.order,
            ),
            onTap: () => widget.onLessonContentTap(lesson),
          );
        }

        return LessonItemWidget(
          lesson: lesson,
          courseId: widget.courseId,
          courseTitle: widget.courseTitle,
        );
      }).toList(),
    );
  }

  Widget _buildExercisesHeader() {
    return const Padding(
      padding: EdgeInsets.all(CourseUIConstants.spacingMedium),
      child: Text(
        'Bài tập:',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  Widget _buildExercises() {
    final sortedExercises = widget.part.exercises.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: sortedExercises
          .map((exercise) => ExerciseItemWidget(
                exercise: exercise,
                onTap: () => widget.onExerciseTap(exercise),
              ))
          .toList(),
    );
  }
}

