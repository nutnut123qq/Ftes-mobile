import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/constants/app_constants.dart';
import '../viewmodels/instructor_profile_viewmodel.dart';
import '../widgets/instructor_stats_widget.dart';
import '../widgets/instructor_course_card_widget.dart';
import '../../../../core/di/injection_container.dart' as di;

class InstructorProfilePage extends StatefulWidget {
  final String username;

  const InstructorProfilePage({
    super.key,
    required this.username,
  });

  @override
  State<InstructorProfilePage> createState() => _InstructorProfilePageState();
}

class _InstructorProfilePageState extends State<InstructorProfilePage> {
  late InstructorProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = di.sl<InstructorProfileViewModel>();
    
    // Load data after frame is built to avoid blocking UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initialize(widget.username);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InstructorProfileViewModel>(
      create: (_) => _viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FF),
        body: SafeArea(
          child: Consumer<InstructorProfileViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF0961F5),
                  ),
                );
              }

              if (viewModel.errorMessage != null) {
                return _buildErrorState(viewModel.errorMessage!);
              }

              if (viewModel.profile == null) {
                return _buildEmptyState();
              }

              return CustomScrollView(
                slivers: [
                  // App Bar
                  _buildAppBar(),
                  
                  // Profile Header
                  SliverToBoxAdapter(
                    child: _buildProfileHeader(viewModel),
                  ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                  
                  // Stats
                  SliverToBoxAdapter(
                    child: InstructorStatsWidget(
                      coursesCount: viewModel.courses.length,
                      studentsCount: viewModel.participantsCount,
                      isLoading: viewModel.isLoadingStats,
                    ),
                  ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                  
                  // About Section
                  SliverToBoxAdapter(
                    child: _buildAboutSection(viewModel),
                  ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                  
                  // Courses Section
                  SliverToBoxAdapter(
                    child: _buildCoursesSectionHeader(viewModel),
                  ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),
                  
                  // Courses List
                  if (viewModel.isLoadingCourses)
                    const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(
                            color: Color(0xFF0961F5),
                          ),
                        ),
                      ),
                    )
                  else if (viewModel.hasCourses)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final course = viewModel.courses[index];
                            return InstructorCourseCardWidget(
                              course: course,
                              onTap: () {
                                // Navigate to course detail
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.routeCourseDetail,
                                  arguments: course.slugName,
                                );
                              },
                            );
                          },
                          childCount: viewModel.courses.length,
                        ),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: _buildEmptyCoursesState(),
                    ),
                  
                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF5F9FF),
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF202244),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Giảng viên',
        style: AppTextStyles.heading1.copyWith(
          color: const Color(0xFF202244),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfileHeader(InstructorProfileViewModel viewModel) {
    final profile = viewModel.profile!;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF0961F5),
            backgroundImage: profile.avatar.isNotEmpty
                ? CachedNetworkImageProvider(profile.avatar)
                : null,
            child: profile.avatar.isEmpty
                ? Text(
                    profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'G',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            profile.name,
            style: AppTextStyles.heading2.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Job Title
          Text(
            profile.jobName.isNotEmpty ? profile.jobName : 'Giảng viên chuyên nghiệp',
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(InstructorProfileViewModel viewModel) {
    final profile = viewModel.profile!;
    
    if (profile.description.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giới thiệu',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            profile.description,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSectionHeader(InstructorProfileViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Khóa học (${viewModel.courses.length})',
        style: AppTextStyles.heading3.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyCoursesState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(40),
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
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có khóa học',
            style: AppTextStyles.heading3.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Giảng viên này chưa tạo khóa học nào',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra',
              style: AppTextStyles.heading3.copyWith(
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _viewModel.initialize(widget.username),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0961F5),
                foregroundColor: Colors.white,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy giảng viên',
              style: AppTextStyles.heading3.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Giảng viên này không tồn tại hoặc đã bị xóa',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
