import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../providers/feedback_provider.dart';
import 'package:ftes/core/di/injection_container.dart' as di;
import 'package:ftes/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../models/feedback_response.dart';

class ReviewsScreen extends StatefulWidget {
  final String courseId;
  final String? courseName;
  
  const ReviewsScreen({
    super.key,
    required this.courseId,
    this.courseName,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String _selectedFilter = 'Tất cả';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData() {
    final provider = context.read<FeedbackProvider>();
    final courseIdInt = int.tryParse(widget.courseId) ?? 0;
    provider.loadFeedbacks(courseIdInt, refresh: true);
    provider.loadAverageRating(courseIdInt);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<FeedbackProvider>();
      if (!provider.isLoadingMore && provider.hasMore) {
        final courseIdInt = int.tryParse(widget.courseId) ?? 0;
        provider.loadFeedbacks(courseIdInt);
      }
    }
  }

  final List<String> _filters = [
    'Tất cả',
    'Xuất sắc',
    'Tốt',
    'Trung bình',
    'Dưới trung bình',
    'Kém',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Consumer<FeedbackProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.feedbacks.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                final courseIdInt = int.tryParse(widget.courseId) ?? 0;
                await provider.loadFeedbacks(courseIdInt, refresh: true);
                await provider.loadAverageRating(courseIdInt);
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildRatingOverview(provider),
                    _buildFilterChips(),
                    _buildReviewsList(provider),
                    if (provider.isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    _buildWriteReviewButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
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
                    'Đánh giá',
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

  Widget _buildRatingOverview(FeedbackProvider provider) {
    final rating = provider.averageRating;
    final count = provider.totalElements;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Column(
        children: [
          // Overall Rating
          Text(
            rating.toStringAsFixed(1),
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
              if (index < rating.floor()) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.star,
                    color: Color(0xFFFFD700),
                    size: 16,
                  ),
                );
              } else if (index < rating) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.star_half,
                    color: Color(0xFFFFD700),
                    size: 16,
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.star_border,
                    color: Color(0xFFFFD700),
                    size: 16,
                  ),
                );
              }
            }),
          ),
          
          const SizedBox(height: 8),
          
          // Review Count
          Text(
            'Dựa trên $count đánh giá',
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

  Widget _buildReviewsList(FeedbackProvider provider) {
    if (provider.feedbacks.isEmpty && !provider.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.rate_review_outlined,
                size: 60,
                color: Color(0xFF9E9E9E),
              ),
              const SizedBox(height: 16),
              Text(
                'Chưa có đánh giá nào',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF545454),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Filter reviews based on selected filter
    List<FeedbackResponse> filteredReviews = provider.feedbacks;
    if (_selectedFilter != 'Tất cả') {
      filteredReviews = provider.feedbacks.where((review) {
        switch (_selectedFilter) {
          case 'Xuất sắc':
            return review.rating == 5;
          case 'Tốt':
            return review.rating == 4;
          case 'Trung bình':
            return review.rating == 3;
          case 'Dưới trung bình':
            return review.rating == 2;
          case 'Kém':
            return review.rating == 1;
          default:
            return true;
        }
      }).toList();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(34, 20, 34, 0),
      child: Column(
        children: filteredReviews.map((review) => _buildReviewCard(review)).toList(),
      ),
    );
  }

  Widget _buildReviewCard(FeedbackResponse review) {
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
                child: review.userAvatar != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          review.userAvatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Color(0xFF0961F5),
                              size: 25,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        color: Color(0xFF0961F5),
                        size: 25,
                      ),
              ),
              
              const SizedBox(width: 16),
              
              // Name and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Người dùng ẩn danh',
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
                          if (index < review.rating) {
                            return const Icon(
                              Icons.star,
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
                          review.rating.toString(),
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
            review.comment,
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF545454),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Footer with date
          Text(
            _formatDate(review.createdAt),
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} tuần trước';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else {
      return '${(difference.inDays / 365).floor()} năm trước';
    }
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
            final authVm = di.sl<AuthViewModel>();
            final userId = authVm.currentUser?.id ?? '';
            AppRoutes.navigateToWriteReview(
              context,
              courseId: widget.courseId,
              userId: userId,
              courseName: widget.courseName,
            );
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
                  'Viết đánh giá',
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
