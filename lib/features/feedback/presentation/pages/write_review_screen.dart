import 'package:flutter/material.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/features/feedback/domain/constants/feedback_constants.dart';
import 'package:ftes/features/feedback/presentation/viewmodels/feedback_viewmodel.dart';
import 'package:provider/provider.dart';

class WriteReviewScreen extends StatefulWidget {
  final String courseId;
  final String userId;
  final String? courseName;

  const WriteReviewScreen({
    super.key,
    required this.courseId,
    required this.userId,
    this.courseName,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final int _maxCharacters = 250;
  int _rating = 5; // Default 5 stars

  @override
  void initState() {
    super.initState();
    _reviewController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildCourseInfo(),
              _buildReviewSection(),
              _buildSubmitButton(),
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
            color: Colors.black.withValues(alpha: 0.08),
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
                    'Viết đánh giá',
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

  Widget _buildCourseInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(34, 20, 34, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: Color(0xFF0961F5),
              size: 40,
            ),
          ),

          const SizedBox(width: 16),

          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  'Thiết kế đồ họa',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFFFF6B00),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                // Title
                Text(
                  'Thiết lập Thiết kế đồ họa...',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Section
          Text(
            'Đánh giá của bạn',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 15),

          // Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFFD700),
                    size: 40,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 10),

          // Rating Text
          Center(
            child: Text(
              _getRatingText(_rating),
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF202244),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            'Viết đánh giá của bạn',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // Review Text Area
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder text
                  Text(
                    'Bạn có muốn viết gì về khóa học này không?',
                    style: AppTextStyles.body1.copyWith(
                      color: const Color(0xFFB4BDC4),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Text Field
                  Expanded(
                    child: TextField(
                      controller: _reviewController,
                      maxLength: _maxCharacters,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                        counterText: '',
                      ),
                    ),
                  ),

                  // Character counter
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '*${_maxCharacters - _reviewController.text.length} Ký tự còn lại',
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFFB4BDC4),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 5:
        return 'Xuất sắc';
      case 4:
        return 'Tốt';
      case 3:
        return 'Trung bình';
      case 2:
        return 'Dưới trung bình';
      case 1:
        return 'Kém';
      default:
        return '';
    }
  }

  Widget _buildSubmitButton() {
    final isEnabled = _reviewController.text.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(39, 30, 39, 0),
      height: 60,
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFF0961F5) : const Color(0xFFB4BDC4),
        borderRadius: BorderRadius.circular(30),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(1, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _submitReview : null,
          borderRadius: BorderRadius.circular(30),
          child: Row(
            children: [
              const SizedBox(width: 20),

              // Play Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send,
                  color: isEnabled
                      ? const Color(0xFF0961F5)
                      : const Color(0xFFB4BDC4),
                  size: 20,
                ),
              ),

              const SizedBox(width: 16),

              // Button Text
              Expanded(
                child: Text(
                  'Gửi đánh giá',
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

  void _submitReview() async {
    if (_reviewController.text.trim().isEmpty) return;

    final viewModel = context.read<FeedbackViewModel>();

    final userIdInt = int.tryParse(widget.userId) ?? 0;
    final courseIdInt = int.tryParse(widget.courseId) ?? 0;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final success = await viewModel.createFeedback(
      userId: userIdInt,
      courseId: courseIdInt,
      rating: _rating,
      comment: _reviewController.text.trim(),
    );

    // Hide loading indicator
    if (mounted) {
      Navigator.pop(context);

      if (success) {
        await viewModel.loadAverageRating(courseIdInt);
        if (!mounted) return;
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(FeedbackConstants.successSubmitMessage),
            backgroundColor: Color(0xFF0961F5),
          ),
        );

        // Navigate back
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.errorMessage ?? FeedbackConstants.errorSubmitMessage,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
