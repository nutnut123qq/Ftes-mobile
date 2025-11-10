import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCacheHelper {
  ImageCacheHelper._();

  static Widget cached(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? error,
    int memCacheWidth = 800,
    int memCacheHeight = 480,
    int maxWidthDiskCache = 1600,
    int maxHeightDiskCache = 960,
  }) {
    if (url.isEmpty) {
      return error ?? const SizedBox.shrink();
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, _) => placeholder ?? _defaultSkeleton(width, height),
      errorWidget: (context, _, errorObject) => error ?? _defaultError(width, height),
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
    );
  }

  static Widget _defaultSkeleton(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF5F9FF),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  static Widget _defaultError(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF5F9FF),
      child: const Icon(Icons.image_not_supported, color: Color(0xFF666666)),
    );
  }
}





