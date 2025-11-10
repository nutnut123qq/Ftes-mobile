import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';

/// Widget for displaying instructor statistics
class InstructorStatsWidget extends StatelessWidget {
  final int coursesCount;
  final int studentsCount;
  final bool isLoading;

  const InstructorStatsWidget({
    super.key,
    required this.coursesCount,
    required this.studentsCount,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Thống kê',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.school,
                  label: 'Khóa học',
                  value: coursesCount.toString(),
                  color: const Color(0xFF0961F5),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.people,
                  label: 'Học viên',
                  value: studentsCount.toString(),
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.heading2.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
