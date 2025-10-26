import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';
import 'package:ftes/core/di/injection_container.dart' as di;
import 'package:ftes/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/course_card_widget.dart';
import '../widgets/banner_widget.dart';
import '../widgets/category_filter_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'User';
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    // Initialize ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      homeViewModel.initialize();
      homeViewModel.fetchCategories();
    });
  }

  Future<void> _loadUserInfo() async {
    try {
      final prefs = di.sl<SharedPreferences>();
      
      // First try to get from cached user data
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        final username = userMap['username'] as String?;
        final fullName = userMap['fullName'] as String?;
        
        final displayName = fullName?.isNotEmpty == true 
            ? fullName 
            : username?.isNotEmpty == true 
                ? username 
                : 'User';
        
        setState(() {
          _userName = displayName ?? 'User';
        });
        return;
      }
      
      // If no cached data, try to get userId and call profile API
      final userId = prefs.getString('user_id');
      final accessToken = prefs.getString('access_token');
      
      if (userId != null && accessToken != null) {
        await _fetchUserProfile(userId, accessToken);
        return;
      }
      
      // Fallback to 'User'
      setState(() {
        _userName = 'User';
      });
    } catch (e) {
      print('Error loading user info: $e');
      setState(() {
        _userName = 'User';
      });
    }
  }

  Future<void> _fetchUserProfile(String userId, String accessToken) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.ftes.vn/api/profiles/view/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final profileData = response.data['result'];
        final username = profileData['username'] as String?;
        final fullName = profileData['fullName'] as String?;
        
        final displayName = fullName?.isNotEmpty == true 
            ? fullName 
            : username?.isNotEmpty == true 
                ? username 
                : 'User';
        
        setState(() {
          _userName = displayName ?? 'User';
        });
        
        // Cache the profile data for future use
        final prefs = di.sl<SharedPreferences>();
        await prefs.setString('user_data', jsonEncode(profileData));
      } else {
        setState(() {
          _userName = 'User';
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      setState(() {
        _userName = 'User';
      });
    }
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào! 👋',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.grey[600]!,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _userName,
                style: AppTextStyles.h2.copyWith(
                  color: const Color(0xFF202244),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Handle notification tap
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey[600]!,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tìm kiếm khóa học...',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.grey[600]!,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.filter_list,
              color: Colors.grey[600]!,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferBanner() {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        if (homeViewModel.isLoadingBanners) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (homeViewModel.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _bannerController,
                onPageChanged: (index) {
                  setState(() {
                    _currentBannerIndex = index;
                  });
                },
                itemCount: homeViewModel.banners.length,
                itemBuilder: (context, index) {
                  final banner = homeViewModel.banners[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BannerWidget(
                      banner: banner,
                      onTap: () {
                        // Handle banner tap
                        print('Banner tapped: ${banner.title}');
                      },
                    ),
                  );
                },
              ),
            ),
            if (homeViewModel.banners.length > 1) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  homeViewModel.banners.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentBannerIndex == index
                          ? AppColors.primary
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPopularCoursesSection() {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Khóa học phổ biến',
                    style: AppTextStyles.h3.copyWith(
                      color: const Color(0xFF202244),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle see all courses
                    },
                    child: Text(
                      'Xem tất cả',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Category filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: homeViewModel.categories.asMap().entries.map((entry) {
                    int index = entry.key;
                    final category = entry.value;
                    bool isSelected = category.id == homeViewModel.selectedCategoryId;
                    
                    return Padding(
                      padding: EdgeInsets.only(right: index < homeViewModel.categories.length - 1 ? 12 : 0),
                      child: CategoryFilterWidget(
                        text: category.name ?? '',
                        isSelected: isSelected,
                        onTap: () {
                          homeViewModel.fetchCoursesByCategory(category.id ?? 'all');
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Course cards
            if (homeViewModel.isLoadingLatestCourses || homeViewModel.isLoadingCategoryCourses)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (homeViewModel.categoryCourses.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Không có khóa học nào'),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: homeViewModel.categoryCourses.asMap().entries.map((entry) {
                    int index = entry.key;
                    final course = entry.value;
                    
                    return Padding(
                      padding: EdgeInsets.only(right: index < homeViewModel.categoryCourses.length - 1 ? 20 : 0),
                      child: CourseCardWidget(
                        course: course,
                        onTap: () {
                          // Navigate to course detail
                          if (course.slugName != null && course.slugName!.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              AppConstants.routeCourseDetail,
                              arguments: course.slugName,
                            );
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTopMentorSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giảng viên hàng đầu',
                style: AppTextStyles.h3.copyWith(
                  color: const Color(0xFF202244),
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle see all mentors
                },
                child: Text(
                  'Xem tất cả',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Mentor cards placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Mentor cards sẽ được implement sau',
                style: TextStyle(color: Colors.grey[600]!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
