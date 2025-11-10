import 'package:flutter/material.dart';
import '../../../../core/utils/text_styles.dart';
import '../constants/course_ui_constants.dart';

class BenefitsSection extends StatelessWidget {
  final List<String> benefits;

  const BenefitsSection({super.key, required this.benefits});

  @override
  Widget build(BuildContext context) {
    final items = benefits.isNotEmpty ? benefits : ['Kiến thức cơ bản', 'Thực hành', 'Tư duy giải quyết vấn đề'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: CourseUiConstants.horizontalMargin),
      padding: const EdgeInsets.all(CourseUiConstants.cardPadding),
      decoration: BoxDecoration(
        color: CourseUiConstants.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: CourseUiConstants.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bạn sẽ học được gì', style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...items.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF00C851), size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(b, style: AppTextStyles.bodyMedium)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}





