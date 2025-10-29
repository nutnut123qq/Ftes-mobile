import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/home/domain/entities/course.dart';
import '../viewmodels/course_detail_viewmodel.dart';
import '../../domain/entities/course_detail.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/exercise.dart';
import '../../../cart/presentation/viewmodels/cart_viewmodel.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../domain/constants/course_constants.dart';
import '../widgets/course_detail/course_hero_section_widget.dart';
import '../widgets/course_detail/course_info_card_widget.dart';
import '../widgets/course_detail/course_description_section_widget.dart';
import '../widgets/course_detail/course_instructor_section_widget.dart';
import '../widgets/course_detail/course_benefits_section_widget.dart';
import '../widgets/course_detail/course_reviews_section_widget.dart';
import '../widgets/course_detail/course_curriculum_widget.dart';
import '../widgets/course_detail/enroll_button_widget.dart';
import '../widgets/course_detail/exercise_dialog.dart';
import '../widgets/course_detail/lesson_content_dialog.dart';

/// Refactored Course Detail Page with optimized widgets and cache support
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
  int _selectedTabIndex = 1; // Default to Curriculum tab
  final List<String> _tabs = [
    CourseConstants.tabIntroduction,
    CourseConstants.tabCurriculum
  ];

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
    final courseIdentifier = widget.course.slugName ?? widget.course.id ?? '';
    if (courseIdentifier.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(AppConstants.keyUserId);

      if (!mounted) return;

      final viewModel =
          Provider.of<CourseDetailViewModel>(context, listen: false);

      // Initialize course detail with cache support
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
          final apiCourse = viewModel.courseDetail;
          final isLoading = viewModel.isLoading;

          return Scaffold(
            backgroundColor: const Color(0xFFF5F9FF),
            body: CustomScrollView(
              slivers: [
                _buildHeroSection(apiCourse),
                if (isLoading) _buildLoadingIndicator(),
                if (!isLoading) ...[
                  _buildCourseInfoCard(apiCourse),
                  if (_selectedTabIndex == 0) ..._buildAboutTab(apiCourse),
                  if (_selectedTabIndex == 1) _buildCurriculumTab(apiCourse),
                  _buildEnrollButton(),
                ],
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
    final imageUrl = apiCourse?.imageHeader ??
        widget.course.image ??
        widget.course.imageHeader ??
        '';

    return CourseHeroSectionWidget(
      imageUrl: imageUrl,
      course: widget.course,
    );
  }

  Widget _buildLoadingIndicator() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildCourseInfoCard(CourseDetail? apiCourse) {
    final title = apiCourse?.title ?? widget.course.title ?? '';
    final category = apiCourse?.categoryName ?? widget.course.categoryName ?? '';
    final totalLessons =
        apiCourse?.parts.fold<int>(0, (sum, p) => sum + p.lessons.length) ?? 0;
    final avgStar = apiCourse?.avgStar ?? widget.course.rating ?? 0.0;
    final totalUser = apiCourse?.totalUser ?? widget.course.totalStudents ?? 0;
    final salePrice = apiCourse?.salePrice;
    final totalPrice = apiCourse?.totalPrice;

    return SliverToBoxAdapter(
      child: CourseInfoCardWidget(
        title: title,
        category: category,
        avgStar: avgStar,
        totalUser: totalUser,
        totalLessons: totalLessons,
        salePrice: salePrice,
        totalPrice: totalPrice,
        selectedTabIndex: _selectedTabIndex,
        tabs: _tabs,
        onTabSelected: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
      ),
    );
  }

  List<Widget> _buildAboutTab(CourseDetail? apiCourse) {
    return [
      SliverToBoxAdapter(
        child: CourseDescriptionSectionWidget(
          description: apiCourse?.description,
        ),
      ),
      SliverToBoxAdapter(
        child: CourseInstructorSectionWidget(
          userName: apiCourse?.userName,
        ),
      ),
      SliverToBoxAdapter(
        child: CourseBenefitsSectionWidget(
          infoCourse: apiCourse?.infoCourse,
        ),
      ),
      SliverToBoxAdapter(
        child: CourseReviewsSectionWidget(
          avgStar: apiCourse?.avgStar ?? 0.0,
          totalUser: apiCourse?.totalUser ?? 0,
        ),
      ),
    ];
  }

  Widget _buildCurriculumTab(CourseDetail? apiCourse) {
    final parts = apiCourse?.parts ?? [];

    return SliverToBoxAdapter(
      child: CourseCurriculumWidget(
        parts: parts,
        courseId: apiCourse?.id ?? widget.course.id ?? '',
        courseTitle: apiCourse?.title ?? widget.course.title ?? '',
        onExerciseTap: (exercise) => _showExercisePopup(exercise),
        onLessonContentTap: (lesson) => _showContentPopup(lesson),
      ),
    );
  }

  Widget _buildEnrollButton() {
    return SliverToBoxAdapter(
      child: EnrollButtonWidget(
        course: widget.course,
      ),
    );
  }

  void _showExercisePopup(Exercise exercise) {
    ExerciseDialog.show(context, exercise);
  }

  void _showContentPopup(Lesson lesson) {
    LessonContentDialog.show(context, lesson);
  }
}

