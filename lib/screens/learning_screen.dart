import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';

class LearningScreen extends StatelessWidget {
  final String lessonId;
  final String categoryId;

  const LearningScreen({
    super.key,
    required this.lessonId,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: AppConstants.iconXXL, color: AppColors.primary),
            const SizedBox(height: AppConstants.spacingM),
            const Text('Learning Screen', style: AppTextStyles.h3),
            const SizedBox(height: AppConstants.spacingS),
            Text('Lesson ID: $lessonId', style: AppTextStyles.bodyMedium),
            Text('Category ID: $categoryId', style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppConstants.spacingS),
            const Text('Coming Soon...', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
