import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/banner.dart' as home_banner;
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/utils/colors.dart';

/// Widget for displaying banner
/// Optimized with CachedNetworkImage for better performance
class BannerWidget extends StatelessWidget {
  final home_banner.Banner banner;
  final VoidCallback? onTap;

  const BannerWidget({
    super.key,
    required this.banner,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background Image with caching
              if (banner.imageUrl != null && banner.imageUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: banner.imageUrl!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildDefaultBanner(),
                  errorWidget: (context, url, error) => _buildDefaultBanner(),
                  // Memory cache configuration
                  memCacheWidth: 800,
                  memCacheHeight: 240,
                  maxWidthDiskCache: 1600,
                  maxHeightDiskCache: 480,
                )
              else
                _buildDefaultBanner(),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (banner.title != null && banner.title!.isNotEmpty)
                      Text(
                        banner.title!,
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (banner.description != null && banner.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        banner.description!,
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultBanner() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.campaign,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
