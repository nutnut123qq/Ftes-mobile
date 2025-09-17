import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import '../routes/app_routes.dart';
import '../widgets/bottom_navigation_bar.dart';

class MyCourseOngoingScreen extends StatefulWidget {
  const MyCourseOngoingScreen({Key? key}) : super(key: key);

  @override
  State<MyCourseOngoingScreen> createState() => _MyCourseOngoingScreenState();
}

class _MyCourseOngoingScreenState extends State<MyCourseOngoingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Ongoing';
  
  // Sample ongoing courses data
  final List<Map<String, dynamic>> _ongoingCourses = [
    {
      'id': 1,
      'title': 'Intro to UI/UX Design',
      'category': 'UI/UX Design',
      'imageUrl': 'https://via.placeholder.com/130x134',
      'rating': 4.4,
      'duration': '3 Hrs 06 Mins',
      'progress': 93,
      'totalLessons': 125,
      'completedLessons': 93,
      'progressColor': const Color(0xFF167F71),
    },
    {
      'id': 2,
      'title': 'Wordpress website Development',
      'category': 'Web Development',
      'imageUrl': 'https://via.placeholder.com/130x134',
      'rating': 3.9,
      'duration': '1 Hrs 58 Mins',
      'progress': 39,
      'totalLessons': 31,
      'completedLessons': 12,
      'progressColor': const Color(0xFFFCCB40),
    },
    {
      'id': 3,
      'title': '3D Blender and UI/UX',
      'category': 'UI/UX Design',
      'imageUrl': 'https://via.placeholder.com/130x134',
      'rating': 4.6,
      'duration': '2 Hrs 46 Mins',
      'progress': 57,
      'totalLessons': 98,
      'completedLessons': 56,
      'progressColor': const Color(0xFFFF6B00),
    },
    {
      'id': 4,
      'title': 'Learn UX User Persona',
      'category': 'UX/UI Design',
      'imageUrl': 'https://via.placeholder.com/130x134',
      'rating': 3.9,
      'duration': '1 Hrs 58 Mins',
      'progress': 83,
      'totalLessons': 35,
      'completedLessons': 29,
      'progressColor': const Color(0xFFFCCB40),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilterTabs(),
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
      padding: const EdgeInsets.fromLTRB(35, 25, 35, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 26,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF202244),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'My Courses',
              style: AppTextStyles.heading1.copyWith(
                color: const Color(0xFF202244),
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(34, 0, 34, 20),
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
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 21),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for ...',
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
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(right: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search,
              color: Color(0xFF0961F5),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(34, 0, 34, 20),
      child: Row(
        children: [
          // Completed Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = 'Completed';
                });
                // Navigate to completed courses
                Navigator.pop(context);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'Completed',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Ongoing Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = 'Ongoing';
                });
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF167F71),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'Ongoing',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(34, 0, 34, 100),
      child: Column(
        children: _ongoingCourses.map((course) => _buildCourseCard(course)).toList(),
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
        margin: const EdgeInsets.only(bottom: 20),
        height: 134,
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
            // Course Image
            Container(
              width: 130,
              height: 134,
              decoration: BoxDecoration(
                color: Colors.black,
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
                    color: Colors.white,
                    size: 40,
                  );
                },
              ),
            ),
            
            // Course Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        Text(
                          course['category'],
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFFFF6B00),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        
                        const SizedBox(height: 3),
                        
                        // Title
                        Text(
                          course['title'],
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF202244),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Rating and Duration
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFD700),
                              size: 10,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              course['rating'].toString(),
                              style: AppTextStyles.body1.copyWith(
                                color: const Color(0xFF202244),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '|',
                              style: AppTextStyles.body1.copyWith(
                                color: const Color(0xFF202244),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                course['duration'],
                                style: AppTextStyles.body1.copyWith(
                                  color: const Color(0xFF202244),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Bottom Section - Progress Bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F9FF),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFFE8F1FF),
                                width: 1,
                              ),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: course['progress'] / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: course['progressColor'],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${course['completedLessons']}/${course['totalLessons']}',
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF202244),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

