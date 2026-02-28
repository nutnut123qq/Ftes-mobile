import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../viewmodels/my_courses_viewmodel.dart';
import '../widgets/my_course_card_widget.dart';
import '../../../../core/widgets/bottom_navigation_bar.dart';
import '../../domain/constants/my_courses_constants.dart';

/// My Courses page using Clean Architecture
class MyCoursesPage extends StatefulWidget {
  final bool hideBottomNav;

  const MyCoursesPage({super.key, this.hideBottomNav = false});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    // Optimize: Use PostFrameCallback to prevent blocking first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAsync();
    });
  }

  /// Optimized async initialization without blocking main thread
  Future<void> _initializeAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Try to get userId from SharedPreferences first
      final userId = prefs.getString(AppConstants.keyUserId);
      if (userId != null && userId.isNotEmpty) {
        if (!mounted) return;

        setState(() {
          _userId = userId;
        });

        // Fetch user courses
        final viewModel = Provider.of<MyCoursesViewModel>(
          context,
          listen: false,
        );
        await viewModel.fetchUserCourses(userId);
        return;
      }

      // If no userId, try to get from user_data
      final userDataString = prefs.getString(AppConstants.keyUserData);
      if (userDataString != null && userDataString.isNotEmpty) {
        // Using user_data fallback
      }
    } catch (e) {
      // Error loading userId
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            // Search bar
            _buildSearchBar(),
            // Courses list
            Expanded(child: _buildCoursesList()),
          ],
        ),
      ),
      bottomNavigationBar: widget.hideBottomNav
          ? null
          : const AppBottomNavigationBar(selectedIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Row(
        children: [
          Text(
            MyCoursesConstants.titleMyCoursesPage,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202244),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Consumer<MyCoursesViewModel>(
        builder: (context, viewModel, child) {
          return TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: MyCoursesConstants.searchHintText,
              prefixIcon: const Icon(Icons.search, color: Color(0xFF202244)),
              suffixIcon: viewModel.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF202244)),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: _onSearchChanged,
          );
        },
      ),
    );
  }

  /// Handle search with debounce to avoid excessive filtering
  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Create new timer for debounce
    _debounceTimer = Timer(
      const Duration(milliseconds: MyCoursesConstants.searchDebounceMs),
      () {
        // Perform search after debounce
        final viewModel = Provider.of<MyCoursesViewModel>(
          context,
          listen: false,
        );
        viewModel.searchCourses(query);
      },
    );
  }

  /// Refresh courses when pull-to-refresh
  Future<void> _refreshCourses() async {
    if (_userId.isNotEmpty) {
      final viewModel = Provider.of<MyCoursesViewModel>(
        context,
        listen: false,
      );
      await viewModel.fetchUserCourses(_userId);
    }
  }

  Widget _buildCoursesList() {
    return Consumer<MyCoursesViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.myCourses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null && viewModel.myCourses.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshCourses,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        viewModel.errorMessage!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_userId.isNotEmpty) {
                            viewModel.fetchUserCourses(_userId);
                          }
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (viewModel.myCourses.isEmpty) {
          // Check if it's an empty search result or no courses at all
          final isSearching = viewModel.searchQuery.isNotEmpty;

          return RefreshIndicator(
            onRefresh: _refreshCourses,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSearching ? Icons.search_off : Icons.school_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isSearching
                            ? MyCoursesConstants.emptySearchTitle
                            : MyCoursesConstants.emptyCoursesTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isSearching
                            ? MyCoursesConstants.emptySearchSubtitle
                            : MyCoursesConstants.emptyCoursesSubtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshCourses,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: viewModel.myCourses.length,
            itemBuilder: (context, index) {
              final course = viewModel.myCourses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MyCourseCardWidget(
                  course: course,
                  onTap: () {
                    // Navigate to course detail using slugName
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
        );
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
