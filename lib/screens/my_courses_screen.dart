import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../providers/auth_provider.dart';
import '../models/course_response.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _fetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      
      // Ensure user info is loaded first if not already loaded
      if (auth.isLoggedIn && auth.currentUser == null) {
        await auth.refreshUserInfo();
      }
      
      final userId = auth.currentUser?.id;
      if (userId != null && userId.isNotEmpty) {
        await courseProvider.fetchUserCourses(userId);
        setState(() {
          _fetched = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: _buildCoursesList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(selectedIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 25, 35, 20),
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 26,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF202244),
                  size: 16,
                ),
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Title
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0961F5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Khóa học của tôi',
                    style: AppTextStyles.heading1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(34, 20, 34, 0),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  hintStyle: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFB4BDC4),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  border: InputBorder.none,
                ),
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(
              Icons.search,
              color: Color(0xFFB4BDC4),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCoursesList() {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        final isLoading = courseProvider.isLoadingUserCourses && !_fetched;
        final error = courseProvider.errorMessage;
        final List<CourseResponse> items = courseProvider.userCourses;

        if (isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: CircularProgressIndicator(color: Color(0xFF0961F5)),
            ),
          );
        }

        if (error != null && items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                error,
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'Bạn chưa tham gia khóa học nào',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(34, 20, 34, 100),
          child: Column(
            children: List.generate(items.length, (index) {
              return _buildCourseCardFromUser(items[index]);
            }),
          ),
        );
      },
    );
  }

  Widget _buildCourseCardFromUser(CourseResponse course) {
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToMyCourseOngoingLessons(
          context,
          courseId: course.slugName ?? course.id ?? '',
          courseTitle: course.title ?? 'Course',
          courseImage: course.image ?? '',
        );
      },
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Row(
          children: [
            // Image (same sizing như Popular)
            Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
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
                  course.image ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black,
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Details (phỏng theo Popular, bỏ icon giỏ hàng, thay giá bằng tiến độ)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Text(
                      course.categoryName ?? 'Uncategorized',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFFFF6B00),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Title
                    Text(
                      course.title ?? 'Course',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Rating
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.rating?.toStringAsFixed(1) ?? '0.0'}',
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF202244),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '|',
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF202244),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${course.totalStudents ?? 0} học viên',
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF202244),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
    );
  }
}
