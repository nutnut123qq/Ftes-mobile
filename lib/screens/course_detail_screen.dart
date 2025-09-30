import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/models/course_item.dart';
import 'package:ftes/routes/app_routes.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseItem course;

  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  int _selectedTabIndex = 1;
  final List<String> _tabs = ['Giới thiệu', 'Chương trình học'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: CustomScrollView(
        slivers: [
          // Hero Image with App Bar
          _buildHeroSection(),
          
          // Course Info Card
          SliverToBoxAdapter(
            child: _buildCourseInfoCard(),
          ),
          
          // Conditional content based on selected tab
          if (_selectedTabIndex == 0) ...[
            // About tab content
            SliverToBoxAdapter(
              child: _buildInstructorSection(),
            ),
            SliverToBoxAdapter(
              child: _buildWhatYoullGetSection(),
            ),
            SliverToBoxAdapter(
              child: _buildReviewsSection(),
            ),
          ],
          
          // Enroll Button
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
  }

  Widget _buildHeroSection() {
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
              widget.course.imageUrl,
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
                  // Video play functionality - placeholder for future implementation
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

  Widget _buildCourseInfoCard() {
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
          // Category
          Text(
            widget.course.category,
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(0xFFFF6B00),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Title
          Text(
            'Nguyên tắc thiết kế: Tổ chức...',
            style: AppTextStyles.h4.copyWith(
              color: const Color(0xFF202244),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Course Stats
          Row(
            children: [
              // Classes
              Row(
                children: [
                  const Icon(
                    Icons.video_library,
                    color: Color(0xFF202244),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '21 Bài học',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // Duration
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xFF202244),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '42 Giờ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Price
              Text(
                '499/-',
                style: AppTextStyles.h4.copyWith(
                  color: const Color(0xFF0961F5),
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Rating
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Color(0xFFFFD700),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '4.2',
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Tab Navigation
          _buildTabNavigation(),
          
          const SizedBox(height: 20),
          
          // Tab Content
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE8F1FF),
          width: 2,
        ),
      ),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          int index = entry.key;
          String tab = entry.value;
          bool isSelected = index == _selectedTabIndex;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE8F1FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: AppTextStyles.body1.copyWith(
                      color: isSelected ? const Color(0xFF0961F5) : const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTabIndex == 0) {
      return _buildAboutContent();
    } else {
      return _buildCurriculumContent();
    }
  }

  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main description
        Text(
          'Thiết kế đồ họa hiện là một nghề phổ biến, thiết kế đồ họa giúp phát triển sự nghiệp của bạn trong nhiều lĩnh vực khác nhau',
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFFA0A4AB),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Extended description with Read More
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Thiết kế đồ họa là một nghề phổ biến trong thời đại số hiện tại. Khóa học này sẽ dạy bạn những kiến thức cơ bản về thiết kế đồ họa, bao gồm lý thuyết màu sắc, typography, nguyên tắc bố cục và phần mềm thiết kế. Bạn sẽ học cách tạo ra những thiết kế hấp dẫn về mặt thị giác và giao tiếp hiệu quả với khán giả. Khóa học bao gồm cả khái niệm lý thuyết và ứng dụng thực tế thông qua các dự án thực hành.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFFA0A4AB),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: ' Đọc thêm',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF0961F5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Course Features Section
        Text(
          'Bạn sẽ học được:',
          style: AppTextStyles.h5.copyWith(
            color: const Color(0xFF202244),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Feature list
        ..._buildFeatureList(),
        
        const SizedBox(height: 24),
        
        // Prerequisites Section
        Text(
          'Yêu cầu:',
          style: AppTextStyles.h5.copyWith(
            color: const Color(0xFF202244),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Text(
          '• Kỹ năng máy tính cơ bản\n• Không cần kinh nghiệm thiết kế trước đó\n• Truy cập phần mềm thiết kế (sẽ được cung cấp)',
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFFA0A4AB),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
        ),
      ],
    );
  }
  
  List<Widget> _buildFeatureList() {
    final features = [
      'Nắm vững kiến thức cơ bản về thiết kế đồ họa',
      'Học lý thuyết màu sắc và typography',
      'Tạo thiết kế chuyên nghiệp bằng công cụ ngành',
      'Xây dựng portfolio các dự án thiết kế',
      'Hiểu nguyên tắc thiết kế và bố cục',
      'Làm việc với khách hàng và hiểu brief thiết kế',
    ];
    
    return features.map((feature) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF0961F5),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              feature,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFFA0A4AB),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildCurriculumContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 01 - Introduction
        _buildCurriculumSection(
          sectionNumber: '01',
          sectionTitle: 'Giới thiệu',
          duration: '25 Phút',
        ),
        
        const SizedBox(height: 20),
        
        // Lesson 01
        _buildCurriculumLesson(
          lessonNumber: '01',
          lessonTitle: 'Tại sao sử dụng thiết kế đồ họa...',
          duration: '15 Phút',
        ),
        
        // Lesson 02
        _buildCurriculumLesson(
          lessonNumber: '02',
          lessonTitle: 'Thiết lập thiết kế đồ họa...',
          duration: '10 Phút',
        ),
        
        const SizedBox(height: 20),
        
        // Section 02 - Graphic Design
        _buildCurriculumSection(
          sectionNumber: '02',
          sectionTitle: 'Thiết kế đồ họa',
          duration: '55 Phút',
        ),
      ],
    );
  }
  
  Widget _buildCurriculumSection({
    required String sectionNumber,
    required String sectionTitle,
    required String duration,
  }) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Phần $sectionNumber - ',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: sectionTitle,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF0961F5),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          duration,
          style: AppTextStyles.bodySmall.copyWith(
            color: const Color(0xFF0961F5),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCurriculumLesson({
    required String lessonNumber,
    required String lessonTitle,
    required String duration,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Lesson number circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                lessonNumber,
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Lesson details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lessonTitle,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          
          // Play button
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0961F5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorSection() {
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(27),
                  child: Image.network(
                    'https://via.placeholder.com/54x54/000000/FFFFFF?text=R',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE8F1FF),
                        child: const Center(
                          child: Text(
                            'R',
                            style: TextStyle(
                              color: Color(0xFF0961F5),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Instructor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Robert jr',
                      style: AppTextStyles.h5.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      'Thiết kế đồ họa',
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
        ],
      ),
    );
  }

  Widget _buildWhatYoullGetSection() {
    final features = [
      {'icon': Icons.video_library, 'text': '25 Bài học'},
      {'icon': Icons.devices, 'text': 'Truy cập Mobile, Desktop & TV'},
      {'icon': Icons.school, 'text': 'Cấp độ cơ bản'},
      {'icon': Icons.headphones, 'text': 'Sách nói'},
      {'icon': Icons.all_inclusive, 'text': 'Truy cập trọn đời'},
      {'icon': Icons.quiz, 'text': '100 Bài kiểm tra'},
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
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
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
          
          // Review 1
          _buildReviewCard(
            name: 'Will',
            avatar: 'https://via.placeholder.com/46x46/000000/FFFFFF?text=W',
            rating: 4.5,
            comment: 'Khóa học này rất hữu ích. Giảng viên nói rất hay, tôi hoàn toàn yêu thích.',
            likes: 578,
            timeAgo: '2 tuần trước',
          ),
          
          const SizedBox(height: 16),
          
          // Review 2
          _buildReviewCard(
            name: 'Martha E. Thompson',
            avatar: 'https://via.placeholder.com/46x46/000000/FFFFFF?text=M',
            rating: 4.5,
            comment: 'Khóa học này rất hữu ích. Giảng viên nói rất hay, tôi hoàn toàn yêu thích. Các buổi học cũng rất thú vị.',
            likes: 578,
            timeAgo: '2 tuần trước',
          ),
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
                child: ClipRRect(
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

  Widget _buildEnrollButton() {
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToPayment(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 39, vertical: 20),
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
            'Đăng ký khóa học - 499/-',
            style: AppTextStyles.buttonLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Color(0xFF0961F5),
              size: 16,
            ),
          ),
        ],
      ),
    ),
    );
  }
}

