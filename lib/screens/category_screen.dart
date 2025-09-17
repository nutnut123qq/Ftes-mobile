import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _showSearchOverlay = false;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    '3D Design',
    'Graphic Design',
    'Programming',
    'SEO & Marketing',
    'Web Development',
    'Office Productivity',
    'Personal Development',
    'Finance & Accounting',
    'HR Management',
  ];

  final List<CategoryItem> _categories = [
    CategoryItem(
      name: '3D Design',
      icon: Icons.view_in_ar_outlined,
      color: const Color(0xFF4CAF50),
    ),
    CategoryItem(
      name: 'Graphic Design',
      icon: Icons.palette_outlined,
      color: const Color(0xFF2196F3),
    ),
    CategoryItem(
      name: 'Web Development',
      icon: Icons.web_outlined,
      color: const Color(0xFFFF9800),
    ),
    CategoryItem(
      name: 'SEO & Marketing',
      icon: Icons.trending_up_outlined,
      color: const Color(0xFF9C27B0),
    ),
    CategoryItem(
      name: 'Finance & Accounting',
      icon: Icons.account_balance_outlined,
      color: const Color(0xFFF44336),
    ),
    CategoryItem(
      name: 'Personal Development',
      icon: Icons.person_outline,
      color: const Color(0xFF00BCD4),
    ),
    CategoryItem(
      name: 'Office Productivity',
      icon: Icons.work_outline,
      color: const Color(0xFF795548),
    ),
    CategoryItem(
      name: 'HR Management',
      icon: Icons.groups_outlined,
      color: const Color(0xFF607D8B),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  
                  // Navigation Bar
                  _buildNavigationBar(),
                  
                  const SizedBox(height: 20),
                  
                  // Search Bar
                  _buildSearchBar(),
                  
                  const SizedBox(height: 30),
                  
                  // Categories Grid
                  _buildCategoriesGrid(),
                  
                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
            
            // Search Overlay
            if (_showSearchOverlay) _buildSearchOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(selectedIndex: 0),
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
            'All Category',
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showSearchOverlay = true;
            _searchController.text = 'Graphic Design';
          });
        },
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
                child: Text(
                  'Search for..',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFB4BDC4),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Container(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 30,
          childAspectRatio: 1.2,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(_categories[index]);
        },
      ),
    );
  }

  Widget _buildCategoryCard(CategoryItem category) {
    return GestureDetector(
      onTap: () {
        // Navigate to category details or courses - placeholder for future implementation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${category.name}')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                category.icon,
                color: category.color,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            // Category Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                category.name,
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244).withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSearchOverlay() {
    return Container(
      color: const Color(0xFFF5F9FF),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Navigation Bar
              _buildSearchNavigationBar(),
              
              const SizedBox(height: 20),
              
              // Search Bar
              _buildSearchInputBar(),
              
              const SizedBox(height: 30),
              
              // Recent Search Section
              _buildRecentSearchSection(),
              
              const SizedBox(height: 100), // Space for home indicator
              
              // Home Indicator
              _buildHomeIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showSearchOverlay = false;
              });
            },
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
            'Search',
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

  Widget _buildSearchInputBar() {
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
                  hintText: 'Search for..',
                  hintStyle: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFB4BDC4),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // Handle search input
                },
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recents Search',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle clear all recent searches
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF0961F5),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF0961F5),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Recent Search Items
          ..._recentSearches.map((search) => _buildRecentSearchItem(search)).toList(),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String searchText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Handle search item tap
                _searchController.text = searchText;
              },
              child: Text(
                searchText,
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFFA0A4AB),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle remove search item
              setState(() {
                _recentSearches.remove(searchText);
              });
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close,
                color: Color(0xFF472D2D),
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeIndicator() {
    return Container(
      height: 34,
      width: double.infinity,
      color: const Color(0xFFF5F9FF),
      child: Center(
        child: Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E6EA),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}
