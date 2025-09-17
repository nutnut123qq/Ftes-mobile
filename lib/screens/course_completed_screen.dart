import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import '../routes/app_routes.dart';

class CourseCompletedScreen extends StatefulWidget {
  final String courseTitle;
  final String courseImage;

  const CourseCompletedScreen({
    Key? key,
    required this.courseTitle,
    required this.courseImage,
  }) : super(key: key);

  @override
  State<CourseCompletedScreen> createState() => _CourseCompletedScreenState();
}

class _CourseCompletedScreenState extends State<CourseCompletedScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _starsController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _starsAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Stars animation controller
    _starsController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale animation for the main content
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Fade animation for the content
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Stars animation
    _starsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _starsController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _starsController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Stack(
        children: [
          // Background with lessons screen
          _buildBackground(),
          
          // Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF202244).withOpacity(0.8),
          ),
          
          // Course completed card
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: _buildCourseCompletedCard(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF5F9FF),
            const Color(0xFFE8F1FF),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.school,
          size: 200,
          color: Color(0xFFE8F1FF),
        ),
      ),
    );
  }

  Widget _buildCourseCompletedCard() {
    return Container(
      width: 360,
      height: 500,
      margin: const EdgeInsets.symmetric(horizontal: 34),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          _buildDecorativeElements(),
          
          // Main content
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Celebration icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0961F5).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.celebration,
                    size: 60,
                    color: Color(0xFF0961F5),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Title
                Text(
                  'Course Completed',
                  style: AppTextStyles.heading1.copyWith(
                    color: const Color(0xFF202244),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 15),
                
                // Description
                Text(
                  'Complete your Course. Please Write a Review',
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 30),
                
                // Star rating
                _buildStarRating(),
                
                const SizedBox(height: 30),
                
                // Write a Review button
                _buildWriteReviewButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeElements() {
    return AnimatedBuilder(
      animation: _starsAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Stars and decorative elements
            Positioned(
              top: 40,
              right: 60,
              child: Transform.rotate(
                angle: _starsAnimation.value * 0.1,
                child: Icon(
                  Icons.star,
                  color: const Color(0xFFFFD700).withOpacity(0.6),
                  size: 18,
                ),
              ),
            ),
            Positioned(
              top: 80,
              right: 30,
              child: Transform.rotate(
                angle: -_starsAnimation.value * 0.1,
                child: Icon(
                  Icons.star,
                  color: const Color(0xFFFFD700).withOpacity(0.4),
                  size: 16,
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: 40,
              child: Transform.rotate(
                angle: _starsAnimation.value * 0.15,
                child: Icon(
                  Icons.star,
                  color: const Color(0xFFFFD700).withOpacity(0.5),
                  size: 20,
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 80,
              child: Transform.rotate(
                angle: -_starsAnimation.value * 0.08,
                child: Icon(
                  Icons.star,
                  color: const Color(0xFFFFD700).withOpacity(0.3),
                  size: 14,
                ),
              ),
            ),
            // Triangles
            Positioned(
              top: 100,
              right: 40,
              child: Transform.rotate(
                angle: _starsAnimation.value * 0.2,
                child: Icon(
                  Icons.play_arrow,
                  color: const Color(0xFF0961F5).withOpacity(0.3),
                  size: 14,
                ),
              ),
            ),
            Positioned(
              bottom: 140,
              left: 60,
              child: Transform.rotate(
                angle: -_starsAnimation.value * 0.12,
                child: Icon(
                  Icons.play_arrow,
                  color: const Color(0xFF0961F5).withOpacity(0.4),
                  size: 16,
                ),
              ),
            ),
            // Circles
            Positioned(
              top: 60,
              right: 100,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF0961F5).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 100,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF0961F5).withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 120,
              right: 20,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF0961F5).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _starsAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: index < 4 ? 1.0 : 0.8 + (_starsAnimation.value * 0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  index < 4 ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD700),
                  size: 20,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildWriteReviewButton() {
    return GestureDetector(
      onTap: () {
        AppRoutes.navigateToWriteReview(context);
      },
      child: Container(
        width: 226,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0961F5),
              Color(0xFF4A90E2),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0961F5).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Write a Review',
            style: AppTextStyles.body1.copyWith(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
