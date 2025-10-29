import 'package:flutter/material.dart';
import '../../../domain/entities/exercise.dart';
import '../../../domain/constants/course_ui_constants.dart';

/// Dialog for displaying exercise details
class ExerciseDialog extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDialog({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(CourseUIConstants.borderRadiusLarge),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        padding: const EdgeInsets.all(CourseUIConstants.cardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const Divider(
              color: Colors.grey,
              height: CourseUIConstants.cardPadding,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: CourseUIConstants.fontSizeHeading3,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: CourseUIConstants.spacingXLarge),
                    _buildInfoSection('Mô tả:', exercise.description),
                    const SizedBox(height: CourseUIConstants.spacingLarge),
                    _buildInfoSection('Yêu cầu:', exercise.question),
                    const SizedBox(height: CourseUIConstants.spacingLarge),
                    _buildInfoSection(
                        'Output mong đợi:', exercise.expectedOutput),
                    const SizedBox(height: CourseUIConstants.spacingLarge),
                    _buildInfoSection('Tiêu chí:', exercise.criteria),
                    const SizedBox(height: CourseUIConstants.spacingLarge),
                    if (exercise.fileExtension.isNotEmpty)
                      _buildInfoSection(
                          'File extension:', exercise.fileExtension),
                    const SizedBox(height: CourseUIConstants.spacingLarge),
                    if (exercise.checkLogic ||
                        exercise.checkPerform ||
                        exercise.checkEdgeCase)
                      _buildCheckOptions(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: CourseUIConstants.spacingLarge),
            const Text(
              'Vui lòng truy cập trang web để nộp bài tập',
              style: TextStyle(
                color: Colors.orange,
                fontSize: CourseUIConstants.fontSizeSmall,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'EXERCISE',
          style: TextStyle(
            color: Colors.white,
            fontSize: CourseUIConstants.fontSizeHeading3,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF0961F5),
            fontSize: CourseUIConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: CourseUIConstants.spacingSmall),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: CourseUIConstants.fontSizeMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Check:',
          style: TextStyle(
            color: Color(0xFF0961F5),
            fontSize: CourseUIConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: CourseUIConstants.spacingSmall),
        if (exercise.checkLogic)
          const Text('  • Logic',
              style: TextStyle(color: Colors.white)),
        if (exercise.checkPerform)
          const Text('  • Performance',
              style: TextStyle(color: Colors.white)),
        if (exercise.checkEdgeCase)
          const Text('  • Edge Case',
              style: TextStyle(color: Colors.white)),
      ],
    );
  }

  static void show(BuildContext context, Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => ExerciseDialog(exercise: exercise),
    );
  }
}

