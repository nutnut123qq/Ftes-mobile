import 'package:flutter/material.dart';
import '../../../../../core/utils/text_styles.dart';
import '../../../../../routes/app_routes.dart';
import '../../../domain/entities/lesson.dart';

class LessonItem extends StatelessWidget {
  final Lesson lesson;
  final bool isEnrolled;
  final VoidCallback onLockedTap;
  final VoidCallback onOpen;

  const LessonItem({
    super.key,
    required this.lesson,
    required this.isEnrolled,
    required this.onLockedTap,
    required this.onOpen,
  });

  IconData _iconForType(String? type) {
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
    return GestureDetector(
      onTap: () => isEnrolled ? onOpen() : onLockedTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              _iconForType(lesson.type),
              color: const Color(0xFF666666),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (lesson.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      lesson.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF666666),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // AI Chat icon - only show for enrolled users and VIDEO lessons
            if (isEnrolled && lesson.type == 'VIDEO')
              GestureDetector(
                onTap: () {
                  AppRoutes.navigateToAiChat(
                    context,
                    lessonId: lesson.id,
                    lessonTitle: lesson.title,
                    videoId: lesson.video, // Video ID for HLS streaming
                    lessonDescription: lesson.description, // Lesson description
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0961F5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Color(0xFF0961F5),
                    size: 18,
                  ),
                ),
              ),
            if (!isEnrolled)
              const Icon(
                Icons.lock_outline,
                color: Color(0xFF999999),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}





