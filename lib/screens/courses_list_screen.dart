import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/widgets/course_filter_screen.dart';
import 'package:ftes/screens/mentors_list_screen.dart';
import 'package:ftes/features/course/presentation/pages/course_detail_page.dart';
import 'package:ftes/models/course_item.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class CoursesListScreen extends StatefulWidget {
  final String? initialSearchQuery;
  
  const CoursesListScreen({super.key, this.initialSearchQuery});

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Khóa học', 'Giảng viên'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Filter state
  Map<String, dynamic> _filters = {
    'subCategories': <String>[],
    'levels': <String>[],
    'price': <String>[],
    'features': <String>[],
    'rating': <String>[],
    'videoDurations': <String>[],
  };
  
  List<CourseItem>? _filteredCourses;

  final List<CourseItem> _courses = [
    CourseItem(
      id: 'list_course_1',
      category: 'Thiết kế đồ họa',
      title: 'Thiết kế đồ họa nâng cao',
      price: '89/-',
      originalPrice: '499',
      rating: '4.2',
      students: '7830 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+1',
    ),
    CourseItem(
      id: 'list_course_2',
      category: 'Phát triển Web',
      title: 'Phát triển Web...',
      price: '800/-',
      rating: '4.0',
      students: '12680 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+2',
    ),
    CourseItem(
      id: 'list_course_3',
      category: 'Hoạt hình 3D',
      title: 'Lớp học Hoạt hình 3D',
      price: '799/-',
      rating: '4.2',
      students: '990 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+3',
    ),
    CourseItem(
      id: 'list_course_4',
      category: 'Phát triển Web',
      title: 'Hướng dẫn React.js',
      price: '999/-',
      rating: '4.9',
      students: '14580 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+4',
    ),
    CourseItem(
      id: 'list_course_5',
      category: 'Thiết kế 3D',
      title: 'Cơ bản về Thiết kế 3D',
      price: '1200/-',
      rating: '4.8',
      students: '8500 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+5',
    ),
    CourseItem(
      id: 'list_course_6',
      category: 'SEO & Marketing',
      title: 'Khóa học Marketing số',
      price: '1500/-',
      rating: '4.6',
      students: '12000 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+6',
    ),
    CourseItem(
      id: 'list_course_7',
      category: 'Thiết kế đồ họa',
      title: 'Lớp học Figma',
      price: '600/-',
      rating: '4.7',
      students: '6500 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+7',
    ),
    CourseItem(
      id: 'list_course_8',
      category: 'SEO & Marketing',
      title: 'Marketing mạng xã hội',
      price: '400/-',
      rating: '4.3',
      students: '9200 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+8',
    ),
    CourseItem(
      id: 'list_course_9',
      category: 'Nghệ thuật & Nhân văn',
      title: 'Khóa học Viết sáng tạo',
      price: '800/-',
      rating: '4.5',
      students: '4800 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+9',
    ),
    CourseItem(
      id: 'list_course_10',
      category: 'Phát triển Web',
      title: 'Hướng dẫn Vue.js',
      price: '1100/-',
      rating: '4.9',
      students: '15000 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+10',
    ),
    CourseItem(
      id: 'list_course_11',
      category: 'Thiết kế đồ họa',
      title: 'Cơ bản Photoshop miễn phí',
      price: '0/-',
      rating: '4.1',
      students: '25000 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Free+Course+1',
    ),
    CourseItem(
      id: 'list_course_12',
      category: 'Phát triển Web',
      title: 'Khóa học HTML & CSS miễn phí',
      price: '0/-',
      rating: '4.3',
      students: '35000 HV',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Free+Course+2',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Set initial search query if provided
    if (widget.initialSearchQuery != null) {
      _searchController.text = widget.initialSearchQuery!;
      _searchQuery = widget.initialSearchQuery!;
    }
    _filteredCourses = List.from(_courses);
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
            
            // Tab Bar
            _buildTabBar(),
            
            const SizedBox(height: 20),
            
            // Results Header
            _buildResultsHeader(),
            
            // Filter Indicator
            if (_hasActiveFilters()) _buildFilterIndicator(),
            
            const SizedBox(height: 20),
            
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
          Expanded(
            child: Text(
              'Khóa học trực tuyến',
              style: AppTextStyles.heading1.copyWith(
                color: const Color(0xFF202244),
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
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
                  hintText: 'Thiết kế đồ họa',
                  hintStyle: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFB4BDC4),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filteredCourses = null;
                  });
                },
              ),
            ),
            GestureDetector(
              onTap: _showFilterBottomSheet,
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          int index = entry.key;
          String tab = entry.value;
          bool isSelected = index == _selectedTabIndex;
          
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index < _tabs.length - 1 ? 12 : 0),
              child: GestureDetector(
                onTap: () {
                  if (index == 1) {
                    // Navigate to Mentors screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MentorsListScreen(),
                      ),
                    );
                  } else {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  }
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF167F71) : const Color(0xFFE8F1FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      tab,
                      style: AppTextStyles.body1.copyWith(
                        color: isSelected ? Colors.white : const Color(0xFF202244),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Result for "',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: _searchQuery.isEmpty ? 'Graphic Design' : _searchQuery,
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF0961F5),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '"',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_getFilteredCourses().length} Found',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF0961F5),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF0961F5),
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
    final courses = _getFilteredCourses();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCourseCard(courses[index]),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(CourseItem course) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: course),
          ),
        );
      },
      child: Container(
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
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
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
                course.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.black,
                    child: const Icon(
                      Icons.image,
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
                    course.category,
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFFFF6B00),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  const SizedBox(height: 5),
                  
                  // Title
                  Text(
                    course.title,
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
                        course.price,
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFF0961F5),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      
                      // Original Price (if exists)
                      if (course.originalPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          course.originalPrice!,
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFFB4BDC4),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      
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
                            course.rating,
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
                            course.students,
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
    );
  }


  void _showFilterBottomSheet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseFilterScreen(
          onFilterApplied: _applyFilters,
          currentFilters: _filters,
        ),
      ),
    );
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filters = filters;
      _filteredCourses = null;
    });
  }

  List<CourseItem> _getFilteredCourses() {
    if (_filteredCourses == null || _filteredCourses!.isEmpty) {
      _filteredCourses = _filterCourses();
    }
    return _filteredCourses!;
  }

  List<CourseItem> _filterCourses() {
    List<CourseItem> filtered = List.from(_courses);

    // Filter by subcategories
    List<String> subCategories = _filters['subCategories'] ?? <String>[];
    if (subCategories.isNotEmpty) {
      filtered = filtered.where((course) => 
        subCategories.contains(course.category)).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((course) => 
        course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        course.category.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Filter by rating
    List<String> ratings = _filters['rating'] ?? <String>[];
    if (ratings.isNotEmpty) {
      filtered = filtered.where((course) {
        double courseRating = double.parse(course.rating);
        return ratings.any((rating) {
          if (rating.contains('4.5')) return courseRating >= 4.5;
          if (rating.contains('4.0')) return courseRating >= 4.0;
          if (rating.contains('3.5')) return courseRating >= 3.5;
          if (rating.contains('3.0')) return courseRating >= 3.0;
          return false;
        });
      }).toList();
    }

    // Filter by price
    List<String> prices = _filters['price'] ?? <String>[];
    if (prices.isNotEmpty) {
      filtered = filtered.where((course) {
        String price = course.price.replaceAll(RegExp(r'[^\d]'), '');
        int coursePrice = int.tryParse(price) ?? 0;
        
        return prices.any((priceFilter) {
          if (priceFilter == 'Free') return coursePrice == 0;
          if (priceFilter == 'Paid') return coursePrice > 0;
          return false;
        });
      }).toList();
    }

    return filtered;
  }

  bool _hasActiveFilters() {
    return _filters.values.any((value) => 
      value is List && value.isNotEmpty);
  }

  Widget _buildFilterIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0961F5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.filter_list,
            color: Color(0xFF0961F5),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Filters Applied',
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(0xFF0961F5),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _clearAllFilters,
            child: const Icon(
              Icons.close,
              color: Color(0xFF0961F5),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'subCategories': <String>[],
        'levels': <String>[],
        'price': <String>[],
        'features': <String>[],
        'rating': <String>[],
        'videoDurations': <String>[],
      };
      _filteredCourses = null;
    });
  }
}

