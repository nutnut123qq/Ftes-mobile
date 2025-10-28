import 'package:flutter/material.dart';
import '../../domain/entities/roadmap.dart';
import 'roadmap_card.dart';

class RoadmapTimeline extends StatelessWidget {
  final List<RoadmapStep> steps;
  const RoadmapTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isLast = i == steps.length - 1;

        return Column(
          children: [
            // --- Dot & line ---
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.hasCourse ? const Color(0xFF265DFF) : Colors.white,
                    border: Border.all(color: const Color(0xFF265DFF), width: 3),
                  ),
                  child: step.hasCourse
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                if (!isLast) ...[
                  Container(
                    width: 2,
                    height: 50,
                    color: Colors.blue.withAlpha(56),
                  ),
                  Icon(Icons.arrow_downward,
                      size: 14, color: Colors.blue.withAlpha(68)),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // --- Card ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RoadmapCard(step: step),
            ),

            const SizedBox(height: 32),
          ],
        );
      }),
    );
  }
}
