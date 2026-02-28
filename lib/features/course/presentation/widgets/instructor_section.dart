import 'package:flutter/material.dart';
import '../../../../core/utils/text_styles.dart';
import '../constants/course_ui_constants.dart';
import '../../../../core/utils/image_cache_helper.dart';

class InstructorSection extends StatelessWidget {
  final String instructorName;
  final String title;
  final String about;
  final String? avatarUrl;

  const InstructorSection({
    super.key,
    required this.instructorName,
    required this.title,
    required this.about,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CourseUiConstants.horizontalMargin,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giảng viên',
            style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if ((avatarUrl ?? '').isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: ImageCacheHelper.cached(
                      avatarUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if ((avatarUrl ?? '').isNotEmpty) const SizedBox(width: 12),
              Expanded(
                child: Text(
                  instructorName,
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: CourseUiConstants.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            about,
            style: AppTextStyles.bodyMedium.copyWith(
              color: CourseUiConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}


