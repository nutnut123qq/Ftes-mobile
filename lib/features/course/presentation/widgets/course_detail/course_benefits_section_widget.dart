import 'package:flutter/material.dart';
import '../../../../../utils/text_styles.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';

/// Widget for displaying course benefits section
class CourseBenefitsSectionWidget extends StatelessWidget {
  final Map<String, dynamic>? infoCourse;

  const CourseBenefitsSectionWidget({
    super.key,
    this.infoCourse,
  });

  List<String> _getBenefits() {
    if (infoCourse != null && infoCourse!.isNotEmpty) {
      return infoCourse!.values
          .where((value) => value != null && value.toString().isNotEmpty)
          .map((value) => value.toString())
          .toList();
    }
    return CourseConstants.defaultBenefits;
  }

  @override
  Widget build(BuildContext context) {
    final benefits = _getBenefits();

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: CourseUIConstants.sectionMargin),
      padding: const EdgeInsets.all(CourseUIConstants.sectionPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(CourseUIConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(CourseUIConstants.shadowOpacity),
            blurRadius: CourseUIConstants.shadowBlurRadius,
            offset: const Offset(0, CourseUIConstants.shadowOffset),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CourseConstants.titleWhatYouWillLearn,
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: CourseUIConstants.spacingLarge),
          ...benefits.map((benefit) {
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: CourseUIConstants.spacingMedium),
              child: Row(
                children: [
                  Container(
                    width: CourseUIConstants.iconSizeLarge,
                    height: CourseUIConstants.iconSizeLarge,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C851),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: CourseUIConstants.iconSizeMedium,
                    ),
                  ),
                  const SizedBox(width: CourseUIConstants.spacingMedium),
                  Expanded(
                    child: Text(
                      benefit,
                      style: AppTextStyles.bodyMedium.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

