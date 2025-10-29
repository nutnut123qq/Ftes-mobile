import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../routes/app_routes.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';
import '../../viewmodels/course_detail_viewmodel.dart';

/// Widget for displaying a lesson item
class LessonItemWidget extends StatelessWidget {
  final Lesson lesson;
  final String courseId;
  final String courseTitle;

  const LessonItemWidget({
    super.key,
    required this.lesson,
    required this.courseId,
    required this.courseTitle,
  });

  IconData _getLessonIcon(String? type) {
    switch (type) {
      case 'VIDEO':
        return Icons.play_circle_outline;
      case 'DOCUMENT':
        return Icons.description_outlined;
      case 'EXERCISE':
        return Icons.quiz_outlined;
      default:
        return Icons.play_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseDetailViewModel>(
      builder: (context, viewModel, child) {
        final isEnrolled = viewModel.isEnrolled;

        return GestureDetector(
          onTap: () => _handleTap(context, viewModel, isEnrolled),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: CourseUIConstants.lessonItemPaddingHorizontal,
              vertical: CourseUIConstants.lessonItemPaddingVertical,
            ),
            child: Row(
              children: [
                Icon(
                  _getLessonIcon(lesson.type),
                  color: lesson.isCompleted
                      ? const Color(0xFF00C851)
                      : const Color(0xFF666666),
                  size: CourseUIConstants.iconSizeLarge,
                ),
                const SizedBox(width: CourseUIConstants.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${lesson.title} - ${lesson.description}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: lesson.isCompleted
                              ? const Color(0xFF00C851)
                              : null,
                        ),
                      ),
                      if (lesson.duration > 0) ...[
                        const SizedBox(height: CourseUIConstants.spacingTiny),
                        Text(
                          '${lesson.duration} ${CourseConstants.labelMinutes}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isEnrolled == true) ...[
                  GestureDetector(
                    onTap: () {
                      final videoId = lesson.video.isNotEmpty
                          ? lesson.video
                          : lesson.id;
                      final fullLessonTitle =
                          '${lesson.title} - ${lesson.description}';
                      AppRoutes.navigateToAiChat(
                        context,
                        lessonId: videoId,
                        lessonTitle: fullLessonTitle,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(
                          CourseUIConstants.spacingSmall),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0961F5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                            CourseUIConstants.borderRadiusSmall),
                      ),
                      child: const Icon(
                        Icons.smart_toy,
                        color: Color(0xFF0961F5),
                        size: CourseUIConstants.iconSizeLarge,
                      ),
                    ),
                  ),
                  const SizedBox(width: CourseUIConstants.spacingSmall),
                ],
                if (lesson.isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF00C851),
                    size: CourseUIConstants.iconSizeLarge,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, CourseDetailViewModel viewModel,
      bool? isEnrolled) {
    if (isEnrolled != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(CourseConstants.messageNeedPurchase),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(CourseUIConstants.borderRadiusSmall),
          ),
        ),
      );
      return;
    }

    final courseDetail = viewModel.courseDetail;
    if (courseDetail == null) return;

    if (lesson.video.isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/course-video',
        arguments: {
          'lessonId': lesson.id,
          'lessonTitle': lesson.title,
          'courseTitle': courseTitle,
          'videoUrl': lesson.video,
          'courseId': courseId,
          'type': lesson.type,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(CourseConstants.errorVideoNotAvailable),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(CourseUIConstants.borderRadiusSmall),
          ),
        ),
      );
    }
  }
}

