import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/text_styles.dart';
import '../../domain/entities/blog.dart';
import '../../domain/constants/blog_constants.dart';
import '../../../../core/utils/blog_helpers.dart';

/// Featured blog post card widget
class BlogFeaturedPostCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback onTap;

  const BlogFeaturedPostCard({
    super.key,
    required this.blog,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: blog.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: blog.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 50,
                                color: AppColors.textLight.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                BlogConstants.imageLoadError,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.article,
                            size: 60,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            BlogConstants.noImageLabel,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      blog.categoryName,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blog.title,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: BlogHelpers.stripHtmlTagsAsync(blog.content),
                    builder: (context, snapshot) {
                      final text = snapshot.data ?? '';
                      return Text(
                        text,
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.textLight,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      FutureBuilder<String>(
                        future: BlogHelpers.formatDateAsync(blog.createdAt),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? BlogConstants.unknownDate,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textLight,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      FutureBuilder<String>(
                        future: BlogHelpers.calculateReadTimeAsync(blog.content),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? '',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textLight,
                              fontSize: 12,
                            ),
                          );
                        },
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

