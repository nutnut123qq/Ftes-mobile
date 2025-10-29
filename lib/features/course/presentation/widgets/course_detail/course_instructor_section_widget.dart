import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../domain/constants/course_ui_constants.dart';
import '../../../domain/constants/course_constants.dart';
import '../../viewmodels/course_detail_viewmodel.dart';

/// Widget for displaying course instructor section
class CourseInstructorSectionWidget extends StatelessWidget {
  final String? userName;

  const CourseInstructorSectionWidget({
    super.key,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseDetailViewModel>(
      builder: (context, viewModel, child) {
        final mentorProfile = viewModel.mentorProfile;
        final isLoadingProfile = viewModel.isLoadingProfile;
        final instructorName = mentorProfile?.name ??
            userName ??
            CourseConstants.defaultInstructorName;
        final jobName = mentorProfile?.jobName ??
            CourseConstants.defaultInstructorTitle;

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
                CourseConstants.titleInstructor,
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: CourseUIConstants.spacingLarge),
              if (isLoadingProfile)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(CourseUIConstants.spacingXLarge),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Row(
                  children: [
                    CircleAvatar(
                      radius: CourseUIConstants.avatarRadius,
                      backgroundColor: const Color(0xFF0961F5),
                      backgroundImage: mentorProfile?.avatar != null &&
                              mentorProfile?.avatar?.isNotEmpty == true
                          ? NetworkImage(mentorProfile!.avatar!)
                          : null,
                      child: mentorProfile?.avatar == null ||
                              mentorProfile?.avatar?.isEmpty == true
                          ? Text(
                              instructorName.isNotEmpty
                                  ? instructorName[0].toUpperCase()
                                  : 'G',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: CourseUIConstants.avatarFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: CourseUIConstants.spacingLarge),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final username =
                                  mentorProfile?.username ?? userName;
                              if (username != null && username.isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.routeInstructorProfile,
                                  arguments: username,
                                );
                              }
                            },
                            child: Text(
                              instructorName,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0961F5),
                              ),
                            ),
                          ),
                          const SizedBox(height: CourseUIConstants.spacingTiny),
                          Text(
                            jobName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

