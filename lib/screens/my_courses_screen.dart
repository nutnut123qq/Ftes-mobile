import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/routes/app_routes.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Sample ongoing courses data
  final List<Map<String, dynamic>> _ongoingCourses = [
    {
      'id': '5',
      'category': 'Thiết kế UI/UX',
      'title': 'Cơ bản về Thiết kế UI/UX',
      'rating': 4.5,
      'duration': '1 Giờ 30 Phút',
      'imageUrl': 'https://via.placeholder.com/130x130/000000/FFFFFF?text=Course',
      'isCompleted': false,
      'progress': 65,
    },
    {
      'id': '6',
      'category': 'Phát triển Mobile',
      'title': 'Phát triển Flutter',
      'rating': 4.8,
      'duration': '2 Giờ 15 Phút',
      'imageUrl': 'https://via.placeholder.com/130x130/000000/FFFFFF?text=Course',
      'isCompleted': false,
      'progress': 30,
    },
  ];

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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(34, 20, 34, 100),
      child: Column(
        children: List.generate(_ongoingCourses.length, (index) {
          return _buildCourseCard(_ongoingCourses[index]);
        }),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToMyCourseOngoingLessons(
          context,
          courseTitle: course['title'],
          courseImage: course['imageUrl'],
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(minHeight: 142),
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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Course Image
            Container(
              width: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Image.network(
                course['imageUrl'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.play_circle_outline,
                    color: Color(0xFF0961F5),
                    size: 40,
                  );
                },
              ),
            ),
          
          // Course Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category
                  Text(
                    course['category'],
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFFFF6B00),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Title
                  Flexible(
                    child: Text(
                      course['title'],
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating and Duration
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course['rating'].toString(),
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF202244),
                            fontSize: 11,
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
                        Flexible(
                          child: Text(
                            course['duration'],
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF202244),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Progress Bar for ongoing courses
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${course['progress']}% Hoàn thành',
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFF0961F5),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: course['progress'] / 100,
                        backgroundColor: const Color(0xFFE8F1FF),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0961F5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
              // Menu Icon
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    // Handle menu action
                    _showCourseMenu(course);
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: Color(0xFFB4BDC4),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCourseMenu(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow, color: Color(0xFF0961F5)),
              title: const Text('Tiếp tục học'),
              onTap: () {
                Navigator.pop(context);
                AppRoutes.navigateToCurriculum(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark, color: Color(0xFF0961F5)),
              title: const Text('Thêm vào dấu trang'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã thêm vào dấu trang!'),
                    backgroundColor: Color(0xFF0961F5),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFF0961F5)),
              title: const Text('Chia sẻ khóa học'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tính năng chia sẻ sẽ sớm ra mắt!'),
                    backgroundColor: Color(0xFF0961F5),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
