import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../routes/app_routes.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';
import '../../viewmodels/course_detail_viewmodel.dart';
import '../../../../cart/presentation/viewmodels/cart_viewmodel.dart';
import '../../../../home/domain/entities/course.dart';

/// Widget for displaying course hero section with image and actions
class CourseHeroSectionWidget extends StatelessWidget {
  final String imageUrl;
  final Course course;

  const CourseHeroSectionWidget({
    super.key,
    required this.imageUrl,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: CourseUIConstants.heroHeight,
      pinned: true,
      backgroundColor: Colors.black,
      leading: Container(
        margin: const EdgeInsets.all(CourseUIConstants.spacingSmall),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius:
              BorderRadius.circular(CourseUIConstants.borderRadiusSmall),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: CourseUIConstants.iconSizeLarge,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Course Image with caching
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              errorWidget: (context, error, stackTrace) {
                return Container(
                  color: Colors.black,
                  child: const Icon(
                    Icons.image,
                    color: Colors.white,
                    size: CourseUIConstants.iconSizeError,
                  ),
                );
              },
              // Memory cache configuration for hero images
              memCacheWidth: 800,
              memCacheHeight: 800,
              maxWidthDiskCache: 1600,
              maxHeightDiskCache: 1600,
            ),

            // Gradient Overlay
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

            // Video Play Button / Cart Button
            Positioned(
              right: CourseUIConstants.cardMargin,
              bottom: CourseUIConstants.spacingXLarge,
              child: Consumer<CourseDetailViewModel>(
                builder: (context, viewModel, child) {
                  final isEnrolled = viewModel.isEnrolled;

                  return _buildActionButton(context, viewModel, isEnrolled);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    CourseDetailViewModel viewModel,
    bool? isEnrolled,
  ) {
    return GestureDetector(
      onTap: () =>
          _handleActionButtonTap(context, viewModel, isEnrolled == true),
      child: Container(
        width: CourseUIConstants.iconSizeHero,
        height: CourseUIConstants.iconSizeHero,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: CourseUIConstants.spacingSmall,
              offset: const Offset(0, CourseUIConstants.shadowOffset),
            ),
          ],
        ),
        child: Icon(
          isEnrolled == true ? Icons.play_arrow : Icons.shopping_cart,
          color: const Color(0xFF0961F5),
          size: CourseUIConstants.iconSizeXLarge,
        ),
      ),
    );
  }

  Future<void> _handleActionButtonTap(
    BuildContext context,
    CourseDetailViewModel viewModel,
    bool isEnrolled,
  ) async {
    if (isEnrolled) {
      _navigateToFirstLesson(context, viewModel);
    } else {
      await _addToCartOrEnroll(context, viewModel);
    }
  }

  void _navigateToFirstLesson(
    BuildContext context,
    CourseDetailViewModel viewModel,
  ) {
    final courseDetail = viewModel.courseDetail;

    if (courseDetail != null && courseDetail.parts.isNotEmpty) {
      final firstPart = courseDetail.parts.first;
      if (firstPart.lessons.isNotEmpty) {
        final firstLesson = firstPart.lessons.first;

        Navigator.pushNamed(
          context,
          AppConstants.routeCourseVideo,
          arguments: {
            'lessonId': firstLesson.id,
            'lessonTitle': firstLesson.title,
            'courseTitle': courseDetail.title,
            'videoUrl': firstLesson.video,
            'courseId': courseDetail.id,
            'type': firstLesson.type,
          },
        );
      } else {
        _showSnackBar(
          context,
          'Không có bài học nào',
          Colors.red,
        );
      }
    } else {
      _showSnackBar(
        context,
        'Khóa học chưa có nội dung',
        Colors.red,
      );
    }
  }

  Future<void> _addToCartOrEnroll(
    BuildContext context,
    CourseDetailViewModel viewModel,
  ) async {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final courseDetail = viewModel.courseDetail;
    final apiPrice = courseDetail?.totalPrice ?? 0.0;
    final coursePrice = course.price ?? course.salePrice ?? 0.0;
    final price = apiPrice > 0 ? apiPrice : coursePrice;

    if (price > 0) {
      // Add to cart for paid courses
      final courseId = courseDetail?.id ?? course.id ?? '';
      if (courseId.isNotEmpty) {
        final success = await cartViewModel.addToCart(courseId);

        if (success) {
          _showSnackBar(
            context,
            CourseConstants.successAddedToCart,
            Colors.green,
            action: SnackBarAction(
              label: CourseConstants.buttonViewCart,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, AppConstants.routeCart);
              },
            ),
          );
        } else {
          _showSnackBar(
            context,
            cartViewModel.errorMessage ??
                CourseConstants.errorAddToCartFailed,
            Colors.red,
          );
        }
      }
    } else {
      // Navigate to payment screen for free courses (enrollment)
      Navigator.pushNamed(
        context,
        AppConstants.routePayment,
        arguments: {
          'course': course,
        },
      );
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor, {
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(CourseUIConstants.borderRadiusSmall),
        ),
        action: action,
      ),
    );
  }
}

