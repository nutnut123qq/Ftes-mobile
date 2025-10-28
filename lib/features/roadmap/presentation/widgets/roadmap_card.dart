import 'package:flutter/material.dart';
import '../../domain/entities/roadmap.dart';
import '../../../../core/constants/app_constants.dart';

class RoadmapCard extends StatelessWidget {
  final RoadmapSkill skill;
  const RoadmapCard({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasCourse = skill.slugName.isNotEmpty;
    
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
          Text(skill.skill,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(skill.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
          const SizedBox(height: 8),
          Text(
            'Học kỳ ${skill.term}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                side: BorderSide(
                  color: hasCourse ? const Color(0xFF265DFF) : Colors.grey,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: hasCourse ? () {
                // Navigate to Course Detail page with slug
                Navigator.pushNamed(
                  context,
                  AppConstants.routeCourseDetail,
                  arguments: skill.slugName,
                );
              } : null,
              child: Text(
                hasCourse ? 'Xem khóa học' : 'Sắp có khóa học',
                style: TextStyle(
                  color:
                  hasCourse ? const Color(0xFF265DFF) : Colors.grey,
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
