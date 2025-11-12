import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/banner.dart' as home_banner;
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/utils/colors.dart';
import '../../../../core/utils/url_helper.dart';

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
      onTap: () {
        // If banner has URL, open it; otherwise use custom onTap
        if (banner.url != null && banner.url!.isNotEmpty) {
          UrlHelper.openExternalUrl(context, url: banner.url!);
        } else if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background from API gradient/color
              Positioned.fill(child: _buildApiBackground()),

              // Foreground Image with caching
              if (banner.imageUrl != null && banner.imageUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: banner.imageUrl!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain, // show full image clearly without cropping
                  // Show API background immediately (no color shift): keep placeholder transparent
                  placeholder: (context, url) => Container(color: Colors.transparent),
                  errorWidget: (context, url, error) => Container(color: Colors.transparent),
                  // Memory cache configuration
                  memCacheWidth: 1400,
                  memCacheHeight: 420,
                  maxWidthDiskCache: 2200,
                  maxHeightDiskCache: 660,
                )
              else
                _buildDefaultBanner(),
              
              // Content
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (banner.title != null && banner.title!.isNotEmpty)
                      Text(
                        banner.title!,
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (banner.description != null && banner.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          banner.description!,
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (banner.buttonText != null && banner.buttonText!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Open URL when button is clicked
                            if (banner.url != null && banner.url!.isNotEmpty) {
                              UrlHelper.openExternalUrl(context, url: banner.url!);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              banner.buttonText!,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ),
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

  Widget _buildDefaultBanner() {
    final base = _parseColorOrDefault(banner.backgroundColor, AppColors.primary);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            base,
            base.withValues(alpha: 0.85),
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

  Widget _buildApiBackground() {
    // Try parse CSS linear-gradient; fallback to backgroundColor; finally app primary
    final gradient = _parseCssLinearGradientToFlutter(banner.backgroundGradient) ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _parseColorOrDefault(banner.backgroundColor, AppColors.primary),
            _parseColorOrDefault(banner.backgroundColor, AppColors.primary).withValues(alpha: 0.85),
          ],
        );
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
    );
  }

  LinearGradient? _parseCssLinearGradientToFlutter(String? css) {
    if (css == null || css.isEmpty) return null;
    // Extract hex colors from CSS gradient string
    final regex = RegExp(r'#[0-9a-fA-F]{3,8}');
    final matches = regex.allMatches(css).map((m) => m.group(0)!).toList();
    if (matches.isEmpty) return null;
    final colors = matches.map((hex) => _parseColorOrDefault(hex, AppColors.primary)).toList();
    if (colors.length == 1) {
      colors.add(colors.first.withValues(alpha: 0.85));
    }
    // Direction: try detect 135deg (diagonal). Default topLeft->bottomRight
    Alignment begin = Alignment.topLeft;
    Alignment end = Alignment.bottomRight;
    final angleRegex = RegExp(r'linear-gradient\(\s*([0-9]+)deg', caseSensitive: false);
    final angleMatch = angleRegex.firstMatch(css);
    if (angleMatch != null) {
      final angleDeg = double.tryParse(angleMatch.group(1)!);
      if (angleDeg != null) {
        // Convert CSS angle (clockwise from 0deg pointing up) to Flutter vector
        final radians = (90 - angleDeg) * math.pi / 180.0;
        final dx = math.cos(radians);
        final dy = math.sin(radians);
        begin = Alignment(-dx, -dy);
        end = Alignment(dx, dy);
      }
    }
    return LinearGradient(begin: begin, end: end, colors: colors);
  }

  Color _parseColorOrDefault(String? hexColor, Color fallback) {
    if (hexColor == null || hexColor.isEmpty) return fallback;
    try {
      String value = hexColor.trim();
      if (value.startsWith('#')) value = value.substring(1);
      if (value.length == 6) value = 'FF$value';
      final intColor = int.parse(value, radix: 16);
      return Color(intColor);
    } catch (_) {
      return fallback;
    }
  }
}
