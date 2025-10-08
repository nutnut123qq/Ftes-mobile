import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';
import 'package:ftes/screens/single_mentor_details_screen.dart';
import 'package:ftes/models/mentor_item.dart';

class MentorsListScreen extends StatefulWidget {
  const MentorsListScreen({super.key});

  @override
  State<MentorsListScreen> createState() => _MentorsListScreenState();
}

class _MentorsListScreenState extends State<MentorsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<MentorItem> _mentors = [
    MentorItem(
      name: 'Ramal',
      specialization: 'Thiết kế 3D',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=R',
    ),
    MentorItem(
      name: 'Aman MK',
      specialization: 'Thiết kế 3D',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=A',
    ),
    MentorItem(
      name: 'Manav M',
      specialization: 'Thiết kế 3D',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=M',
    ),
    MentorItem(
      name: 'Siya Dhawal',
      specialization: 'Thiết kế 3D',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=S',
    ),
    MentorItem(
      name: 'Robert jr',
      specialization: 'Thiết kế 3D',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=R',
    ),
    MentorItem(
      name: 'William K. Olivas',
      specialization: 'Thiết kế 3D',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=W',
    ),
    MentorItem(
      name: 'Sarah Johnson',
      specialization: 'Phát triển Web',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=S',
    ),
    MentorItem(
      name: 'Mike Chen',
      specialization: 'Thiết kế đồ họa',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=M',
    ),
    MentorItem(
      name: 'Emma Wilson',
      specialization: 'Thiết kế UI/UX',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=E',
    ),
    MentorItem(
      name: 'David Lee',
      specialization: 'Phát triển Mobile',
      avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=D',
    ),
  ];

  List<MentorItem> _filteredMentors = [];

  @override
  void initState() {
    super.initState();
    _filteredMentors = List.from(_mentors);
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
            
            const SizedBox(height: 20),
            
            // Mentors List
            Expanded(
              child: _buildMentorsList(),
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
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF202244),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Giảng viên',
              style: AppTextStyles.h3.copyWith(
                color: const Color(0xFF202244),
                fontWeight: FontWeight.w600,
                fontSize: 21,
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
                  hintText: 'Thiết kế 3D',
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
                    _filteredMentors = _filterMentors();
                  });
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
                Icons.tune,
                color: Colors.white,
                size: 20,
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
        children: [
          // Courses Tab
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'Khóa học',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Mentors Tab (Selected)
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF167F71),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'Giảng viên',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
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
                    text: _searchQuery.isEmpty ? '3D Design' : _searchQuery,
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
                  '${_filteredMentors.length} Tìm thấy',
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

  Widget _buildMentorsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: ListView.builder(
        itemCount: _filteredMentors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildMentorCard(_filteredMentors[index]),
          );
        },
      ),
    );
  }

  Widget _buildMentorCard(MentorItem mentor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleMentorDetailsScreen(mentor: mentor),
          ),
        );
      },
      child: Container(
        height: 87,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
        children: [
          // Avatar
          Container(
            width: 66,
            height: 66,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(33),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(33),
              child: Image.network(
                mentor.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFE8F1FF),
                    child: Center(
                      child: Text(
                        mentor.name.isNotEmpty ? mentor.name[0].toUpperCase() : 'M',
                        style: AppTextStyles.h4.copyWith(
                          color: const Color(0xFF0961F5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Mentor Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name
                  Text(
                    mentor.name,
                    style: AppTextStyles.h5.copyWith(
                      color: const Color(0xFF202244),
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Specialization
                  Text(
                    mentor.specialization,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF545454),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Arrow Icon
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFB4BDC4),
              size: 16,
            ),
          ),
        ],
      ),
    ),
    );
  }


  List<MentorItem> _filterMentors() {
    if (_searchQuery.isEmpty) {
      return List.from(_mentors);
    }
    
    return _mentors.where((mentor) => 
      mentor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      mentor.specialization.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }
}

