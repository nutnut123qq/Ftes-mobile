import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/constants/course_ui_constants.dart';

/// Dialog for displaying lesson content (non-VIDEO types)
class LessonContentDialog extends StatelessWidget {
  final Lesson lesson;

  const LessonContentDialog({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(CourseUIConstants.borderRadiusLarge),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        padding: const EdgeInsets.all(CourseUIConstants.cardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const Divider(
              color: Colors.grey,
              height: CourseUIConstants.cardPadding,
            ),
            Text(
              lesson.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: CourseUIConstants.fontSizeHeading3,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: CourseUIConstants.spacingMedium),
            if (lesson.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                    bottom: CourseUIConstants.spacingLarge),
                child: Text(
                  lesson.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: CourseUIConstants.fontSizeMedium,
                  ),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Html(
                  data: lesson.video,
                  style: {
                    "body": Style(
                      color: Colors.white,
                      margin: Margins.zero,
                    ),
                    "a": Style(
                      color: const Color(0xFF0961F5),
                      textDecoration: TextDecoration.underline,
                    ),
                    "p": Style(
                      margin: Margins.only(
                          bottom: CourseUIConstants.spacingSmall),
                    ),
                    "ul": Style(
                      margin: Margins.only(
                          bottom: CourseUIConstants.spacingSmall),
                      padding: HtmlPaddings.zero,
                    ),
                    "li": Style(
                      margin: Margins.only(
                          bottom: CourseUIConstants.spacingTiny),
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lesson.type ?? 'Content',
          style: const TextStyle(
            color: Colors.white,
            fontSize: CourseUIConstants.fontSizeHeading3,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  static void show(BuildContext context, Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) => LessonContentDialog(lesson: lesson),
    );
  }
}

