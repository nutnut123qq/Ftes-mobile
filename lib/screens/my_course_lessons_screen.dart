import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import '../routes/app_routes.dart';

class MyCourseLessonsScreen extends StatefulWidget {
  final String courseTitle;
  final String courseImage;
  
  const MyCourseLessonsScreen({
    Key? key,
    required this.courseTitle,
    required this.courseImage,
  }) : super(key: key);

  @override
  State<MyCourseLessonsScreen> createState() => _MyCourseLessonsScreenState();
}

class _MyCourseLessonsScreenState extends State<MyCourseLessonsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Sample curriculum data
  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Section 01 - Introduction',
      'duration': '25 Mins',
      'lessons': [
        {
          'number': '01',
          'title': 'Why Using 3D Blender',
          'duration': '15 Mins',
          'isCompleted': true,
        },
        {
          'number': '02',
          'title': '3D Blender Installation',
          'duration': '10 Mins',
          'isCompleted': true,
        },
      ],
    },
    {
      'title': 'Section 02 - Graphic Design',
      'duration': '125 Mins',
      'lessons': [
        {
          'number': '03',
          'title': 'Take a Look Blender Interface',
          'duration': '20 Mins',
          'isCompleted': true,
        },
        {
          'number': '04',
          'title': 'The Basic of 3D Modelling',
          'duration': '25 Mins',
          'isCompleted': false,
        },
        {
          'number': '05',
          'title': 'Shading and Lighting',
          'duration': '36 Mins',
          'isCompleted': false,
        },
        {
          'number': '06',
          'title': 'Using Graphic Plugins',
          'duration': '10 Mins',
          'isCompleted': false,
        },
      ],
    },
    {
      'title': 'Section 03 - Let\'s Practice',
      'duration': '35 Mins',
      'lessons': [],
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
            Expanded(
              child: _buildCurriculumList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
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
          Text(
            'My Courses',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 21,
              fontWeight: FontWeight.w600,
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
                  hintText: widget.courseTitle,
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

  Widget _buildCurriculumList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(34, 0, 34, 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
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
              children: _sections.map((section) => _buildSection(section)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  section['title'],
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                section['duration'],
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF0961F5),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        
        // Lessons
        if (section['lessons'].isNotEmpty)
          ...section['lessons'].map((lesson) => _buildLesson(lesson, section)).toList(),
        
        // Add spacing between sections
        if (section != _sections.last)
          const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLesson(Map<String, dynamic> lesson, Map<String, dynamic> section) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              // Lesson Number Circle
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: lesson['isCompleted'] 
                      ? const Color(0xFF0961F5) 
                      : const Color(0xFFE8F1FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    lesson['number'],
                    style: AppTextStyles.body1.copyWith(
                      color: lesson['isCompleted'] 
                          ? Colors.white 
                          : const Color(0xFF202244),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Lesson Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson['title'],
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson['duration'],
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF545454),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Play/Check Icon
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: lesson['isCompleted'] 
                      ? const Color(0xFF0961F5) 
                      : const Color(0xFFB4BDC4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  lesson['isCompleted'] ? Icons.check : Icons.play_arrow,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ],
          ),
          
          // Divider
          if (lesson != section['lessons'].last)
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: 1,
              color: const Color(0xFFE8F1FF),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(34, 27, 34, 34),
        child: Row(
          children: [
            // Certificate Button
            GestureDetector(
              onTap: () {
                _showCertificate();
              },
              child: Container(
                width: 94,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFFB4BDC4).withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Color(0xFF0961F5),
                  size: 24,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Start Course Again Button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _startCourseAgain();
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0961F5),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start Course Again',
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCertificate() {
    AppRoutes.navigateToCertificate(
      context,
      courseTitle: widget.courseTitle,
      studentName: 'Alex', // Default student name
      completionDate: 'November 24, 2022',
      certificateId: 'SK24568086',
    );
  }

  void _startCourseAgain() {
    // Handle start course again action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting course again...'),
        backgroundColor: Color(0xFF0961F5),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
