import 'package:flutter/material.dart';
import '../../../../../core/utils/text_styles.dart';
import '../../../domain/entities/exercise.dart';

class ExerciseItem extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onOpen;

  const ExerciseItem({super.key, required this.exercise, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.quiz_outlined,
              color: Color(0xFF666666),
              size: 20,
            ),
            const SizedBox(width: 12),
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
                    const SizedBox(height: 2),
                    Text(
                      exercise.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Color(0xFF666666),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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





