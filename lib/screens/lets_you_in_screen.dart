import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import 'package:ftes/core/di/injection_container.dart' as di;
import 'package:ftes/features/auth/presentation/pages/login_page.dart';
import 'package:ftes/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class LetsYouInScreen extends StatelessWidget {
  const LetsYouInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar area
            const SizedBox(height: 20),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      "Chào mừng bạn",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF202244),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 65),
                    
                    // Social Media Login Options
                    _buildSocialLoginOption(
                      icon: Icons.g_mobiledata,
                      text: "Tiếp tục với Google",
                      onTap: () => _signInWithGoogle(context),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    
                    const SizedBox(height: 49),
                    
                    // Or divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFFE2E6EA),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "( Hoặc )",
                            style: AppTextStyles.body1.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF545454),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFFE2E6EA),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 49),
                    
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to sign in screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đăng nhập với tài khoản của bạn',
                              style: AppTextStyles.button.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Sign Up Link
                    GestureDetector(
                      onTap: () {
                        // Navigate to sign up screen
                        Navigator.pushNamed(context, AppConstants.routeSignUp);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.body1.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF545454),
                          ),
                          children: const [
                            TextSpan(text: "Chưa có tài khoản? "),
                            TextSpan(
                              text: "ĐĂNG KÝ",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Home indicator
            SizedBox(
              height: 34,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLoginOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFFE2E6EA),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F9FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF545454),
                  size: 24,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF545454),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final vm = di.sl<AuthViewModel>();
    try {
      final success = await vm.loginWithGoogle();
      if (success && context.mounted) {
        Navigator.pushReplacementNamed(context, AppConstants.routeHome);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập Google thất bại: $e')),
        );
      }
    }
  }
}
