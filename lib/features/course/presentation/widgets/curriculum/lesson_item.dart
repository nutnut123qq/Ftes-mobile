import 'package:flutter/material.dart';
import '../../../../../utils/text_styles.dart';
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




