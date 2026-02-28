import 'package:flutter/material.dart';
import '../../domain/entities/my_course.dart';
import '../../../../core/utils/image_cache_helper.dart';
import '../../../../core/widgets/3D/button_3d.dart';

/// Widget to display individual my course card
class MyCourseCardWidget extends StatelessWidget {
  final MyCourse course;
  final VoidCallback? onTap;

  const MyCourseCardWidget({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Course image with caching - left side
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: Container(
                  width: 120,
                  color: Colors.grey[200],
                  child:
                      course.imageHeader != null &&
                          course.imageHeader!.isNotEmpty
                      ? ImageCacheHelper.cached(
                          course.imageHeader!,
                          width: 120,
                          fit: BoxFit.cover,
                          memCacheWidth: 480,
                          memCacheHeight: 480,
                          maxWidthDiskCache: 960,
                          maxHeightDiskCache: 960,
                          placeholder: Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          error: Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.school,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.school,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              // Course info - right side
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        course.title ?? 'Khóa học không có tiêu đề',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF202244),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      // 3D Outline Button
                      OutlineButton3D(
                        text: 'Học tiếp',
                        onPressed: onTap,
                        borderRadius: 5.0,
                        borderWidth: 1.5,
                        borderColor: const Color.fromARGB(255, 28, 38, 228),
                        shadowOffset: 3.0,
                        fontSize: 10.0,
                        width: 90,
                        height: 35,
                        autoSize: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14, // chiều ngang của button
                          vertical: 8, // chiều cao của button
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Instructor and purchase date
                      Row(
                        children: [
                          // Instructor
                          if (course.instructor != null &&
                              course.instructor!.isNotEmpty) ...[
                            Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                course.instructor!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          const Spacer(),
                          // Purchase date
                          if (course.purchaseDate != null &&
                              course.purchaseDate!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF202244,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Đã mua: ${_formatDate(course.purchaseDate!)}',
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFF202244),
                                  fontWeight: FontWeight.w500,
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
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
