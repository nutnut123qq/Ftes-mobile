import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/utils/colors.dart';
import 'package:ftes/core/widgets/bottom_navigation_bar.dart';
import 'package:ftes/core/widgets/3D/button_3d.dart';
import 'package:ftes/core/di/injection_container.dart' as di;
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/routes/app_routes.dart';
import 'package:ftes/features/profile/domain/usecases/profile_usecases.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/constants/home_constants.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/course_card_widget.dart';
import '../widgets/banner_widget.dart';
import '../widgets/mentor_carousel.dart';
import '../../../my_courses/presentation/viewmodels/my_courses_viewmodel.dart';
import '../../../../core/utils/image_cache_helper.dart';

class HomePage extends StatefulWidget {
  final bool hideBottomNav;

  const HomePage({super.key, this.hideBottomNav = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = HomeConstants.defaultUserName;
  String? _userId;

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
    });
  }

  Future<void> _loadUserInfoAsync() async {
    try {
      final prefs = di.sl<SharedPreferences>();
      final userId = prefs.getString(AppConstants.keyUserId);
      if (userId == null || userId.isEmpty) return;

      if (mounted) {
        setState(() {
          _userId = userId;
        });
      }

      final cachedUserData = prefs.getString(AppConstants.keyUserData);
      if (cachedUserData != null && cachedUserData.isNotEmpty) {
        _updateUserNameFromCache(cachedUserData);
      }

      final getProfileByIdUseCase = di.sl<GetProfileByIdUseCase>();
      final result = await getProfileByIdUseCase(userId);
      result.fold(
        (failure) =>
            debugPrint('❌ Failed to load user profile: ${failure.message}'),
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
              if (_userId != null && _userId!.isNotEmpty) ...[
                _buildMyEnrolledSection(_userId!),
                const SizedBox(height: 24),
              ],
              _buildCategorySection(
                titleParts: const ['DEV', ' căn bản, không lo ', 'PHÍ'],
                titleFirstGradient: true,
                categoryId: HomeConstants.categoryDevFree,
              ),
              const SizedBox(height: 24),
              _buildCategorySection(
                titleParts: const ['Từ ', 'Zero', ' đến ', 'Pro-Dev'],
                titleFirstGradient: false,
                categoryId: HomeConstants.categoryZeroToPro,
              ),
              const SizedBox(height: 24),
              _buildCategorySection(
                titleParts: const [' Tư duy ', 'toán học', ' cho dân ', 'Dev'],
                titleFirstGradient: true,
                categoryId: HomeConstants.categoryMathForDev,
              ),
              const SizedBox(height: 24),
              _buildCategorySection(
                titleParts: const ['Dân ', 'Dev', ' chinh phục ', 'Ngoại ngữ'],
                titleFirstGradient: true,
                categoryId: HomeConstants.categoryLanguageForDev,
              ),
              const SizedBox(height: 40),
              const MentorCarousel(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.hideBottomNav
          ? null
          : const AppBottomNavigationBar(selectedIndex: 0),
    );
  }

  Widget _buildCategorySection({
    required List<String> titleParts,
    required bool titleFirstGradient,
    required String categoryId,
  }) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        // Filter from latest courses to avoid extra requests
        final courses = vm.latestCourses
            .where((c) => c.categoryId == categoryId)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildGradientTitle(titleParts, titleFirstGradient),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: courses.isEmpty
                  ? Center(
                      child: Text(
                        HomeConstants.noCoursesAvailable,
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.grey[600]!,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      // +1 để có thêm item "Xem tất cả" ở cuối
                      itemCount: courses.length + 1,
                      itemBuilder: (context, index) {
                        // Item cuối: nút "Xem tất cả"
                        if (index == courses.length) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: _SeeAllCard(
                              onTap: () {
                                AppRoutes.navigateToCoursesList(
                                  context,
                                  categoryId: categoryId,
                                );
                              },
                            ),
                          );
                        }

                        final course = courses[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < courses.length - 1 ? 10 : 0,
                          ),
                          child: CourseCardWidget(
                            course: course,
                            onTap: () {
                              if (course.slugName != null &&
                                  course.slugName!.isNotEmpty) {
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

  // Card "Xem tất cả" nằm trong ListView ngang
  Widget _SeeAllCard({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Text(
            'Xem tất cả',
            textAlign: TextAlign.center,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientTitle(List<String> parts, bool firstGradient) {
    TextStyle base = AppTextStyles.h3.copyWith(
      color: const Color(0xFF202244),
      fontWeight: FontWeight.bold,
      fontSize: 20, // giảm size tiêu đề cho gọn hơn
    );
    Widget gradientText(String text) {
      return ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Text(text, style: base.copyWith(color: Colors.white)),
      );
    }

    final children = <Widget>[];
    for (int i = 0; i < parts.length; i++) {
      final isGradient =
          (firstGradient && (i == 0 || i == 2)) ||
          (!firstGradient && (i == 1 || i == 3));
      children.add(
        isGradient ? gradientText(parts[i]) : Text(parts[i], style: base),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }

  Widget _buildNavigationBar() {
    final greetingCards = <Widget>[
      Padding(
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
              onTap: () => Navigator.pushNamed(context, AppConstants.routeCart),
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
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return CarouselSlider(
      items: greetingCards,
      options: CarouselOptions(
        height: 72,
        viewportFraction: 1,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
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
          onTap: () =>
              Navigator.pushNamed(context, AppConstants.routeCourseSearch),
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

  Widget _buildMyEnrolledSection(String userId) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = di.sl<MyCoursesViewModel>();
        vm.fetchUserCourses(userId);
        return vm;
      },
      child: Consumer<MyCoursesViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.myCourses.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Khoá học của bạn',
                      style: AppTextStyles.h3.copyWith(
                        color: const Color(0xFF202244),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.routeMyCourses,
                        );
                      },
                      child: const Text('Xem tất cả'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.98),
                  itemCount: vm.myCourses.length,
                  itemBuilder: (context, index) {
                    final c = vm.myCourses[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _EnrolledWideCard(
                        title: c.title ?? '',
                        imageUrl: c.imageHeader,
                        onContinue: () {
                          if (c.slugName != null && c.slugName!.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              AppConstants.routeCourseDetail,
                              arguments: c.slugName,
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
      ),
    );
  }

  // Wide full-width enrolled card (7:3 content:image)
  Widget _EnrolledWideCard({
    required String title,
    required String? imageUrl,
    required VoidCallback onContinue,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            // Image (flex 3)
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    ImageCacheHelper.cached(
                      imageUrl,
                      fit: BoxFit.cover,
                      memCacheWidth: 800,
                      memCacheHeight: 480,
                      maxWidthDiskCache: 1600,
                      maxHeightDiskCache: 960,
                      placeholder: Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      error: Container(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.school,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                    )
                  else
                    Container(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.school,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  Container(color: Colors.black.withValues(alpha: 0.08)),
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content (flex 7)
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: const Color(0xFF202244),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: OutlineButton3D(
                        text: 'Tiếp tục học',
                        onPressed: onContinue,
                        variant: Button3DVariant.solid,
                        backgroundColor: AppColors.primary,
                        borderColor: AppColors.primary,
                        borderWidth: 0,
                        borderRadius: 8,
                        shadowOffset: 3,
                        height: 34,
                        autoSize: true,
                        fontSize: 12,
                        iconOnRight: true,
                        iconSize: 18,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
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

  Widget _buildOfferBanner() {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        if (homeViewModel.isLoadingBanners) {
          final screenWidth = MediaQuery.of(context).size.width;
          final slideWidth = screenWidth * 0.9;
          final bannerHeight = (slideWidth * 9 / 16).clamp(
            180.0,
            double.infinity,
          );

          return SizedBox(
            height: bannerHeight,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          );
        }

        if (homeViewModel.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final slideWidth = screenWidth * 0.9;
        final bannerHeight = (slideWidth * 9 / 16).clamp(180.0, 260.0);

        return CarouselSlider.builder(
          itemCount: homeViewModel.banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = homeViewModel.banners[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SizedBox(
                width: slideWidth,
                child: BannerWidget(
                  banner: banner,
                  onTap: () => debugPrint('Banner tapped: ${banner.title}'),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: bannerHeight,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            enlargeFactor: 0.18,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.easeInOut,
          ),
        );
      },
    );
  }
}
