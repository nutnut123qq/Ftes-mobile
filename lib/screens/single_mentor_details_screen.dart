import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
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
  int _selectedTabIndex = 0; // 0: Courses, 1: Ratings

  // Sample courses data for this mentor
  final List<CourseItem> _courses = [
    CourseItem(
      category: 'Graphic Design',
      title: 'Graphic Design Advanced',
      price: '799/-',
      originalPrice: '\$42',
      rating: '4.2',
      students: '7830 Std',
      imageUrl: 'https://via.placeholder.com/80x80/000000/FFFFFF?text=Course',
    ),
    CourseItem(
      category: 'UI/UX Design',
      title: 'UI/UX Design Basics',
      price: '599/-',
      originalPrice: '\$35',
      rating: '4.5',
      students: '990 Std',
      imageUrl: 'https://via.placeholder.com/80x80/000000/FFFFFF?text=Course',
    ),
    CourseItem(
      category: 'Web Design',
      title: 'Web Design Fundamentals',
      price: '899/-',
      originalPrice: '\$50',
      rating: '4.8',
      students: '1200 Std',
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
        'comment': 'Excellent course! ${widget.mentor.name} explains everything clearly and the projects are very practical.',
        'date': '2 days ago',
        'avatar': 'https://via.placeholder.com/40x40/000000/FFFFFF?text=SJ',
      },
      {
        'name': 'Michael Chen',
        'rating': 4.5,
        'comment': 'Great content and well-structured. Learned a lot about design principles.',
        'date': '1 week ago',
        'avatar': 'https://via.placeholder.com/40x40/000000/FFFFFF?text=MC',
      },
      {
        'name': 'Emily Davis',
        'rating': 5.0,
        'comment': 'Amazing instructor! The course exceeded my expectations. Highly recommended.',
        'date': '2 weeks ago',
        'avatar': 'https://via.placeholder.com/40x40/000000/FFFFFF?text=ED',
      },
      {
        'name': 'David Wilson',
        'rating': 4.0,
        'comment': 'Good course overall. Some sections could be more detailed but still valuable.',
        'date': '3 weeks ago',
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
              if (_selectedTabIndex == 0) _buildCoursesList() else _buildRatingsList(),
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
              '${widget.mentor.specialization} Expert',
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
            
            // Action Buttons
            _buildActionButtons(),
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
        Expanded(
          child: _buildStatItem('8750', 'Ratings'),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFB4BDC4).withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                'Follow',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: const Color(0xFF202244),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 56,
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
            child: Center(
              child: Text(
                'Message',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ],
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
        '"Passionate about ${widget.mentor.specialization.toLowerCase()} and helping students achieve their creative goals. With years of experience in the industry, I bring real-world insights to every course."',
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
                    'Courses',
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
                    'Ratings',
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
                    
                    // Rating
                    const Icon(
                      Icons.star,
                      color: Color(0xFFFFD700),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      course.rating,
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
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

  Widget _buildRatingsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Ratings & Reviews',
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
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToReviews(context);
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
    ),
    );
  }
}

