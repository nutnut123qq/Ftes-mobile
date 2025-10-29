import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Optimized cached network image widget with predefined configurations
class OptimizedCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final ImageType imageType;

  const OptimizedCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.imageType = ImageType.medium,
  });

  @override
  Widget build(BuildContext context) {
    final cacheConfig = _getCacheConfig(imageType);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ?? _defaultPlaceholder(context),
      errorWidget: (context, url, error) =>
          errorWidget ?? _defaultErrorWidget(context),
      memCacheWidth: cacheConfig.memCacheWidth,
      memCacheHeight: cacheConfig.memCacheHeight,
      maxWidthDiskCache: cacheConfig.maxWidthDiskCache,
      maxHeightDiskCache: cacheConfig.maxHeightDiskCache,
    );
  }

  Widget _defaultPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _defaultErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(
        Icons.broken_image,
        color: Colors.grey,
        size: 40,
      ),
    );
  }

  _CacheConfig _getCacheConfig(ImageType type) {
    switch (type) {
      case ImageType.thumbnail:
        return const _CacheConfig(
          memCacheWidth: 200,
          memCacheHeight: 200,
          maxWidthDiskCache: 400,
          maxHeightDiskCache: 400,
        );
      case ImageType.small:
        return const _CacheConfig(
          memCacheWidth: 400,
          memCacheHeight: 240,
          maxWidthDiskCache: 800,
          maxHeightDiskCache: 480,
        );
      case ImageType.medium:
        return const _CacheConfig(
          memCacheWidth: 600,
          memCacheHeight: 400,
          maxWidthDiskCache: 1200,
          maxHeightDiskCache: 800,
        );
      case ImageType.large:
        return const _CacheConfig(
          memCacheWidth: 800,
          memCacheHeight: 600,
          maxWidthDiskCache: 1600,
          maxHeightDiskCache: 1200,
        );
      case ImageType.hero:
        return const _CacheConfig(
          memCacheWidth: 800,
          memCacheHeight: 800,
          maxWidthDiskCache: 1600,
          maxHeightDiskCache: 1600,
        );
    }
  }
}

/// Image size type for cache configuration
enum ImageType {
  thumbnail, // 200x200 mem, 400x400 disk
  small, // 400x240 mem, 800x480 disk (course cards)
  medium, // 600x400 mem, 1200x800 disk
  large, // 800x600 mem, 1600x1200 disk
  hero, // 800x800 mem, 1600x1600 disk (hero images)
}

/// Cache configuration
class _CacheConfig {
  final int memCacheWidth;
  final int memCacheHeight;
  final int maxWidthDiskCache;
  final int maxHeightDiskCache;

  const _CacheConfig({
    required this.memCacheWidth,
    required this.memCacheHeight,
    required this.maxWidthDiskCache,
    required this.maxHeightDiskCache,
  });
}

