import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToHome();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationSlow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppConstants.routeLaunching);
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Animation
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.textWhite,
                          borderRadius: BorderRadius.circular(AppConstants.radiusXXL),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowMedium,
                              blurRadius: AppConstants.shadowBlurRadius,
                              offset: const Offset(0, AppConstants.shadowOffsetY),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school,
                          size: AppConstants.iconXXL,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppConstants.spacingXL),
              
              // App Name
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingM),
              
              // App Description
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'Trải nghiệm học tập Flutter',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingXXL),
              
              // Loading Indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: const SizedBox(
                  width: AppConstants.progressIndicatorSize,
                  height: AppConstants.progressIndicatorSize,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
