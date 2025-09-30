import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';
import 'package:ftes/models/mentor_item.dart';

class TopMentorsScreen extends StatefulWidget {
  const TopMentorsScreen({super.key});

  @override
  State<TopMentorsScreen> createState() => _TopMentorsScreenState();
}

class _TopMentorsScreenState extends State<TopMentorsScreen> {
  final List<MentorItem> _mentors = [
    MentorItem.fromTopMentors(
      name: 'Jiya Shetty',
      specialty: 'Thiết kế 3D',
      imageUrl: 'https://via.placeholder.com/66x66/4A90E2/FFFFFF?text=JS',
    ),
    MentorItem.fromTopMentors(
      name: 'Donald S',
      specialty: 'Nghệ thuật & Nhân văn',
      imageUrl: 'https://via.placeholder.com/66x66/4A90E2/FFFFFF?text=DS',
    ),
    MentorItem.fromTopMentors(
      name: 'Aman',
      specialty: 'Phát triển cá nhân',
      imageUrl: 'https://via.placeholder.com/66x66/4A90E2/FFFFFF?text=AM',
    ),
    MentorItem.fromTopMentors(
      name: 'Vrushab. M',
      specialty: 'SEO & Marketing',
      imageUrl: 'https://via.placeholder.com/66x66/4A90E2/FFFFFF?text=VM',
    ),
    MentorItem.fromTopMentors(
      name: 'Robert William',
      specialty: 'Năng suất văn phòng',
      imageUrl: 'https://via.placeholder.com/66x66/4A90E2/FFFFFF?text=RW',
    ),
    MentorItem.fromTopMentors(
      name: 'Soman',
      specialty: 'Phát triển Web',
      imageUrl: 'https://via.placeholder.com/66x66/4A90E2/FFFFFF?text=SM',
    ),
    MentorItem.fromTopMentors(
      name: 'Rahul kamal',
      specialty: 'Thiết kế 3D',
      imageUrl: 'https://via.placeholder.com/66x66/4A90E2/FFFFFF?text=RK',
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
            'Giảng viên hàng đầu',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
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
        ],
      ),
    );
  }

  Widget _buildMentorsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: ListView.builder(
        itemCount: _mentors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildMentorCard(_mentors[index], index == _mentors.length - 1),
          );
        },
      ),
    );
  }

  Widget _buildMentorCard(MentorItem mentor, bool isLast) {
    return Column(
      children: [
        Container(
          height: 93,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              // Mentor Avatar
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    mentor.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF4A90E2),
                        child: Center(
                          child: Text(
                            mentor.name.split(' ').map((e) => e[0]).join(''),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Mentor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mentor Name
                    Text(
                      mentor.name,
                      style: AppTextStyles.heading1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Mentor Specialty
                    Text(
                      mentor.specialization,
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF545454),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Divider Line (except for last item)
        if (!isLast)
          Container(
            height: 1,
            color: const Color(0xFFE5E5E5),
            margin: const EdgeInsets.only(left: 86), // Align with text content
          ),
      ],
    );
  }

}

