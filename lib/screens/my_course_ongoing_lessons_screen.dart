import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/models/course_response.dart';
import 'package:ftes/providers/course_provider.dart';
import 'package:ftes/routes/app_routes.dart';

class MyCourseOngoingLessonsScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String courseImage;

  const MyCourseOngoingLessonsScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.courseImage,
  });

  @override
  State<MyCourseOngoingLessonsScreen> createState() => _MyCourseOngoingLessonsScreenState();
}

class _MyCourseOngoingLessonsScreenState extends State<MyCourseOngoingLessonsScreen> {
  int _selectedTabIndex = 1;
  final List<String> _tabs = ['Giới thiệu', 'Chương trình học'];
  
  // Track which parts are expanded
  final Map<String, bool> _expandedParts = {};

  @override
  void initState() {
    super.initState();
    // Fetch course detail when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<CourseProvider>(context, listen: false);
      
      if (widget.courseId.isNotEmpty) {
        // Always use fetchCourseBySlug since courseId is now slug from My Courses
        await provider.fetchCourseBySlug(widget.courseId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        // Use API data if available, otherwise fall back to widget.course
        final apiCourse = courseProvider.selectedCourse;
        final isLoading = courseProvider.isLoadingCourseDetail;
        final errorMessage = courseProvider.errorMessage;
        
        return Scaffold(
          backgroundColor: const Color(0xFFF5F9FF),
          body: CustomScrollView(
            slivers: [
              // Hero Image with App Bar
              _buildHeroSection(apiCourse),
              
              // Error message
              if (errorMessage != null && errorMessage.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              'Lỗi tải dữ liệu',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Loading indicator
              if (isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              
              // Course Info Card
              if (!isLoading)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _buildCourseInfoCard(apiCourse),
                  ),
                ),
              
              // Conditional content based on selected tab
              if (!isLoading && _selectedTabIndex == 0) ...[
                // About tab content
                SliverToBoxAdapter(
                  child: _buildDescriptionSection(apiCourse),
                ),
                SliverToBoxAdapter(
                  child: _buildInstructorSection(apiCourse),
                ),
                SliverToBoxAdapter(
                  child: _buildWhatYoullGetSection(apiCourse),
                ),
                SliverToBoxAdapter(
                  child: _buildReviewsSection(apiCourse),
                ),
              ],
              
              // Curriculum tab
              if (!isLoading && _selectedTabIndex == 1)
                SliverToBoxAdapter(
                  child: _buildCurriculumContent(apiCourse),
                ),
              
              // NO ENROLL BUTTON - Already enrolled!
              
              // Bottom Spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroSection(CourseResponse? apiCourse) {
    final imageUrl = apiCourse?.image ?? widget.courseImage;
    
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Course Image
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.black,
                  child: const Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 80,
                  ),
                );
              },
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
            
            // Video Play Button
            Positioned(
              right: 34,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  // Get first lesson from course
                  final courseProvider = context.read<CourseProvider>();
                  final apiCourse = courseProvider.selectedCourse;
                  
                  if (apiCourse?.parts != null && apiCourse!.parts!.isNotEmpty) {
                    final firstPart = apiCourse.parts!.first;
                    if (firstPart.lessons != null && firstPart.lessons!.isNotEmpty) {
                      final firstLesson = firstPart.lessons!.first;
                      
                      // Navigate to video screen
                      AppRoutes.navigateToMyCourseOngoingVideo(
                        context,
                        lessonId: firstLesson.id ?? '',
                        lessonTitle: firstLesson.title ?? 'Video',
                        courseTitle: apiCourse.title ?? widget.courseTitle,
                        videoUrl: firstLesson.videoUrl ?? '',
                      );
                    } else {
                      // No lessons available
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Không có bài học nào')),
                      );
                    }
                  } else {
                    // No parts available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Khóa học chưa có nội dung')),
                    );
                  }
                },
                child: Container(
                  width: 63,
                  height: 63,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Color(0xFF0961F5),
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseInfoCard(CourseResponse? apiCourse) {
    final title = apiCourse?.title ?? widget.courseTitle;
    final rating = apiCourse?.rating ?? 4.8;
    final totalStudents = apiCourse?.totalStudents ?? 0;
    final totalLessons = apiCourse?.parts?.fold<int>(0, (sum, p) => sum + (p.lessons?.length ?? 0)) ?? 0;
    final totalDuration = apiCourse?.parts?.fold<int>(0, (sum, p) => sum + (p.totalDuration ?? 0)) ?? 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Color(0xFFFFD700),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.people_outline,
                color: Color(0xFF0961F5),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$totalStudents học viên',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Lessons and Duration
          Row(
            children: [
              const Icon(
                Icons.play_circle_outline,
                color: Color(0xFF0961F5),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$totalLessons bài học',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF545454),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.access_time,
                color: Color(0xFF0961F5),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$totalDuration phút',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF545454),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Tab Navigation
          _buildTabNavigation(),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Row(
      children: List.generate(_tabs.length, (index) {
        final isSelected = _selectedTabIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0961F5) : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _tabs[index],
                textAlign: TextAlign.center,
                style: AppTextStyles.body1.copyWith(
                  color: isSelected ? Colors.white : const Color(0xFF545454),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // === CLEANED UP: Removed old hardcoded methods ===
  // - _buildTabContent (now handled in build() with Consumer)
  // - _buildAboutContent (old static content)
  // - _buildFeatureList (old static content)
  // - _buildCurriculumSection (old hardcoded sections)
  // - _buildCurriculumLesson (old hardcoded lessons)
  // Now using dynamic data from API via _buildCurriculumContent(apiCourse)

  Widget _buildDescriptionSection(CourseResponse? course) {
    final description = course?.description ?? 'Không có mô tả';
    final contentCourse = course?.contentCourse;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mô tả khóa học',
            style: AppTextStyles.h5.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF545454),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          
          if (contentCourse != null && contentCourse.isNotEmpty) ...[
            const SizedBox(height: 16),
            
            Text(
              'Nội dung khóa học',
              style: AppTextStyles.h5.copyWith(
                color: const Color(0xFF202244),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              contentCourse,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF545454),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInstructorSection(CourseResponse? course) {
    final instructorName = course?.instructorName ?? 'Chưa có thông tin';
    final instructorAvatar = course?.instructorAvatar;
    final infoCourse = course?.infoCourse;
    final categoryName = course?.categoryName ?? 'Chưa phân loại';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giảng viên',
            style: AppTextStyles.h5.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              // Avatar
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(27),
                ),
                child: instructorAvatar != null && instructorAvatar.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(27),
                        child: Image.network(
                          instructorAvatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildAvatarPlaceholder(instructorName);
                          },
                        ),
                      )
                    : _buildAvatarPlaceholder(instructorName),
              ),
              
              const SizedBox(width: 16),
              
              // Instructor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instructorName,
                      style: AppTextStyles.h5.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      categoryName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF545454),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFB4BDC4),
                size: 16,
              ),
            ],
          ),
          
          // Display additional info from infoCourse if available
          if (infoCourse != null && infoCourse.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            ...infoCourse.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: const Color(0xFF0961F5),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(0xFF545454),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      color: const Color(0xFFE8F1FF),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Color(0xFF0961F5),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildWhatYoullGetSection(CourseResponse? course) {
    // Calculate total lessons from parts
    int totalLessons = 0;
    if (course?.parts != null) {
      for (var part in course!.parts!) {
        totalLessons += part.lessons?.length ?? 0;
      }
    }
    
    final level = course?.level ?? 'Cơ bản';
    final duration = course?.duration;
    final totalStudents = course?.totalStudents ?? 0;
    
    final features = [
      if (totalLessons > 0) {'icon': Icons.video_library, 'text': '$totalLessons Bài học'},
      {'icon': Icons.devices, 'text': 'Truy cập Mobile, Desktop & TV'},
      {'icon': Icons.school, 'text': 'Cấp độ $level'},
      if (duration != null && duration > 0) {'icon': Icons.access_time, 'text': '${(duration / 60).toStringAsFixed(1)} giờ'},
      {'icon': Icons.all_inclusive, 'text': 'Truy cập trọn đời'},
      if (totalStudents > 0) {'icon': Icons.people, 'text': '$totalStudents Học viên'},
      {'icon': Icons.workspace_premium, 'text': 'Chứng chỉ hoàn thành'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bạn sẽ nhận được',
            style: AppTextStyles.h5.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(
                  feature['icon'] as IconData,
                  color: const Color(0xFF545454),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  feature['text'] as String,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(CourseResponse? course) {
    final rating = course?.rating ?? 0.0;
    final totalReviews = course?.totalReviews ?? 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Đánh giá',
                style: AppTextStyles.h5.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              // Display rating and total reviews
              if (rating > 0) ...[
                Icon(
                  Icons.star,
                  color: const Color(0xFFFFA726),
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(1),
                  style: AppTextStyles.h5.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (totalReviews > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '($totalReviews đánh giá)',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 13,
                  ),
                ),
              ],
              const Spacer(),
              Text(
                'Xem tất cả',
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF0961F5),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF0961F5),
                size: 16,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Display message if no reviews yet
          if (totalReviews == 0)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Chưa có đánh giá nào',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          
          // Review placeholders (these should be replaced with actual review data from API later)
          if (totalReviews > 0) ...[
            // Review 1
            _buildReviewCard(
              name: 'Học viên',
              avatar: '',
              rating: rating,
              comment: 'Khóa học này rất hữu ích. Giảng viên nói rất hay, tôi hoàn toàn yêu thích.',
              likes: 0,
              timeAgo: 'Gần đây',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String avatar,
    required double rating,
    required String comment,
    required int likes,
    required String timeAgo,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: avatar.isNotEmpty 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(23),
                        child: Image.network(
                          avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFE8F1FF),
                              child: Center(
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    color: Color(0xFF0961F5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        color: const Color(0xFFE8F1FF),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              color: Color(0xFF0961F5),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ),
              
              const SizedBox(width: 12),
              
              // Name and Rating
              Expanded(
                child: Row(
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.h5.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F1FF),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: const Color(0xFF4D81E5),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFF4D81E5),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFF202244),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Comment
          Text(
            comment,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF545454),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Likes and Time
          Row(
            children: [
              const Icon(
                Icons.thumb_up,
                color: Color(0xFF545454),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                likes.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                timeAgo,
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumContent(CourseResponse? apiCourse) {
    final parts = apiCourse?.parts ?? [];
    
    if (parts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: const Color(0xFF545454).withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có nội dung khóa học',
              style: AppTextStyles.heading2.copyWith(
                color: const Color(0xFF202244),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: parts.asMap().entries.map((entry) {
          final index = entry.key;
          final part = entry.value;
          final partId = part.id ?? '';
          final isExpanded = _expandedParts[partId] ?? true; // Default expanded
          final lessons = part.lessons ?? [];
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 16),
              
              // Part header
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedParts[partId] = !isExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              part.title ?? 'Untitled Part',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: const Color(0xFF202244),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${lessons.length} Bài học',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: const Color(0xFF545454),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: const Color(0xFF0961F5),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Lessons list
              if (isExpanded && lessons.isNotEmpty)
                ...lessons.asMap().entries.map((lessonEntry) {
                  final lessonIndex = lessonEntry.key;
                  final lesson = lessonEntry.value;
                  
                  return GestureDetector(
                    onTap: () {
                      // Navigate to video screen when lesson is tapped
                      final courseProvider = context.read<CourseProvider>();
                      final apiCourse = courseProvider.selectedCourse;
                      
                      AppRoutes.navigateToMyCourseOngoingVideo(
                        context,
                        lessonId: lesson.id ?? '',
                        lessonTitle: lesson.title ?? 'Video',
                        courseTitle: apiCourse?.title ?? widget.courseTitle,
                        videoUrl: lesson.videoUrl ?? '',
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, top: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F9FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF0961F5).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0961F5).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${lessonIndex + 1}'.padLeft(2, '0'),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: const Color(0xFF0961F5),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson.title ?? 'Untitled Lesson',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: const Color(0xFF202244),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                if (lesson.description != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    lesson.description!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: const Color(0xFF545454),
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            lesson.type == 'VIDEO' ? Icons.play_circle_outline : Icons.article_outlined,
                            color: const Color(0xFF0961F5),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
