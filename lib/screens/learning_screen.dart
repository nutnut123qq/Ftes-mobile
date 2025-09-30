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
        title: const Text('Học tập', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: AppConstants.iconXXL, color: AppColors.primary),
            const SizedBox(height: AppConstants.spacingM),
            const Text('Màn hình học tập', style: AppTextStyles.h3),
            const SizedBox(height: AppConstants.spacingS),
            Text('ID Bài học: $lessonId', style: AppTextStyles.bodyMedium),
            Text('ID Danh mục: $categoryId', style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppConstants.spacingS),
            const Text('Sắp ra mắt...', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
