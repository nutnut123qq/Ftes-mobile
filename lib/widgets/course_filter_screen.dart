import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';

class CourseFilterScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterApplied;
  final Map<String, dynamic> currentFilters;

  const CourseFilterScreen({
    super.key,
    required this.onFilterApplied,
    required this.currentFilters,
  });

  @override
  State<CourseFilterScreen> createState() => _CourseFilterScreenState();
}

class _CourseFilterScreenState extends State<CourseFilterScreen> {
  late Map<String, dynamic> _filters;
  
  // Filter options based on Figma design
  final List<String> _subCategories = [
    '3D Design',
    'Web Development',
    '3D Animation',
    'Graphic Design',
    'SEO & Marketing',
    'Arts & Humanities',
  ];
  
  final List<String> _levels = [
    'All Levels',
    'Beginners',
    'Intermediate',
    'Expert',
  ];
  
  final List<String> _prices = [
    'Paid',
    'Free',
  ];
  
  final List<String> _features = [
    'All Caption',
    'Quizzes',
    'Coding Exercise',
    'Practice Tests',
  ];
  
  final List<String> _ratings = [
    '4.5 & Up Above',
    '4.0 & Up Above',
    '3.5 & Up Above',
    '3.0 & Up Above',
  ];
  
  final List<String> _videoDurations = [
    '0-2 Hours',
    '3-6 Hours',
    '7-16 Hours',
    '17+ Hours',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
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
            
            // Header
            _buildHeader(),
            
            const SizedBox(height: 20),
            
            // Filter Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SubCategories
                    _buildFilterSection(
                      'SubCategories:',
                      _subCategories,
                      'subCategories',
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Levels
                    _buildFilterSection(
                      'Levels:',
                      _levels,
                      'levels',
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Price
                    _buildFilterSection(
                      'Price:',
                      _prices,
                      'price',
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Features
                    _buildFilterSection(
                      'Features:',
                      _features,
                      'features',
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Rating
                    _buildFilterSection(
                      'Rating:',
                      _ratings,
                      'rating',
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Video Durations
                    _buildFilterSection(
                      'Video Durations:',
                      _videoDurations,
                      'videoDurations',
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Apply Button
            _buildApplyButton(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF202244),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Filter',
            style: AppTextStyles.h3.copyWith(
              color: const Color(0xFF202244),
              fontWeight: FontWeight.w600,
              fontSize: 21,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _resetFilters,
            child: Text(
              'Clear',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF545454),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, String filterKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h5.copyWith(
            color: const Color(0xFF202244),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Column(
          children: options.map((option) {
            bool isSelected = _filters[filterKey]?.contains(option) ?? false;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_filters[filterKey] == null) {
                      _filters[filterKey] = <String>[];
                    }
                    List<String> selectedItems = List<String>.from(_filters[filterKey]);
                    if (isSelected) {
                      selectedItems.remove(option);
                    } else {
                      selectedItems.add(option);
                    }
                    _filters[filterKey] = selectedItems;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF167F71) : const Color(0xFFE8F1FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF167F71) : const Color(0xFFB4BDC4),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(0xFF202244).withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 39),
      child: GestureDetector(
        onTap: _applyFilters,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0961F5),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Apply',
                style: AppTextStyles.buttonLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF0961F5),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'subCategories': <String>[],
        'levels': <String>[],
        'price': <String>[],
        'features': <String>[],
        'rating': <String>[],
        'videoDurations': <String>[],
      };
    });
  }

  void _applyFilters() {
    widget.onFilterApplied(_filters);
    Navigator.pop(context);
  }
}
