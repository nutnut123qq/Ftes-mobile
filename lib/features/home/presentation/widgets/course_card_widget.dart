import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/colors.dart';

/// Widget for displaying course card
class CourseCardWidget extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCardWidget({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final category = course.categoryName ?? 'Chưa phân loại';
    final title = course.title ?? 'Không có tiêu đề';
    final price = course.salePrice != null && course.salePrice! > 0
        ? '${course.salePrice!.toStringAsFixed(0)}\$'
        : course.price != null
            ? '${course.price!.toStringAsFixed(0)}\$'
            : 'Miễn phí';
    final rating = course.rating?.toStringAsFixed(1) ?? '0.0';
    final students = course.totalStudents != null
        ? '${course.totalStudents} HV'
        : '0 HV';
    final imageUrl = course.imageHeader ?? course.image;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: AppColors.primary.withOpacity(0.1),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.school,
                            size: 40,
                            color: AppColors.primary,
                          );
                        },
                      )
                    : const Icon(
                        Icons.school,
                        size: 40,
                        color: AppColors.primary,
                      ),
              ),
            ),
            
            // Course Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating and Students
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        students,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Price
                  Text(
                    price,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
