import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/image_cache_helper.dart';
import '../../domain/entities/course_detail.dart';

class CourseHeroSection extends StatelessWidget {
  final CourseDetail? courseDetail;
  final String fallbackImageUrl;
  final VoidCallback onBack;
  final Widget? trailing;

  const CourseHeroSection({
    super.key,
    required this.courseDetail,
    required this.fallbackImageUrl,
    required this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = courseDetail?.imageHeader ?? fallbackImageUrl;

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.black,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: onBack,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            ImageCacheHelper.cached(
              imageUrl,
              fit: BoxFit.cover,
              error: Container(
                color: Colors.black,
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            if (trailing != null)
              Positioned(
                right: 34,
                bottom: 20,
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}


