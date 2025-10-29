import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../utils/text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/home/domain/entities/course.dart';
import '../viewmodels/course_detail_viewmodel.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/part.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/exercise.dart';
import '../../../cart/presentation/viewmodels/cart_viewmodel.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../routes/app_routes.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  int _selectedTabIndex = 1;
  final List<String> _tabs = ['Giới thiệu', 'Chương trình học'];
  
  // Track which parts are expanded
  final Map<String, bool> _expandedParts = {};

  @override
  void initState() {
    super.initState();
    // Optimize: Use PostFrameCallback to prevent blocking first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAsync();
    });
  }

  /// Optimized async initialization without blocking main thread
  Future<void> _initializeAsync() async {
    // Use slugName if available, otherwise id
    final courseIdentifier = widget.course.slugName ?? widget.course.id ?? '';
    if (courseIdentifier.isEmpty) return;

    try {
      // Load userId
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(AppConstants.keyUserId);

      if (!mounted) return;

      final viewModel = Provider.of<CourseDetailViewModel>(context, listen: false);

      // Initialize course detail (fetches course, profile, enrollment in one go)
      await viewModel.initialize(courseIdentifier, userId);

      print('✅ Course detail initialized successfully');
    } catch (e) {
      print('❌ Error initializing course detail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<CartViewModel>()),
      ],
      child: Consumer<CourseDetailViewModel>(
        builder: (context, viewModel, child) {
        // Use API data if available, otherwise fall back to widget.course
        final apiCourse = viewModel.courseDetail;
        final isLoading = viewModel.isLoading;
        
        return Scaffold(
          backgroundColor: const Color(0xFFF5F9FF),
          body: CustomScrollView(
            slivers: [
              // Hero Image with App Bar
              _buildHeroSection(apiCourse),
              
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
                  child: _buildCourseInfoCard(apiCourse),
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
              
              // Enroll Button
              if (!isLoading)
                SliverToBoxAdapter(
                  child: _buildEnrollButton(),
                ),
              
              // Bottom Spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
        );
        },
      ),
    );
  }

  Widget _buildHeroSection(CourseDetail? apiCourse) {
    final imageUrl = apiCourse?.imageHeader ?? widget.course.image ?? widget.course.imageHeader ?? '';
    
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
            
            // Video Play Button / Cart Button
            Positioned(
              right: 34,
              bottom: 20,
              child: Consumer<CourseDetailViewModel>(
                builder: (context, viewModel, child) {
                  final isEnrolled = viewModel.isEnrolled;
                  
                  return GestureDetector(
                    onTap: () async {
                      if (isEnrolled == true) {
                        // Navigate to first lesson when enrolled
                        final courseDetail = viewModel.courseDetail;
                        
                        if (courseDetail != null && courseDetail.parts.isNotEmpty) {
                          final firstPart = courseDetail.parts.first;
                          if (firstPart.lessons.isNotEmpty) {
                            final firstLesson = firstPart.lessons.first;
                            
                            // Navigate to video page
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
                            // No lessons available
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Không có bài học nào'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                            );
                          }
                        } else {
                          // No parts available
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Khóa học chưa có nội dung'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          );
                        }
                      } else {
                        // Add to cart when not enrolled
                        final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
                        final courseDetail = viewModel.courseDetail;
                        final apiPrice = courseDetail?.totalPrice ?? 0.0;
                        final coursePrice = widget.course.price ?? widget.course.salePrice ?? 0.0;
                        final price = apiPrice > 0 ? apiPrice : coursePrice;
                        
                        if (price > 0) {
                          // Add to cart for paid courses
                          final courseId = courseDetail?.id ?? widget.course.id ?? '';
                          if (courseId.isNotEmpty) {
                            final success = await cartViewModel.addToCart(courseId);
                            
                            if (success) {
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Đã thêm khóa học vào giỏ hàng'),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  action: SnackBarAction(
                                    label: 'Xem giỏ hàng',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppConstants.routeCart);
                                    },
                                  ),
                                ),
                              );
                            } else {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(cartViewModel.errorMessage ?? 'Không thể thêm vào giỏ hàng'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          // Navigate to payment screen for free courses (enrollment)
                          Navigator.pushNamed(
                            context,
                            AppConstants.routePayment,
                            arguments: {
                              'course': widget.course,
                            },
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isEnrolled == true ? Icons.play_arrow : Icons.shopping_cart,
                        color: const Color(0xFF0961F5),
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseInfoCard(CourseDetail? apiCourse) {
    // Use API data if available
    final title = apiCourse?.title ?? widget.course.title ?? '';
    final category = apiCourse?.categoryName ?? widget.course.categoryName ?? '';
    final totalLessons = apiCourse?.parts.fold<int>(0, (sum, p) => sum + p.lessons.length) ?? 0;
    final price = apiCourse?.salePrice ?? apiCourse?.totalPrice;
    
    return Container(
      margin: const EdgeInsets.all(34),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
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
            style: AppTextStyles.heading2.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Category
          Text(
            category,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF0961F5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            children: [
              // Rating
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xFFFFB800),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    apiCourse?.avgStar.toStringAsFixed(1) ?? widget.course.rating?.toString() ?? '0',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              
              // Students
              Row(
                children: [
                  const Icon(
                    Icons.people,
                    color: Color(0xFF666666),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${apiCourse?.totalUser ?? widget.course.totalStudents ?? 0} học viên',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              
              // Lessons
              Row(
                children: [
                  const Icon(
                    Icons.play_circle_outline,
                    color: Color(0xFF666666),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$totalLessons bài học',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Price
          Row(
            children: [
              if (price != null && price > 0) ...[
                Text(
                  '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                  style: AppTextStyles.heading3.copyWith(
                    color: const Color(0xFF0961F5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (apiCourse?.totalPrice != null && apiCourse!.totalPrice > price) ...[
                  const SizedBox(width: 8),
                  Text(
                    '${apiCourse.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF999999),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ] else ...[
                Text(
                  'Miễn phí',
                  style: AppTextStyles.heading3.copyWith(
                    color: const Color(0xFF00C851),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          
          // Tab Selector
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
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
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Text(
                        tab,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? const Color(0xFF0961F5) : const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(CourseDetail? apiCourse) {
    final description = apiCourse?.description ?? 'Không có mô tả';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giới thiệu khóa học',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorSection(CourseDetail? apiCourse) {
    return Consumer<CourseDetailViewModel>(
      builder: (context, viewModel, child) {
        final mentorProfile = viewModel.mentorProfile;
        final isLoadingProfile = viewModel.isLoadingProfile;
        final instructorName = mentorProfile?.name ?? apiCourse?.userName ?? 'Giảng viên';
        final jobName = mentorProfile?.jobName ?? 'Giảng viên chuyên nghiệp';
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 34),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Giảng viên',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (isLoadingProfile)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF0961F5),
                      backgroundImage: mentorProfile?.avatar != null && mentorProfile?.avatar?.isNotEmpty == true
                          ? NetworkImage(mentorProfile!.avatar!)
                          : null,
                      child: mentorProfile?.avatar == null || mentorProfile?.avatar?.isEmpty == true
                          ? Text(
                              instructorName.isNotEmpty ? instructorName[0].toUpperCase() : 'G',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to instructor profile
                              final username = mentorProfile?.username ?? apiCourse?.userName;
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
                          const SizedBox(height: 4),
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

  Widget _buildWhatYoullGetSection(CourseDetail? apiCourse) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bạn sẽ học được gì',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...(() {
            // Check if infoCourse has data
            final infoCourse = apiCourse?.infoCourse;
            List<String> benefits = [];
            
            if (infoCourse != null && infoCourse.isNotEmpty) {
              // Extract values from infoCourse (additionalProp1-4)
              benefits = infoCourse.values
                  .where((value) => value != null && value.toString().isNotEmpty)
                  .map((value) => value.toString())
                  .toList();
            }
            
            // Fallback to default benefits if no infoCourse data
            if (benefits.isEmpty) {
              benefits = [
                'Kiến thức cơ bản về lập trình',
                'Thực hành với các bài tập thực tế',
                'Kỹ năng giải quyết vấn đề',
              ];
            }
            
            return benefits.map((benefit) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C851),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
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
            }).toList();
          })(),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(CourseDetail? apiCourse) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đánh giá',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                apiCourse?.avgStar.toStringAsFixed(1) ?? '4.5',
                style: AppTextStyles.heading2.copyWith(
                  color: const Color(0xFF0961F5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: index < (apiCourse?.avgStar.round() ?? 4) 
                      ? const Color(0xFFFFB800) 
                      : const Color(0xFFE0E0E0),
                  size: 16,
                );
              }),
              const SizedBox(width: 8),
              Text(
                '(${apiCourse?.totalUser ?? 0} đánh giá)',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumContent(CourseDetail? apiCourse) {
    final parts = apiCourse?.parts ?? [];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chương trình học',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...parts.map((part) => _buildPartSection(part)),
        ],
      ),
    );
  }

  Widget _buildPartSection(Part part) {
    final isExpanded = _expandedParts[part.id] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedParts[part.id] = !isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    color: const Color(0xFF666666),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${part.name} - ${part.description}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${part.lessons.length} bài học${part.exercises.isNotEmpty ? ', ${part.exercises.length} bài tập' : ''}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            // Lessons
            ...(() {
              final sortedLessons = part.lessons.toList()
                ..sort((a, b) => a.order.compareTo(b.order));
              return sortedLessons.map((lesson) => _buildLessonItem(lesson));
            })(),
            // Exercises
            if (part.exercises.isNotEmpty) ...[
              const Divider(height: 1),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Bài tập:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              ...(() {
                final sortedExercises = part.exercises.toList()
                  ..sort((a, b) => a.order.compareTo(b.order));
                return sortedExercises.map((exercise) => _buildExerciseItem(exercise));
              })(),
            ],
          ],
        ],
      ),
    );
  }

  IconData _getLessonIcon(String? type) {
    switch (type) {
      case 'VIDEO':
        return Icons.play_circle_outline;
      case 'DOCUMENT':
        return Icons.description_outlined;
      case 'EXERCISE':
        return Icons.quiz_outlined;
      default:
        return Icons.play_circle_outline; // Default to video icon
    }
  }

  Widget _buildExerciseItem(Exercise exercise) {
    return GestureDetector(
      onTap: () {
        // Show exercise details popup
        _showExercisePopup(exercise);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.quiz_outlined,
              color: const Color(0xFF666666),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (exercise.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      exercise.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseInfoSection(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF0961F5),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showExercisePopup(Exercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E293B), // Dark blue color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'EXERCISE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey, height: 24),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          exercise.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // Mô tả
                        _buildExerciseInfoSection('Mô tả:', exercise.description),
                        const SizedBox(height: 16),
                        // Yêu cầu
                        _buildExerciseInfoSection('Yêu cầu:', exercise.question),
                        const SizedBox(height: 16),
                        // Output mong đợi
                        _buildExerciseInfoSection('Output mong đợi:', exercise.expectedOutput),
                        const SizedBox(height: 16),
                        // Tiêu chí
                        _buildExerciseInfoSection('Tiêu chí:', exercise.criteria),
                        const SizedBox(height: 16),
                        // File extension
                        if (exercise.fileExtension.isNotEmpty)
                          _buildExerciseInfoSection('File extension:', exercise.fileExtension),
                        const SizedBox(height: 16),
                        // Check options
                        if (exercise.checkLogic || exercise.checkPerform || exercise.checkEdgeCase)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Check:',
                                style: TextStyle(
                                  color: Color(0xFF0961F5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (exercise.checkLogic)
                                const Text('  • Logic', style: TextStyle(color: Colors.white)),
                              if (exercise.checkPerform)
                                const Text('  • Performance', style: TextStyle(color: Colors.white)),
                              if (exercise.checkEdgeCase)
                                const Text('  • Edge Case', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Note
                const Text(
                  'Vui lòng truy cập trang web để nộp bài tập',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContentPopup(Lesson lesson) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E293B), // Dark blue color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lesson.type ?? 'Content',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey, height: 24),
                // Title
                Text(
                  lesson.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Description if exists
                if (lesson.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      lesson.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                // Content
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
                          color: const Color(0xFF0961F5), // Blue links
                          textDecoration: TextDecoration.underline,
                        ),
                        "p": Style(
                          margin: Margins.only(bottom: 8),
                        ),
                        "ul": Style(
                          margin: Margins.only(bottom: 8),
                          padding: HtmlPaddings.zero,
                        ),
                        "li": Style(
                          margin: Margins.only(bottom: 4),
                        ),
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLessonItem(Lesson lesson) {
    return Consumer<CourseDetailViewModel>(
      builder: (context, viewModel, child) {
        final isEnrolled = viewModel.isEnrolled;
        
        return GestureDetector(
          onTap: () {
            // Check if user is enrolled
            if (isEnrolled != true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vui lòng mua khóa học để xem bài học'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              );
              return;
            }
            
            // Check lesson type
            if (lesson.type != null && lesson.type != 'VIDEO') {
              // Show popup for non-video lessons
              _showContentPopup(lesson);
              return;
            }

            // Navigate to video page for VIDEO lessons
            final courseDetailViewModel = Provider.of<CourseDetailViewModel>(context, listen: false);
            final courseDetail = courseDetailViewModel.courseDetail;
            
            if (courseDetail != null && lesson.video.isNotEmpty) {
              print('📹 Navigating to video page with lesson.video: ${lesson.video}');
              print('📋 Lesson type: ${lesson.type}');
              Navigator.pushNamed(
                context,
                AppConstants.routeCourseVideo,
                arguments: {
                  'lessonId': lesson.id,
                  'lessonTitle': lesson.title,
                  'courseTitle': courseDetail.title,
                  'videoUrl': lesson.video,
                  'courseId': courseDetail.id,
                  'type': lesson.type, // Pass lesson type
                },
              );
            } else {
              // Show message if video not available
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video chưa được tải lên'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  _getLessonIcon(lesson.type),
                  color: lesson.isCompleted ? const Color(0xFF00C851) : const Color(0xFF666666),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${lesson.title} - ${lesson.description}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: lesson.isCompleted ? const Color(0xFF00C851) : null,
                        ),
                      ),
                      if (lesson.duration > 0) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${lesson.duration} phút',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Chat AI button for each lesson - only show if enrolled
                if (isEnrolled == true) ...[
                  GestureDetector(
                    onTap: () {
                      // Use lesson.video (video_id format) instead of lesson.id
                      final videoId = lesson.video.isNotEmpty ? lesson.video : lesson.id;
                      // Use full lesson info: title - description
                      final fullLessonTitle = '${lesson.title} - ${lesson.description}';
                      AppRoutes.navigateToAiChat(
                        context,
                        lessonId: videoId,
                        lessonTitle: fullLessonTitle,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0961F5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.smart_toy,
                        color: Color(0xFF0961F5),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (lesson.isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF00C851),
                    size: 20,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnrollButton() {
    return Consumer2<CourseDetailViewModel, CartViewModel>(
      builder: (context, viewModel, cartViewModel, child) {
        final apiCourse = viewModel.courseDetail;
        final isEnrolled = viewModel.isEnrolled;
        final isCheckingEnrollment = viewModel.isCheckingEnrollment;
        final isAddingToCart = cartViewModel.isAddingToCart;
        final apiPrice = apiCourse?.totalPrice ?? 0.0;
        final coursePrice = widget.course.price ?? widget.course.salePrice ?? 0.0;
        final price = apiPrice > 0 ? apiPrice : coursePrice;
        
        return GestureDetector(
          onTap: (isCheckingEnrollment || isAddingToCart) ? null : () => _handleEnrollButtonTap(isEnrolled == true, cartViewModel),
          child: Container(
            margin: const EdgeInsets.all(34),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0961F5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0961F5).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: (isCheckingEnrollment || isAddingToCart)
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isEnrolled == true 
                        ? 'Vào học' 
                        : (price > 0 ? 'Thêm vào giỏ hàng' : 'Tham gia miễn phí'),
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

  void _handleEnrollButtonTap(bool isEnrolled, CartViewModel cartViewModel) async {
    if (isEnrolled) {
      // Navigate to first lesson of the course
      final courseDetailViewModel = Provider.of<CourseDetailViewModel>(context, listen: false);
      final courseDetail = courseDetailViewModel.courseDetail;
      
      if (courseDetail != null && courseDetail.parts.isNotEmpty) {
        final firstPart = courseDetail.parts.first;
        if (firstPart.lessons.isNotEmpty) {
          final firstLesson = firstPart.lessons.first;
          
          // Navigate to video page
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
          // No lessons available
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không có bài học nào'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          );
        }
      } else {
        // No parts available
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Khóa học chưa có nội dung'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      }
    } else {
      final apiCourse = Provider.of<CourseDetailViewModel>(context, listen: false).courseDetail;
      final apiPrice = apiCourse?.totalPrice ?? 0.0;
      final coursePrice = widget.course.price ?? widget.course.salePrice ?? 0.0;
      final price = apiPrice > 0 ? apiPrice : coursePrice;
      
      if (price > 0) {
        // Add to cart for paid courses
        final courseId = apiCourse?.id ?? widget.course.id ?? '';
        if (courseId.isNotEmpty) {
          final success = await cartViewModel.addToCart(courseId);
          
          if (success) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Đã thêm khóa học vào giỏ hàng'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                action: SnackBarAction(
                  label: 'Xem giỏ hàng',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, AppConstants.routeCart);
                  },
                ),
              ),
            );
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(cartViewModel.errorMessage ?? 'Không thể thêm vào giỏ hàng'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        }
      } else {
        // Navigate to payment screen for free courses (enrollment)
        Navigator.pushNamed(
          context,
          AppConstants.routePayment,
          arguments: {
            'course': widget.course,
          },
        );
      }
    }
  }
}
