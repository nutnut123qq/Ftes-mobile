import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/features/cart/presentation/pages/new_cart_screen.dart';
import 'package:ftes/features/blog/presentation/pages/blog_list_page.dart';

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
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(
              context,
              Icons.home,
              'Trang chủ',
              selectedIndex == 0,
              onTap: () => _handleTap(context, 0),
            ),
            _buildBottomNavItem(
              context,
              Icons.book,
              'Khóa học',
              selectedIndex == 1,
              onTap: () => _handleTap(context, 1),
            ),
            _buildBottomNavItem(
              context,
              Icons.shopping_cart,
              'Giỏ hàng',
              selectedIndex == 2,
              onTap: () => _handleTap(context, 2),
            ),
            _buildBottomNavItem(
              context,
              Icons.article,
              'Blog',
              selectedIndex == 3,
              onTap: () => _handleTap(context, 3),
            ),
            _buildBottomNavItem(
              context,
              Icons.person,
              'Hồ sơ',
              selectedIndex == 4,
              onTap: () => _handleTap(context, 4),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Default navigation logic
    switch (index) {
      case 0: // Home
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
        break;
      case 1: // My Courses
        Navigator.pushNamed(context, AppConstants.routeMyCourses);
        break;
      case 2: // Cart
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewCartScreen(),
          ),
        );
        break;
      case 3: // Blog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BlogListPage(),
          ),
        );
        break;
      case 4: // Profile
        Navigator.pushNamed(context, '/profile');
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
