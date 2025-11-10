import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/features/home/domain/entities/course.dart';

class RemoveBookmarkDialog extends StatelessWidget {
  final Course course;
  final VoidCallback? onRemove;
  final VoidCallback? onCancel;

  const RemoveBookmarkDialog({
    super.key,
    required this.course,
    this.onRemove,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: const Color(0xFF202244).withValues(alpha: 0.88),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Dialog Content
                Container(
                  height: 368,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9FF),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(34),
                    child: Column(
                      children: [
                        // Title
                        Text(
                          'Remove From Bookmark?',
                          style: AppTextStyles.heading1.copyWith(
                            color: const Color(0xFF202244),
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Course Card
                        _buildCourseCard(),
                        
                        const SizedBox(height: 30),
                        
                        // Buttons
                        Row(
                          children: [
                            // Cancel Button
                            Expanded(
                              child: GestureDetector(
                                onTap: onCancel ?? () => Navigator.pop(context),
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F1FF),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: const Color(0xFFB4BDC4).withValues(alpha: 0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: AppTextStyles.buttonLarge.copyWith(
                                        color: const Color(0xFF202244),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // Remove Button
                            Expanded(
                              child: GestureDetector(
                                onTap: onRemove ?? () {
                                  Navigator.pop(context);
                                  // Remove from bookmark logic - placeholder for future implementation
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF0961F5), Color(0xFF4D81E5)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0961F5).withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Yes, Remove',
                                      style: AppTextStyles.buttonLarge.copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard() {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course Image
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                course.image ?? course.imageHeader ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.black,
                    child: const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Course Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    course.categoryName ?? '',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFFFF6B00),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  const SizedBox(height: 5),
                  
                  // Title
                  Text(
                    course.title ?? '',
                    style: AppTextStyles.heading1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const Spacer(),
                  
                  // Price and Rating
                  Row(
                    children: [
                      // Price
                      Text(
                        '\$${course.salePrice ?? course.price ?? 0}',
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFF0961F5),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Rating and Students
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFD700),
                              size: 8,
                            ),
                            const SizedBox(width: 1),
                            Flexible(
                              child: Text(
                                '${course.rating ?? 0}',
                                style: AppTextStyles.body1.copyWith(
                                  color: const Color(0xFF202244),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '|',
                              style: AppTextStyles.body1.copyWith(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                '${course.totalStudents ?? 0} HV',
                                style: AppTextStyles.body1.copyWith(
                                  color: const Color(0xFF202244),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Bookmark Icon
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF0961F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context, {
    required Course course,
    VoidCallback? onRemove,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RemoveBookmarkDialog(
        course: course,
        onRemove: onRemove,
        onCancel: onCancel,
      ),
    );
  }
}
