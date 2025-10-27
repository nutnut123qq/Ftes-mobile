import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/course.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/colors.dart';

/// Widget for displaying course card
/// Optimized with CachedNetworkImage for better scroll performance
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
    final students = course.totalStudents != null && course.totalStudents! > 0
        ? '${course.totalStudents} HV'
        : '';
    final imageUrl = course.imageHeader ?? course.image;

    // Wrap with RepaintBoundary to isolate widget and reduce repaints
    return RepaintBoundary(
      child: GestureDetector(
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
            // Course Image with caching for better performance
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.primary.withOpacity(0.1),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primary.withOpacity(0.1),
                          child: const Icon(
                            Icons.school,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                        // Memory cache configuration
                        memCacheWidth: 400,  // Limit memory cache width
                        memCacheHeight: 240, // Limit memory cache height
                        maxWidthDiskCache: 800,
                        maxHeightDiskCache: 480,
                      )
                    : Container(
                        color: AppColors.primary.withOpacity(0.1),
                        child: const Icon(
                          Icons.school,
                          size: 40,
                          color: AppColors.primary,
                        ),
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
                        if (students.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            students,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
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
      ),
    );
  }
}
