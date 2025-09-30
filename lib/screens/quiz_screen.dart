import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';

class QuizScreen extends StatelessWidget {
  final String quizId;
  final String categoryId;

  const QuizScreen({
    super.key,
    required this.quizId,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài kiểm tra', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz, size: AppConstants.iconXXL, color: AppColors.secondary),
            const SizedBox(height: AppConstants.spacingM),
            const Text('Màn hình bài kiểm tra', style: AppTextStyles.h3),
            const SizedBox(height: AppConstants.spacingS),
            Text('ID Bài kiểm tra: $quizId', style: AppTextStyles.bodyMedium),
            Text('ID Danh mục: $categoryId', style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppConstants.spacingS),
            const Text('Sắp ra mắt...', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
