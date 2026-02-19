import 'package:flutter/material.dart';
import '../../../../../core/utils/text_styles.dart';
import '../../../domain/entities/part.dart';
import '../../../domain/entities/lesson.dart';

typedef LessonItemBuilder = Widget Function(Lesson lesson);

class PartSection extends StatelessWidget {
  final Part part;
  final bool isExpanded;
  final VoidCallback onToggle;
  final LessonItemBuilder buildLessonItem;

  const PartSection({
    super.key,
    required this.part,
    required this.isExpanded,
    required this.onToggle,
    required this.buildLessonItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: const Color(0xFF666666),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${part.name} - ${part.description}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[const Divider(height: 1), ..._buildLessons()],
        ],
      ),
    );
  }

  List<Widget> _buildLessons() {
    final sortedLessons =
        part.lessons.where((l) => l.type != 'EXERCISE').toList()
          ..sort((a, b) => a.order.compareTo(b.order));
    return sortedLessons.map((l) => buildLessonItem(l)).toList();
  }
}
