import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/course.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/utils/colors.dart';
import 'package:intl/intl.dart';

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
    final rating = course.rating?.toStringAsFixed(1) ?? '0.0';
    final imageUrl = course.imageHeader ?? course.image;

    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final price = (course.salePrice != null && course.salePrice! > 0)
        ? currencyFormat.format(course.salePrice)
        : (course.price != null)
        ? currencyFormat.format(course.price)
        : 'Miễn phí';

    // Wrap with RepaintBoundary to isolate widget and reduce repaints
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 180,
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
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
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.primary.withValues(alpha: 0.1),
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
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.school,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                        memCacheWidth: 400,
                        memCacheHeight: 400,
                        maxWidthDiskCache: 800,
                        maxHeightDiskCache: 800,
                      )
                    : Container(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.school,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
              ),
            ),

              // ClipRRect(
              //   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              //   child: SizedBox(
              //     width: double.infinity,
              //     height: 120,
              //     child: imageUrl != null && imageUrl.isNotEmpty
              //         ? CachedNetworkImage(
              //       imageUrl: imageUrl,
              //       fit: BoxFit.cover,
              //       alignment: Alignment.center, // crop chính giữa
              //       placeholder: (context, url) => Container(
              //         color: AppColors.primary.withValues(alpha: 0.1),
              //         alignment: Alignment.center,
              //         child: const CircularProgressIndicator(
              //           strokeWidth: 2,
              //           valueColor: AlwaysStoppedAnimation(AppColors.primary),
              //         ),
              //       ),
              //       errorWidget: (context, url, error) => Container(
              //         color: AppColors.primary.withValues(alpha: 0.1),
              //         alignment: Alignment.center,
              //         child: const Icon(Icons.school, color: AppColors.primary, size: 40),
              //       ),
              //     )
              //         : Container(
              //       color: AppColors.primary.withValues(alpha: 0.1),
              //       alignment: Alignment.center,
              //       child: const Icon(Icons.school, color: AppColors.primary, size: 40),
              //     ),
              //   ),
              // ),

              // Course Info
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category removed per requirement

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              rating,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          price,
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
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
      ),
    );
  }
}
