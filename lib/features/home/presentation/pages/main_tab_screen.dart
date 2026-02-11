import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/bottom_navigation_bar.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../pages/home_page.dart';
import '../viewmodels/home_viewmodel.dart';
import '../../../my_courses/presentation/pages/my_courses_page.dart';
import '../../../my_courses/presentation/viewmodels/my_courses_viewmodel.dart';
import '../../../roadmap/presentation/pages/roadmap_page.dart';
import '../../../roadmap/presentation/viewmodels/roadmap_viewmodel.dart';
import '../../../blog/presentation/pages/blog_list_page.dart';
import '../../../blog/presentation/viewmodels/blog_viewmodel.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../cart/presentation/viewmodels/cart_viewmodel.dart';

/// Main tab screen that holds all tabs in memory with smooth fade animations
class MainTabScreen extends StatefulWidget {
  final int initialIndex;

  const MainTabScreen({super.key, this.initialIndex = 0});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  late int _currentIndex;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // Initialize all tabs once and keep them in memory
    // All pages have hideBottomNav=true to prevent duplicate bottom nav bars
    _tabs = [
      // Tab 0: Home
      ChangeNotifierProvider(
        create: (context) => di.sl<HomeViewModel>(),
        child: const HomePage(hideBottomNav: true),
      ),
      // Tab 1: My Courses
      ChangeNotifierProvider(
        create: (context) => di.sl<MyCoursesViewModel>(),
        child: const MyCoursesPage(hideBottomNav: true),
      ),
      // Tab 2: Roadmap
      ChangeNotifierProvider(
        create: (_) => di.sl<RoadmapViewModel>(),
        child: const RoadmapPage(hideBottomNav: true),
      ),
      // Tab 3: Blog
      ChangeNotifierProvider(
        create: (context) => di.sl<BlogViewModel>()..initialize(),
        child: const BlogListPage(hideBottomNav: true),
      ),
      // Tab 4: Cart
      ChangeNotifierProvider(
        create: (context) => di.sl<CartViewModel>(),
        child: const CartPage(hideBottomNav: true),
      ),
    ];
  }

  void _onTabChanged(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        top: true,
        bottom: false, // Bottom SafeArea handled by AppBottomNavigationBar
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: IndexedStack(
            key: ValueKey<int>(_currentIndex),
            index: _currentIndex,
            children: _tabs,
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
