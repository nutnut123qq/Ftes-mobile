import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../viewmodels/my_courses_viewmodel.dart';
import '../widgets/my_course_card_widget.dart';
import '../../../../widgets/bottom_navigation_bar.dart';

/// My Courses page using Clean Architecture
class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Try to get userId from SharedPreferences first
      final userId = prefs.getString(AppConstants.keyUserId);
      if (userId != null && userId.isNotEmpty) {
        setState(() {
          _userId = userId;
        });
        
        // Fetch user courses
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final viewModel = Provider.of<MyCoursesViewModel>(context, listen: false);
          viewModel.fetchUserCourses(userId);
        });
        return;
      }

      // If no userId, try to get from user_data
      final userDataString = prefs.getString(AppConstants.keyUserData);
      if (userDataString != null && userDataString.isNotEmpty) {
        // Parse user data to get userId
        // This is a fallback - ideally userId should be stored separately
        print('⚠️ No userId found, using user_data fallback');
      }
    } catch (e) {
      print('❌ Error loading userId: $e');
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
            Expanded(
              child: _buildCoursesList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Text(
            'Khóa học của tôi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202244),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Refresh courses
              if (_userId.isNotEmpty) {
                final viewModel = Provider.of<MyCoursesViewModel>(context, listen: false);
                viewModel.fetchUserCourses(_userId);
              }
            },
            icon: const Icon(Icons.refresh),
            color: const Color(0xFF202244),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Tìm kiếm khóa học...',
          prefixIcon: Icon(Icons.search, color: Color(0xFF202244)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          // TODO: Implement search functionality
        },
      ),
    );
  }

  Widget _buildCoursesList() {
    return Consumer<MyCoursesViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  viewModel.errorMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
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
          );
        }

        if (viewModel.myCourses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Bạn chưa có khóa học nào',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hãy tham gia các khóa học để bắt đầu học tập',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
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
                    print('Navigate to course: ${course.slugName}');
                    Navigator.pushNamed(
                      context,
                      AppConstants.routeCourseDetail,
                      arguments: course.slugName,
                    );
                  } else {
                    print('⚠️ Course slugName is null or empty: ${course.id}');
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
