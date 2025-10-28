import 'package:flutter/material.dart';
import '../../domain/entities/roadmap.dart';

class RoadmapCard extends StatelessWidget {
  final RoadmapStep step;
  const RoadmapCard({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(112),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step.title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(step.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                side: BorderSide(
                  color: step.hasCourse ? const Color(0xFF265DFF) : Colors.grey,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: step.hasCourse ? () {} : null,
              child: Text(
                step.hasCourse ? step.buttonLabel ?? 'Xem khóa học' : 'Sắp có khóa học',
                style: TextStyle(
                  color:
                  step.hasCourse ? const Color(0xFF265DFF) : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
