import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import 'package:ftes/routes/app_routes.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String _selectedFilter = 'Excellent';

  // Sample reviews data
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Heather S. McMullen',
      'rating': 4.2,
      'comment': 'The Course is Very Good dolor sit amet, con sect tur adipiscing elit. Naturales divitias dixit parab les esse..',
      'date': '2 Weeks Ago',
      'likes': 760,
      'avatar': 'https://via.placeholder.com/50x50/000000/FFFFFF?text=HS',
    },
    {
      'name': 'Natasha B. Lambert',
      'rating': 4.8,
      'comment': 'The Course is Very Good dolor veterm, quo etiam utuntur hi capiamus..',
      'date': '2 Weeks Ago',
      'likes': 918,
      'avatar': 'https://via.placeholder.com/50x50/000000/FFFFFF?text=NL',
    },
    {
      'name': 'Marshall A. Lester',
      'rating': 4.6,
      'comment': 'The Course is Very Good dolor sit amet, con sect tur adipiscing elit. Naturales divitias dixit parab les esse..',
      'date': '2 Weeks Ago',
      'likes': 914,
      'avatar': 'https://via.placeholder.com/50x50/000000/FFFFFF?text=ML',
    },
    {
      'name': 'Frances D. Stanford',
      'rating': 4.8,
      'comment': 'The Course is Very Good dolor veterm, Vestri hac verecundius constatius..',
      'date': '2 Weeks Ago',
      'likes': 967,
      'avatar': 'https://via.placeholder.com/50x50/000000/FFFFFF?text=FS',
    },
  ];

  final List<String> _filters = [
    'Excellent',
    'Good',
    'Average',
    'Below Average',
    'Poor',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildRatingOverview(),
              _buildFilterChips(),
              _buildReviewsList(),
              _buildWriteReviewButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 25, 35, 20),
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 26,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF202244),
                  size: 16,
                ),
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Title
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0961F5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Reviews',
                    style: AppTextStyles.heading1.copyWith(
                      color: const Color(0xFF202244),
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Column(
        children: [
          // Overall Rating
          Text(
            '4.8',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 38,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  index < 4 ? Icons.star : Icons.star_half,
                  color: const Color(0xFFFFD700),
                  size: 16,
                ),
              );
            }),
          ),
          
          const SizedBox(height: 8),
          
          // Review Count
          Text(
            'Based on 448 Reviews',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF545454),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFF167F71) 
                      : const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  filter,
                  style: AppTextStyles.body1.copyWith(
                    color: isSelected 
                        ? Colors.white 
                        : const Color(0xFF202244),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(34, 20, 34, 0),
      child: Column(
        children: _reviews.map((review) => _buildReviewCard(review)).toList(),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar, name, and rating
          Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.network(
                  review['avatar'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      color: Color(0xFF0961F5),
                      size: 25,
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Name and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Star Rating
                        ...List.generate(5, (index) {
                          if (index < review['rating'].floor()) {
                            return const Icon(
                              Icons.star,
                              color: Color(0xFFFFD700),
                              size: 16,
                            );
                          } else if (index < review['rating']) {
                            return const Icon(
                              Icons.star_half,
                              color: Color(0xFFFFD700),
                              size: 16,
                            );
                          } else {
                            return const Icon(
                              Icons.star_border,
                              color: Color(0xFFFFD700),
                              size: 16,
                            );
                          }
                        }),
                        const SizedBox(width: 8),
                        Text(
                          review['rating'].toString(),
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF202244),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Comment
          Text(
            review['comment'],
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF545454),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Footer with likes and date
          Row(
            children: [
              // Like button
              GestureDetector(
                onTap: () {
                  // Handle like action
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.thumb_up_outlined,
                      color: Color(0xFF0961F5),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review['likes'].toString(),
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Date
              Text(
                review['date'],
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWriteReviewButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(39, 20, 39, 0),
      height: 60,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppRoutes.navigateToWriteReview(context);
          },
          borderRadius: BorderRadius.circular(30),
          child: Row(
            children: [
              const SizedBox(width: 20),
              
              // Play Icon
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Color(0xFF0961F5),
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Button Text
              Expanded(
                child: Text(
                  'Write a Review',
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
