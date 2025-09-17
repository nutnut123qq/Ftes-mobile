import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/models/course_item.dart';
import 'package:ftes/screens/course_detail_screen.dart';
import 'package:ftes/widgets/remove_bookmark_dialog.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class MyBookmarkScreen extends StatefulWidget {
  const MyBookmarkScreen({super.key});

  @override
  State<MyBookmarkScreen> createState() => _MyBookmarkScreenState();
}

class _MyBookmarkScreenState extends State<MyBookmarkScreen> {
  int _selectedCategoryIndex = 1; // Graphic Design selected by default
  final List<String> _categories = [
    'All',
    'Graphic Design',
    '3D Design',
    'Arts & Humanities',
  ];

  final List<CourseItem> _bookmarkedCourses = [
    CourseItem(
      category: 'Graphic Design',
      title: 'Graphic Design Advanced',
      price: '799/-',
      rating: '4.2',
      students: '7830 Std',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+1',
    ),
    CourseItem(
      category: 'Graphic Design',
      title: 'Advertisement Design',
      price: '499/-',
      rating: '3.9',
      students: '12680 Std',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+2',
    ),
    CourseItem(
      category: 'Programming',
      title: 'Graphic Design Advanced',
      price: '199/-',
      rating: '4.2',
      students: '990 Std',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+3',
    ),
    CourseItem(
      category: 'Web Development',
      title: 'Web Developer conce..',
      price: '899/-',
      rating: '4.9',
      students: '14580 Std',
      imageUrl: 'https://via.placeholder.com/230x130/000000/FFFFFF?text=Course+4',
    ),
    CourseItem(
      category: 'SEO & Marketing',
      title: 'Digital Marketing Caree..',
      price: '299/-',
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
            
            // Category Filters
            _buildCategoryFilters(),
            
            const SizedBox(height: 25),
            
            // Courses List
            Expanded(
              child: _buildCoursesList(),
            ),
            
            // Bottom Navigation Bar
            AppBottomNavigationBar(selectedIndex: 1),
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
            'My Bookmark',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 21,
              fontWeight: FontWeight.w600,
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
        itemCount: _bookmarkedCourses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCourseCard(_bookmarkedCourses[index]),
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
            builder: (context) => CourseDetailScreen(course: course),
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
                        
                        const Spacer(),
                        
                        // Rating and Students
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFD700),
                                size: 8,
                              ),
                              const SizedBox(width: 1),
                              Flexible(
                                child: Text(
                                  course.rating,
                                  style: AppTextStyles.body1.copyWith(
                                    color: const Color(0xFF202244),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '|',
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  course.students,
                                  style: AppTextStyles.body1.copyWith(
                                    color: const Color(0xFF202244),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Bookmark Icon
            GestureDetector(
              onTap: () {
                RemoveBookmarkDialog.show(
                  context,
                  course: course,
                  onRemove: () {
                    // Remove from bookmark list
                    setState(() {
                      _bookmarkedCourses.remove(course);
                    });
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0961F5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
