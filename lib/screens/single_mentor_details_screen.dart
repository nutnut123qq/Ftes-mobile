import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';
import 'package:ftes/models/course_item.dart';
import 'package:ftes/models/mentor_item.dart';
import 'package:ftes/routes/app_routes.dart';

class SingleMentorDetailsScreen extends StatefulWidget {
  final MentorItem mentor;
  
  const SingleMentorDetailsScreen({super.key, required this.mentor});

  @override
  State<SingleMentorDetailsScreen> createState() => _SingleMentorDetailsScreenState();
}

class _SingleMentorDetailsScreenState extends State<SingleMentorDetailsScreen> {
  int _selectedTabIndex = 0; // 0: Courses, 1: Blog

  // Sample courses data for this mentor
  final List<CourseItem> _courses = [
    CourseItem(
      id: 'mentor_course_1',
      category: 'Thiết kế đồ họa',
      title: 'Thiết kế đồ họa nâng cao',
      price: '799/-',
      originalPrice: '\$42',
      rating: '4.2',
      students: '7830 HV',
      imageUrl: 'https://via.placeholder.com/80x80/000000/FFFFFF?text=Course',
    ),
    CourseItem(
      id: 'mentor_course_2',
      category: 'Thiết kế UI/UX',
      title: 'Cơ bản về Thiết kế UI/UX',
      price: '599/-',
      originalPrice: '\$35',
      rating: '4.5',
      students: '990 HV',
      imageUrl: 'https://via.placeholder.com/80x80/000000/FFFFFF?text=Course',
    ),
    CourseItem(
      id: 'mentor_course_3',
      category: 'Thiết kế Web',
      title: 'Cơ bản về Thiết kế Web',
      price: '899/-',
      originalPrice: '\$50',
      rating: '4.8',
      students: '1200 HV',
      imageUrl: 'https://via.placeholder.com/80x80/000000/FFFFFF?text=Course',
    ),
  ];

  // Sample ratings data for this mentor
  late final List<Map<String, dynamic>> _ratings;

  @override
  void initState() {
    super.initState();
    _ratings = [
      {
        'name': 'Sarah Johnson',
        'rating': 5.0,
        'comment': 'Khóa học xuất sắc! ${widget.mentor.name} giải thích mọi thứ rất rõ ràng và các dự án rất thực tế.',
        'date': '2 ngày trước',
        'avatar': 'https://via.placeholder.com/40x40/000000/FFFFFF?text=SJ',
      },
      {
        'name': 'Michael Chen',
        'rating': 4.5,
        'comment': 'Nội dung tuyệt vời và được cấu trúc tốt. Tôi đã học được rất nhiều về nguyên tắc thiết kế.',
        'date': '1 tuần trước',
        'avatar': 'https://via.placeholder.com/40x40/000000/FFFFFF?text=MC',
      },
      {
        'name': 'Emily Davis',
        'rating': 5.0,
        'comment': 'Giảng viên tuyệt vời! Khóa học vượt quá mong đợi của tôi. Rất được khuyến nghị.',
        'date': '2 tuần trước',
        'avatar': 'https://via.placeholder.com/40x40/000000/FFFFFF?text=ED',
      },
      {
        'name': 'David Wilson',
        'rating': 4.0,
        'comment': 'Khóa học tổng thể tốt. Một số phần có thể chi tiết hơn nhưng vẫn có giá trị.',
        'date': '3 tuần trước',
        'avatar': 'https://via.placeholder.com/40x40/000000/FFFFFF?text=DW',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(),
              _buildProfileDetailsCard(),
              _buildTabNavigation(),
              if (_selectedTabIndex == 0) _buildCoursesList() else _buildBlogList(),
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(selectedIndex: 0),
    );
  }

  Widget _buildProfileHeader() {
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
        padding: const EdgeInsets.fromLTRB(34, 74, 34, 24),
        child: Column(
          children: [
            // Back Button
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
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
            ),
            
            const SizedBox(height: 42),
            
            // Avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(60),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  widget.mentor.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        widget.mentor.name.isNotEmpty ? widget.mentor.name[0].toUpperCase() : 'M',
                        style: AppTextStyles.heading1.copyWith(
                          color: const Color(0xFF0961F5),
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Name
            Text(
              widget.mentor.name,
              style: AppTextStyles.heading1.copyWith(
                color: const Color(0xFF202244),
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Title
            Text(
              'Chuyên gia ${widget.mentor.specialization}',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF545454),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Stats
            _buildStats(),
            
            const SizedBox(height: 40),
            
            // Social Media Icons
            _buildSocialIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem('26', 'Courses'),
        ),
        Expanded(
          child: _buildStatItem('15800', 'Students'),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.heading1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(Icons.facebook, 'Facebook'),
        const SizedBox(width: 24),
        _buildSocialIcon(Icons.code, 'GitHub'),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String platform) {
    return GestureDetector(
      onTap: () {
        // Handle social media navigation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đang mở $platform...'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF0961F5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildProfileDetailsCard() {
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
      child: Text(
        '"Đam mê về ${widget.mentor.specialization.toLowerCase()} và giúp học viên đạt được mục tiêu sáng tạo của họ. Với nhiều năm kinh nghiệm trong ngành, tôi mang đến những hiểu biết thực tế cho mỗi khóa học."',
        style: AppTextStyles.body1.copyWith(
          color: const Color(0xFFA0A4AB),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34, vertical: 20),
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0 ? const Color(0xFFF5F9FF) : const Color(0xFFE8F1FF),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Khóa học',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1 ? const Color(0xFFF5F9FF) : const Color(0xFFE8F1FF),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Blog',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Courses',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _courses.length,
            itemBuilder: (context, index) {
              return _buildCourseCard(_courses[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(CourseItem course, int index) {
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToCurriculum(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
        children: [
          // Course Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              course.imageUrl,
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
          
          const SizedBox(width: 16),
          
          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  course.category,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFFF6B35),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Title
                Text(
                  course.title,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Price and Rating
                Row(
                  children: [
                    // Price
                    Text(
                      course.price,
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF0961F5),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    
                    if (course.originalPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        course.originalPrice!,
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFFB4BDC4),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    
                    const Spacer(),
                    
                    // Students
                    Text(
                      course.students,
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Bookmark Icon
          GestureDetector(
            onTap: () {
              // Handle bookmark toggle
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.bookmark,
                color: index == 0 ? const Color(0xFF167F71) : const Color(0xFFA0A4AB),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildBlogList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Blog Posts',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _ratings.length,
            itemBuilder: (context, index) {
              return _buildRatingCard(_ratings[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(Map<String, dynamic> rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar, name, rating, and date
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  rating['avatar'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      color: Color(0xFF0961F5),
                      size: 20,
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Name and rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating['name'],
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        // Star rating
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating['rating'] ? Icons.star : Icons.star_border,
                            color: const Color(0xFFFFD700),
                            size: 14,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          rating['rating'].toString(),
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF202244),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Date
              Text(
                rating['date'],
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFFA0A4AB),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Comment
          Text(
            rating['comment'],
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

