import 'package:flutter/material.dart';
import '../utils/text_styles.dart';
import '../constants/app_constants.dart' as core_constants;
import '../../features/blog/presentation/pages/blog_list_page.dart';
import '../../features/roadmap/presentation/pages/roadmap_page.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onTap;

  const AppBottomNavigationBar({
    super.key,
    this.selectedIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F9FF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBottomNavItem(
                        context,
                        Icons.home,
                        'Trang chủ',
                        selectedIndex == 0,
                        onTap: () => _handleTap(context, 0),
                      ),
                    ),
                    Expanded(
                      child: _buildBottomNavItem(
                        context,
                        Icons.book,
                        'Khóa học',
                        selectedIndex == 1,
                        onTap: () => _handleTap(context, 1),
                      ),
                    ),
                    const SizedBox(width: 52),
                    Expanded(
                      child: _buildBottomNavItem(
                        context,
                        Icons.article,
                        'Blog',
                        selectedIndex == 3,
                        onTap: () => _handleTap(context, 3),
                      ),
                    ),
                    Expanded(
                      child: _buildBottomNavItem(
                        context,
                        Icons.shopping_cart,
                        'Giỏ hàng',
                        selectedIndex == 4,
                        onTap: () => _handleTap(context, 4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Action Button có hiệu ứng chọn
          Positioned(
            top: -16,
            child: GestureDetector(
              onTap: () => _handleTap(context, 2),
              child: AnimatedScale(
                scale: selectedIndex == 2 ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: selectedIndex == 2
                        ? const Color(0xFF0741C8)
                        : const Color(0xFF0961F5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: selectedIndex == 2
                            ? Colors.blue.withAlpha(128)
                            : Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.route,
                    color: selectedIndex == 2
                        ? Colors.white
                        : const Color(0xFFE0E0E0),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }

    switch (index) {
      case 0: // Home
        Navigator.pushNamedAndRemoveUntil(context, core_constants.AppConstants.routeHome, (route) => false);
        break;
      case 1: // My Courses
        Navigator.pushNamed(context, core_constants.AppConstants.routeMyCourses);
        break;
      case 2: // AI Roadmap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RoadmapPage()),
        );
        // Navigator.pushNamed(context, AppConstants.routeRoadmap);
        break;
      case 3: // Blog
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BlogListPage()),
        );
        break;
      case 4: // Cart
        Navigator.pushNamed(context, core_constants.AppConstants.routeCart);
        break;
    }
  }

  Widget _buildBottomNavItem(
      BuildContext context,
      IconData icon,
      String label,
      bool isSelected, {
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF0961F5) : const Color(0xFFA0A4AB),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body1.copyWith(
              color: isSelected ? const Color(0xFF0961F5) : const Color(0xFFA0A4AB),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

