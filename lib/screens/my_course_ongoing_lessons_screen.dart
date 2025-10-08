import 'package:flutter/material.dart';
import '../utils/text_styles.dart';
import '../routes/app_routes.dart';

class MyCourseOngoingLessonsScreen extends StatefulWidget {
  final String courseTitle;
  final String courseImage;

  const MyCourseOngoingLessonsScreen({
    super.key,
    required this.courseTitle,
    required this.courseImage,
  });

  @override
  State<MyCourseOngoingLessonsScreen> createState() => _MyCourseOngoingLessonsScreenState();
}

class _MyCourseOngoingLessonsScreenState extends State<MyCourseOngoingLessonsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Sample curriculum data
  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Phần 01 - Giới thiệu',
      'duration': '25 Phút',
      'lessons': [
        {
          'id': 1,
          'title': 'Tại sao sử dụng Thiết kế đồ họa',
          'duration': '15 Phút',
          'isCompleted': true,
        },
        {
          'id': 2,
          'title': 'Thiết lập Thiết kế đồ họa',
          'duration': '10 Phút',
          'isCompleted': true,
        },
      ],
    },
    {
      'title': 'Phần 02 - Thiết kế đồ họa',
      'duration': '55 Phút',
      'lessons': [
        {
          'id': 3,
          'title': 'Tìm hiểu Thiết kế đồ họa',
          'duration': '08 Phút',
          'isCompleted': false,
        },
        {
          'id': 4,
          'title': 'Làm việc với Thiết kế đồ họa',
          'duration': '25 Phút',
          'isCompleted': false,
        },
        {
          'id': 5,
          'title': 'Làm việc với Khung & Bố cục',
          'duration': '12 Phút',
          'isCompleted': false,
        },
        {
          'id': 6,
          'title': 'Sử dụng Plugin đồ họa',
          'duration': '10 Phút',
          'isCompleted': false,
        },
      ],
    },
    {
      'title': 'Phần 03 - Thực hành',
      'duration': '35 Phút',
      'lessons': [
        {
          'id': 7,
          'title': 'Thiết kế Form đăng ký',
          'duration': '15 Phút',
          'isCompleted': false,
        },
        {
          'id': 8,
          'title': 'Chia sẻ công việc với nhóm',
          'duration': '20 Phút',
          'isCompleted': false,
        },
      ],
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
              child: _buildCurriculum(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
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
              'Khóa học của tôi',
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

  Widget _buildCurriculum() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(34, 0, 34, 20),
      child: Container(
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
    );
  }

  Widget _buildSection(Map<String, dynamic> section) {
    return Column(
      children: [
        // Section Header
        Container(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
          child: Row(
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
        ...section['lessons'].map<Widget>((lesson) => _buildLesson(lesson, section)).toList(),
      ],
    );
  }

  Widget _buildLesson(Map<String, dynamic> lesson, Map<String, dynamic> section) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to video player
              AppRoutes.navigateToMyCourseOngoingVideo(
                context,
                lessonTitle: lesson['title'],
                courseTitle: widget.courseTitle,
                videoUrl: 'https://example.com/video/${lesson['id']}.mp4',
                currentTime: lesson['isCompleted'] ? 0 : 274, // 4:34 in seconds
                totalTime: _parseDurationToSeconds(lesson['duration']),
              );
            },
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
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
                        lesson['id'].toString().padLeft(2, '0'),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            lesson['title'],
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF202244),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                  
                  const SizedBox(width: 8),
                  
                  // Play/Check Icon
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Icon(
                      lesson['isCompleted'] ? Icons.check : Icons.play_arrow,
                      color: lesson['isCompleted'] 
                          ? const Color(0xFF0961F5) 
                          : const Color(0xFF545454),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Divider
          if (lesson != section['lessons'].last)
            Container(
              height: 1,
              color: const Color(0xFFE8F1FF),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
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
        padding: const EdgeInsets.fromLTRB(39, 27, 39, 20),
        child: GestureDetector(
          onTap: () {
            // Continue to next lesson
            _continueCourse();
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
                Flexible(
                  child: Text(
                    'Continue Courses',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
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
    );
  }

  void _continueCourse() {
    // Find next incomplete lesson
    for (var section in _sections) {
      for (var lesson in section['lessons']) {
        if (!lesson['isCompleted']) {
          AppRoutes.navigateToMyCourseOngoingVideo(
            context,
            lessonTitle: lesson['title'],
            courseTitle: widget.courseTitle,
            videoUrl: 'https://example.com/video/${lesson['id']}.mp4',
            currentTime: 0,
            totalTime: _parseDurationToSeconds(lesson['duration']),
          );
          return;
        }
      }
    }
    
    // If all lessons completed, show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chúc mừng! Bạn đã hoàn thành ${widget.courseTitle}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  int _parseDurationToSeconds(String duration) {
    // Parse duration like "15 Mins" to seconds
    final match = RegExp(r'(\d+)').firstMatch(duration);
    if (match != null) {
      return int.parse(match.group(1)!) * 60; // Convert minutes to seconds
    }
    return 0;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
