import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/models/course_response.dart';
import 'package:ftes/providers/course_provider.dart';
import 'package:ftes/providers/cart_provider.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';
import 'package:ftes/routes/app_routes.dart';

class PopularCoursesScreen extends StatefulWidget {
  const PopularCoursesScreen({super.key});

  @override
  State<PopularCoursesScreen> createState() => _PopularCoursesScreenState();
}

class _PopularCoursesScreenState extends State<PopularCoursesScreen> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _categories = [
    'Tất cả',
    'Thiết kế đồ họa',
    'Thiết kế 3D',
    'Nghệ thuật & Nhân văn',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Fetch courses when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      courseProvider.fetchFeaturedCourses();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      if (courseProvider.hasMore && !courseProvider.isLoadingCourses) {
        courseProvider.loadMoreCourses();
      }
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    
    if (index == 0) {
      // "Tất cả" - fetch featured courses
      courseProvider.fetchFeaturedCourses();
    } else {
      // Filter by category
      final category = _categories[index];
      courseProvider.searchCourses(category: category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar Space
            const SizedBox(height: 20),
            
            // Navigation Bar
            _buildNavigationBar(),
            
            const SizedBox(height: 20),
            
            // Search Bar
            _buildSearchBar(),
            
            const SizedBox(height: 20),
            
            // Category Filters
            _buildCategoryFilters(),
            
            const SizedBox(height: 25),
            
            // Courses List
            Expanded(
              child: _buildCoursesList(),
            ),
            
            // Bottom Navigation Bar
            AppBottomNavigationBar(selectedIndex: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF202244),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Khóa học phổ biến',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _navigateToSearch,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search,
                color: Color(0xFF202244),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.asMap().entries.map((entry) {
            int index = entry.key;
            String category = entry.value;
            bool isSelected = index == _selectedCategoryIndex;
            
            return Padding(
              padding: EdgeInsets.only(right: index < _categories.length - 1 ? 12 : 0),
              child: GestureDetector(
                onTap: () => _onCategorySelected(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF167F71) : const Color(0xFFE8F1FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    category,
                    style: AppTextStyles.body1.copyWith(
                      color: isSelected ? Colors.white : const Color(0xFF202244),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCoursesList() {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        // Loading state - first time
        if (courseProvider.isLoadingCourses && courseProvider.courses.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0961F5),
            ),
          );
        }

        // Error state
        if (courseProvider.errorMessage != null && courseProvider.courses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Color(0xFFFF6B00),
                ),
                const SizedBox(height: 16),
                Text(
                  'Không thể tải khóa học',
                  style: AppTextStyles.heading1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  courseProvider.errorMessage ?? 'Vui lòng thử lại',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFB4BDC4),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    courseProvider.fetchFeaturedCourses();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0961F5),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        final courses = courseProvider.courses;

        // Empty state
        if (courses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 80,
                  color: Color(0xFFB4BDC4),
                ),
                const SizedBox(height: 16),
                Text(
                  'Chưa có khóa học nào',
                  style: AppTextStyles.heading1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng thử lại sau',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFB4BDC4),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        // Courses list
        return RefreshIndicator(
          onRefresh: () async {
            await courseProvider.fetchFeaturedCourses();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: courses.length + (courseProvider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Loading indicator at the end
                if (index == courses.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0961F5),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildCourseCardFromResponse(courses[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourseCardFromResponse(CourseResponse course) {
    return GestureDetector(
      onTap: () {
        if (course.slugName != null) {
          // Navigate to course detail
          Navigator.pushNamed(
            context,
            '/course-detail',
            arguments: course.slugName,
          );
        }
      },
      child: Stack(
        children: [
          Container(
            height: 130,
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
            child: Row(
              children: [
                // Course Image
                Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Image.network(
                      course.image ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.black,
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Course Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        Text(
                          course.categoryName ?? 'Uncategorized',
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFFFF6B00),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        
                        const SizedBox(height: 5),
                        
                        // Title
                        Text(
                          course.title ?? 'Untitled Course',
                          style: AppTextStyles.heading1.copyWith(
                            color: const Color(0xFF202244),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const Spacer(),
                        
                        // Price and Rating
                        Row(
                          children: [
                            // Price
                            Text(
                              course.price != null && course.price! > 0
                                  ? '\$${course.price!.toStringAsFixed(0)}'
                                  : 'Miễn phí',
                              style: AppTextStyles.body1.copyWith(
                                color: const Color(0xFF0961F5),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Rating and Students
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFD700),
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  course.rating?.toStringAsFixed(1) ?? '0.0',
                                  style: AppTextStyles.body1.copyWith(
                                    color: const Color(0xFF202244),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
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
                                Text(
                                  '${course.totalStudents ?? 0} HV',
                                  style: AppTextStyles.body1.copyWith(
                                    color: const Color(0xFF202244),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Add to Cart Button
          Positioned(
            top: 8,
            right: 8,
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final isInCart = cartProvider.isCourseInCart(course.id ?? '');
                final isAdding = cartProvider.isAddingToCart;
                
                return GestureDetector(
                  onTap: isAdding ? null : () => _toggleCartForCourse(course),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isInCart
                          ? const Color(0xFF4CAF50) // Green when in cart
                          : const Color(0xFF0961F5), // Blue when not in cart
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isAdding
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            isInCart
                                ? Icons.check // Check mark when in cart
                                : Icons.add_shopping_cart, // Cart icon when not in cart
                            color: Colors.white,
                            size: 16,
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCartForCourse(CourseResponse course) async {
    try {
      final courseId = course.id ?? '';
      if (courseId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể thêm khóa học này vào giỏ hàng'),
            backgroundColor: Color(0xFFF44336),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final isInCart = cartProvider.isCourseInCart(courseId);
      
      if (isInCart) {
        // Find cart item by courseId and remove it
        final cartItem = cartProvider.cartItems.firstWhere(
          (item) => item.courseId == courseId,
          orElse: () => throw Exception('Cart item not found'),
        );
        
        if (cartItem.id != null) {
          final success = await cartProvider.removeFromCart(cartItem.id!);
          
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã xóa "${course.title}" khỏi giỏ hàng'),
                backgroundColor: const Color(0xFFF44336),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        }
      } else {
        // Add to cart
        final success = await cartProvider.addToCart(courseId);
        
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã thêm "${course.title}" vào giỏ hàng'),
              backgroundColor: const Color(0xFF4CAF50),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        } else if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(cartProvider.errorMessage ?? 'Không thể thêm vào giỏ hàng'),
              backgroundColor: const Color(0xFFF44336),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: ${e.toString()}'),
            backgroundColor: const Color(0xFFF44336),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
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
            const SizedBox(width: 20),
            const Icon(
              Icons.search,
              color: Color(0xFFB4BDC4),
              size: 20,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm khóa học...',
                  hintStyle: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFB4BDC4),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _navigateToSearchWithQuery(value.trim());
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_searchController.text.trim().isNotEmpty) {
                  _navigateToSearchWithQuery(_searchController.text.trim());
                }
              },
              child: Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.only(right: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFF0961F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSearch() {
    AppRoutes.navigateToCoursesList(context);
  }

  void _navigateToSearchWithQuery(String query) {
    AppRoutes.navigateToCoursesList(context, searchQuery: query);
  }

}
