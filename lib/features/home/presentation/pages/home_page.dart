import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/utils/colors.dart';
import 'package:ftes/core/widgets/bottom_navigation_bar.dart';
import 'package:ftes/core/di/injection_container.dart' as di;
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/features/profile/domain/usecases/profile_usecases.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/constants/home_constants.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/course_card_widget.dart';
import '../widgets/banner_widget.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/mentor_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = HomeConstants.defaultUserName;
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      Future.wait([
        homeViewModel.initialize(),
        homeViewModel.fetchCategories(),
        _loadUserInfoAsync(),
      ]);

      _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted) return;
        final banners = homeViewModel.banners;
        if (banners.isEmpty) return;

        setState(() {
          _currentBannerIndex =
              (_currentBannerIndex + 1) % banners.length;
        });

        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  Future<void> _loadUserInfoAsync() async {
    try {
      final prefs = di.sl<SharedPreferences>();
      final userId = prefs.getString(AppConstants.keyUserId);
      if (userId == null || userId.isEmpty) return;

      final cachedUserData = prefs.getString(AppConstants.keyUserData);
      if (cachedUserData != null && cachedUserData.isNotEmpty) {
        _updateUserNameFromCache(cachedUserData);
      }

      final getProfileByIdUseCase = di.sl<GetProfileByIdUseCase>();
      final result = await getProfileByIdUseCase(userId);
      result.fold(
            (failure) => debugPrint('❌ Failed to load user profile: ${failure.message}'),
            (profile) {
          final displayName = _getDisplayName(profile.name, profile.username);
          if (mounted) setState(() => _userName = displayName);
        },
      );
    } catch (e) {
      debugPrint('❌ Error loading user info: $e');
    }
  }

  void _updateUserNameFromCache(String cachedData) {
    try {
      final userMap = jsonDecode(cachedData) as Map<String, dynamic>;
      final username = userMap['username'] as String?;
      final fullName = userMap['fullName'] as String?;
      final displayName = _getDisplayName(fullName, username);
      if (mounted) setState(() => _userName = displayName);
    } catch (e) {
      debugPrint('❌ Error parsing cached user data: $e');
    }
  }

  String _getDisplayName(String? fullName, String? username) {
    if (fullName != null && fullName.isNotEmpty) return fullName;
    if (username != null && username.isNotEmpty) return username;
    return HomeConstants.defaultUserName;
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
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
              const SizedBox(height: 20),
              _buildNavigationBar(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 30),
              _buildOfferBanner(),
              const SizedBox(height: 30),
              _buildPopularCoursesSection(),
              const SizedBox(height: 40),
              const MentorCarousel(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 0),
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
                HomeConstants.greetingText,
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
            onTap: () => Navigator.pushNamed(context, AppConstants.routeProfile),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: AppColors.primary, size: 24),
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
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, AppConstants.routeCourseSearch),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600]!, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  HomeConstants.searchPlaceholder,
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.grey[600]!,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(Icons.filter_list, color: Colors.grey[600]!, size: 20),
            ],
          ),
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

        return SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) => setState(() => _currentBannerIndex = index),
            itemCount: homeViewModel.banners.length,
            itemBuilder: (context, index) {
              final banner = homeViewModel.banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BannerWidget(
                  banner: banner,
                  onTap: () => debugPrint('Banner tapped: ${banner.title}'),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPopularCoursesSection() {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                HomeConstants.popularCoursesTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(
                  color: const Color(0xFF202244),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                        onTap: () => homeViewModel.fetchCoursesByCategory(category.id ?? 'all'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (homeViewModel.isLoadingLatestCourses || homeViewModel.isLoadingCategoryCourses)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (homeViewModel.categoryCourses.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(HomeConstants.noCoursesAvailable),
                ),
              )
            else
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: homeViewModel.categoryCourses.length,
                  cacheExtent: 1000,
                  itemBuilder: (context, index) {
                    final course = homeViewModel.categoryCourses[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < homeViewModel.categoryCourses.length - 1 ? 10 : 0,
                      ),
                      child: CourseCardWidget(
                        course: course,
                        onTap: () {
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
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
