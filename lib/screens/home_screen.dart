import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/routes/app_routes.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';
import 'package:ftes/screens/notification_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'Tất cả',
    'Thiết kế đồ họa',
    'Thiết kế 3D',
    'Nghệ thuật & Nhân văn',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Bar
              const SizedBox(height: 20),
              
              // Navigation Bar
              _buildNavigationBar(),
              
              const SizedBox(height: 20),
              
              // Search Bar
              _buildSearchBar(),
              
              const SizedBox(height: 30),
              
              // Offer Banner
              _buildOfferBanner(),
              
              const SizedBox(height: 30),
              
              // Popular Courses Section
              _buildPopularCoursesSection(),
              
              const SizedBox(height: 40),
              
              // Top Mentor Section
              _buildTopMentorSection(),
              
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(selectedIndex: 0),
    );
  }

  Widget _buildNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào, ALEX',
                  style: AppTextStyles.heading1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Bạn muốn học gì hôm nay? Tìm kiếm bên dưới.',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454).withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Notifications
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationListScreen(),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF202244),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Container(
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
            const SizedBox(width: 13),
            const Icon(
              Icons.search,
              color: Color(0xFFB4BDC4),
              size: 20,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                'Tìm kiếm...',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFFB4BDC4),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.only(right: 13),
              decoration: BoxDecoration(
                color: const Color(0xFF0961F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFF0961F5),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 200,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(22),
                    bottomLeft: Radius.circular(100),
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giảm 25%*',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Ưu đãi hôm nay',
                    style: AppTextStyles.heading1.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      'Nhận giảm giá cho mọi đơn hàng khóa học chỉ có hiệu lực hôm nay!',
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Pagination dots
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPaginationDot(true),
                  const SizedBox(width: 8),
                  _buildPaginationDot(false),
                  const SizedBox(width: 8),
                  _buildPaginationDot(false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }


  Widget _buildPopularCoursesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Khóa học phổ biến',
                style: AppTextStyles.heading1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppRoutes.navigateToPopularCourses(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Xem tất cả',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF0961F5),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF0961F5),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Category filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.asMap().entries.map((entry) {
                int index = entry.key;
                String category = entry.value;
                bool isSelected = index == _selectedCategoryIndex;
                
                return Padding(
                  padding: EdgeInsets.only(right: index < _categories.length - 1 ? 12 : 0),
                  child: _buildCategoryFilter(category, isSelected, index),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Course cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCourseCard(
                  'Thiết kế đồ họa',
                  'Thiết kế đồ họa nâng cao',
                  '28\$',
                  '4.2',
                  '7830 HV',
                ),
                const SizedBox(width: 20),
                _buildCourseCard(
                  'Thiết kế đồ họa',
                  'Thiết kế quảng cáo',
                  '42\$',
                  '4.2',
                  '12580 HV',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(String text, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF167F71) : const Color(0xFFE8F1FF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: AppTextStyles.body1.copyWith(
            color: isSelected ? Colors.white : const Color(0xFF202244),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(String category, String title, String price, String rating, String students) {
    return Container(
      width: 280,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Course image
          Container(
            height: 134,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFFFF6B00),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.heading1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            price,
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF0961F5),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '|',
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            rating,
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF202244),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '|',
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            students,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopMentorSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giảng viên hàng đầu',
                style: AppTextStyles.heading1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppRoutes.navigateToTopMentors(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Xem tất cả',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF0961F5),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF0961F5),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMentorCard('Jiya'),
                const SizedBox(width: 18),
                _buildMentorCard('Aman'),
                const SizedBox(width: 18),
                _buildMentorCard('Rahul.J'),
                const SizedBox(width: 18),
                _buildMentorCard('Manav'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard(String name) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

}