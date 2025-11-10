import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/instructor_course.dart';
import 'package:ftes/utils/text_styles.dart';

/// Widget for displaying instructor course card
/// Optimized with CachedNetworkImage for better scroll performance
class InstructorCourseCardWidget extends StatelessWidget {
  final InstructorCourse course;
  final VoidCallback? onTap;

  const InstructorCourseCardWidget({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = course.salePrice > 0
        ? '${course.salePrice.toStringAsFixed(0)}\$'
        : course.totalPrice > 0
            ? '${course.totalPrice.toStringAsFixed(0)}\$'
            : 'Miễn phí';
    
    final rating = course.avgStar.toStringAsFixed(1);
    final students = course.totalUser > 0 ? '${course.totalUser} HV' : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
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
              child: CachedNetworkImage(
                imageUrl: course.imageHeader,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
                memCacheWidth: 800, // Resize to save RAM
                placeholder: (context, url) => Container(
                  height: 180,
                  color: const Color(0xFFF5F9FF),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0961F5),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: const Color(0xFFF5F9FF),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Color(0xFF666666),
                    size: 48,
                  ),
                ),
              ),
            ),
            
            // Course Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    course.categoryName,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF0961F5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Title
                  Text(
                    course.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    course.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF666666),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Stats Row
                  Row(
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFB800),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      
                      // Students
                      if (students.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Color(0xFF666666),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              students,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                      ],
                      
                      const Spacer(),
                      
                      // Price
                      Text(
                        price,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: const Color(0xFF0961F5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
