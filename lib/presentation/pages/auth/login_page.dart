import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../routes/app_routes.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/auth/input_field_widget.dart';
import '../../widgets/auth/social_button_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(AppConstants.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo section
              _buildLogoSection(),
              const SizedBox(height: 60),
              // Title section
              _buildTitleSection(),
              const SizedBox(height: 40),
              // Email input field
              InputFieldWidget(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              // Password input field
              InputFieldWidget(
                controller: _passwordController,
                hintText: 'Mật khẩu',
                icon: Icons.lock_outline,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onTogglePassword: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Remember Me and Forgot Password row
              _buildRememberMeAndForgotPasswordRow(),
              const SizedBox(height: 30),
              // Sign In button
              _buildSignInButton(),
              const SizedBox(height: 25),
              // Or Continue With text
              _buildOrContinueWithText(),
              const SizedBox(height: 25),
              // Social media buttons
              _buildSocialButtons(),
              const SizedBox(height: 40),
              // Don't have account text
              _buildDontHaveAccountText(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Column(
        children: [
          // App icon placeholder
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.school,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          // App name
          Text(
            'FTES - AI Learning Platform',
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.primary,
              fontSize: 30,
              fontWeight: FontWeight.w400,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Học Tập Tại Nhà',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đăng Nhập!',
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Đăng nhập vào tài khoản để tiếp tục khóa học',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPasswordRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember Me checkbox
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberMe = !_rememberMe;
                });
              },
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: _rememberMe ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: _rememberMe ? AppColors.primary : AppColors.textSecondary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _rememberMe
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Ghi nhớ đăng nhập',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        // Forgot Password link
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppConstants.routeForgotPassword),
          child: Text(
            'Quên mật khẩu?',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: authViewModel.isLoading ? null : _signIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: authViewModel.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng Nhập',
                        style: AppTextStyles.button.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
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
        );
      },
    );
  }

  Widget _buildOrContinueWithText() {
    return Center(
      child: Text(
        'Hoặc tiếp tục với',
        style: AppTextStyles.body1.copyWith(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButtonWidget(
          icon: Icons.g_mobiledata,
          onTap: () => _signInWithGoogle(context),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildDontHaveAccountText() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Chưa có tài khoản? ',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, AppConstants.routeSignUp);
            },
            child: Text(
              'ĐĂNG KÝ',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signIn() async {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
      try {
        final success = await authViewModel.login(
          _emailController.text,
          _passwordController.text,
        );
        
        if (success && mounted) {
          Navigator.pushReplacementNamed(context, AppConstants.routeHome);
        } else if (mounted && authViewModel.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authViewModel.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đăng nhập thất bại: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    
    try {
      final success = await authViewModel.loginWithGoogle();
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppConstants.routeHome);
      } else if (mounted && authViewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập Google thất bại: $e')),
        );
      }
    }
  }
}
