import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';
import '../../viewmodels/course_detail_viewmodel.dart';
import '../../../../cart/presentation/viewmodels/cart_viewmodel.dart';
import '../../../../home/domain/entities/course.dart';

/// Widget for displaying the enroll/add-to-cart button
class EnrollButtonWidget extends StatelessWidget {
  final Course course;

  const EnrollButtonWidget({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<CourseDetailViewModel, CartViewModel>(
      builder: (context, courseViewModel, cartViewModel, child) {
        final apiCourse = courseViewModel.courseDetail;
        final isEnrolled = courseViewModel.isEnrolled;
        final isCheckingEnrollment = courseViewModel.isCheckingEnrollment;
        final isAddingToCart = cartViewModel.isAddingToCart;
        final apiPrice = apiCourse?.totalPrice ?? 0.0;
        final coursePrice = course.price ?? course.salePrice ?? 0.0;
        final price = apiPrice > 0 ? apiPrice : coursePrice;

        return GestureDetector(
          onTap: (isCheckingEnrollment || isAddingToCart)
              ? null
              : () => _handleEnrollButtonTap(
                    context,
                    courseViewModel,
                    cartViewModel,
                    isEnrolled == true,
                    price,
                  ),
          child: Container(
            margin: const EdgeInsets.all(CourseUIConstants.cardMargin),
            padding: const EdgeInsets.symmetric(
              vertical: CourseUIConstants.spacingLarge,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0961F5),
              borderRadius: BorderRadius.circular(
                  CourseUIConstants.borderRadiusMedium),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0961F5).withOpacity(0.3),
                  blurRadius: CourseUIConstants.spacingSmall,
                  offset: const Offset(0, CourseUIConstants.shadowOffset),
                ),
              ],
            ),
            child: Center(
              child: (isCheckingEnrollment || isAddingToCart)
                  ? const SizedBox(
                      width: CourseUIConstants.iconSizeLarge,
                      height: CourseUIConstants.iconSizeLarge,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _getButtonText(isEnrolled == true, price),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  String _getButtonText(bool isEnrolled, double price) {
    if (isEnrolled) {
      return 'Vào học';
    } else if (price > 0) {
      return CourseConstants.buttonAddToCart;
    } else {
      return CourseConstants.buttonEnrollFree;
    }
  }

  Future<void> _handleEnrollButtonTap(
    BuildContext context,
    CourseDetailViewModel courseViewModel,
    CartViewModel cartViewModel,
    bool isEnrolled,
    double price,
  ) async {
    if (isEnrolled) {
      _navigateToFirstLesson(context, courseViewModel);
    } else {
      if (price > 0) {
        await _addToCart(context, courseViewModel, cartViewModel);
      } else {
        _navigateToPayment(context);
      }
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
        _showSnackBar(context, 'Không có bài học nào', Colors.red);
      }
    } else {
      _showSnackBar(context, 'Khóa học chưa có nội dung', Colors.red);
    }
  }

  Future<void> _addToCart(
    BuildContext context,
    CourseDetailViewModel courseViewModel,
    CartViewModel cartViewModel,
  ) async {
    final apiCourse = courseViewModel.courseDetail;
    final courseId = apiCourse?.id ?? course.id ?? '';

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
  }

  void _navigateToPayment(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppConstants.routePayment,
      arguments: {
        'course': course,
      },
    );
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

