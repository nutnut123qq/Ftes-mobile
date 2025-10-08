import 'package:flutter/material.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';

class CongratulationsScreen extends StatefulWidget {
  const CongratulationsScreen({super.key});

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    _animationController.forward();

    // Auto navigate to home after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppConstants.routeHome);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202244).withOpacity(0.8),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 360,
                    height: 460,
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
                        _buildMainContent(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeElements() {
    return Stack(
      children: [
        // Star 1
        Positioned(
          top: 37,
          right: 66,
          child: _buildStar(),
        ),
        // Star 2
        Positioned(
          bottom: 140,
          left: 78,
          child: _buildStar(),
        ),
        // Triangle 1
        Positioned(
          top: 108,
          right: 136,
          child: _buildTriangle(),
        ),
        // Triangle 2
        Positioned(
          bottom: 100,
          left: 110,
          child: _buildTriangle(),
        ),
        // Oval 1
        Positioned(
          top: 88,
          right: 180,
          child: _buildOval(12),
        ),
        // Oval 2
        Positioned(
          bottom: 120,
          left: 111,
          child: _buildOval(8),
        ),
        // Oval 3
        Positioned(
          top: 78,
          left: 92,
          child: _buildOval(12),
        ),
        // Check mark lines
        Positioned(
          top: 43,
          left: 115,
          child: _buildCheckLine(),
        ),
        Positioned(
          top: 52,
          left: 140,
          child: _buildCheckLine(),
        ),
        // Success icon
        Positioned(
          bottom: 49,
          left: 160,
          child: _buildSuccessIcon(),
        ),
      ],
    );
  }

  Widget _buildStar() {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: Color(0xFFFFD700),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.star,
        color: Colors.white,
        size: 12,
      ),
    );
  }

  Widget _buildTriangle() {
    return Container(
      width: 14,
      height: 14,
      decoration: const BoxDecoration(
        color: Color(0xFF4CAF50),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 8,
      ),
    );
  }

  Widget _buildOval(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCheckLine() {
    return Container(
      width: 25,
      height: 3,
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFF4CAF50),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          // Title
          Text(
            'Chúc mừng',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Description
          Text(
            'Tài khoản của bạn đã sẵn sàng sử dụng. Bạn sẽ được chuyển hướng đến trang chủ trong vài giây.',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF545454),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}