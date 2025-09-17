import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import '../routes/app_routes.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: AppConstants.iconXXL, color: AppColors.primary),
            SizedBox(height: AppConstants.spacingM),
            Text('Categories Screen', style: AppTextStyles.h3),
            SizedBox(height: AppConstants.spacingS),
            Text('Coming Soon...', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
