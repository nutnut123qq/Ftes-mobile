import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/models/course_item.dart';
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
  final List<String> _categories = [
    'All',
    'Graphic Design',
    '3D Design',
    'Arts & Humanities',
  ];

  final List<CourseItem> _courses = [
    CourseItem(
      category: 'Graphic Design',
      title: 'Graphic Design Advanced',
      price: '7058/-',
      rating: '4.2',
      students: '7830 Std',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+1',
    ),
    CourseItem(
      category: 'Graphic Design',
      title: 'Advertisement Design',
      price: '800/-',
      rating: '3.9',
      students: '12680 Std',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+2',
    ),
    CourseItem(
      category: 'Programming',
      title: 'Graphic Design Advanced',
      price: '599/-',
      rating: '4.2',
      students: '990 Std',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+3',
    ),
    CourseItem(
      category: 'Web Development',
      title: 'Web Developer conce..',
      price: '499/-',
      rating: '4.9',
      students: '14580 Std',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+4',
    ),
    CourseItem(
      category: 'SEO & Marketing',
      title: 'Digital Marketing Caree..',
      price: '\$67',
      originalPrice: '\$84',
      rating: '4.2',
      students: '10252 Std',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+5',
    ),
  ];

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
            'Popular Courses',
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
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCourseCard(_courses[index]),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(CourseItem course) {
    return Container(
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

