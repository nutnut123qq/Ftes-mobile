import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/routes/app_routes.dart';

class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});

  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  // Sample curriculum data
  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Phần 1 - Giới thiệu',
      'lessons': [
        {
          'number': '01',
          'title': 'Tại sao sử dụng Thiết kế đồ họa...',
          'isCompleted': false,
        },
        {
          'number': '02',
          'title': 'Thiết lập Thiết kế đồ họa...',
          'isCompleted': false,
        },
      ],
    },
    {
      'title': 'Phần 2 - Thiết kế đồ họa',
      'lessons': [
        {
          'number': '03',
          'title': 'Tìm hiểu Thiết kế đồ họa...',
          'isCompleted': false,
        },
        {
          'number': '04',
          'title': 'Làm việc với Thiết kế đồ họa...',
          'isCompleted': false,
        },
        {
          'number': '05',
          'title': 'Làm việc với Khung & Bố cục...',
          'isCompleted': false,
        },
        {
          'number': '06',
          'title': 'Sử dụng Plugin đồ họa',
          'isCompleted': false,
        },
      ],
    },
    {
      'title': 'Phần 3 - Thực hành',
      'lessons': [
        {
          'number': '07',
          'title': 'Thiết kế Form đăng ký...',
          'isCompleted': false,
        },
        {
          'number': '08',
          'title': 'Chia sẻ công việc với nhóm',
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildCurriculumContent(),
              _buildEnrollButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
            'Chương trình học',
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

  Widget _buildCurriculumContent() {
    return Container(
      margin: const EdgeInsets.fromLTRB(34, 20, 34, 0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Course Title
          Text(
            'Khóa học Thiết kế đồ họa nâng cao',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Sections
          ..._sections.map((section) => _buildSection(section)),
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
          padding: const EdgeInsets.symmetric(vertical: 8),
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
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Lessons
        ...section['lessons'].map<Widget>((lesson) => _buildLesson(lesson)).toList(),
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLesson(Map<String, dynamic> lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Lesson Number Circle
          Container(
            width: 32,
            height: 32,
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
              ],
            ),
          ),
          
          // Play/Check Icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: lesson['isCompleted'] 
                  ? const Color(0xFF0961F5) 
                  : const Color(0xFFE8F1FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              lesson['isCompleted'] ? Icons.check : Icons.play_arrow,
              color: lesson['isCompleted'] 
                  ? Colors.white 
                  : const Color(0xFF0961F5),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(39, 20, 39, 0),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppRoutes.navigateToPayment(context);
          },
          borderRadius: BorderRadius.circular(30),
          child: Row(
            children: [
              const SizedBox(width: 20),
              
              // Play Icon
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Color(0xFF0961F5),
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Button Text
              Expanded(
                child: Text(
                  'Đăng ký khóa học - \$55',
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
