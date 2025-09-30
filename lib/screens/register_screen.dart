import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
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
          padding: const EdgeInsets.all(AppConstants.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo section
              Center(
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
                      'EDUPRO',
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
              ),
              const SizedBox(height: 60),
              // Title
              Text(
                'Bắt đầu!',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Tạo tài khoản để tiếp tục tất cả khóa học',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
              // Username input field
              _InputField(
                controller: _usernameController,
                hintText: 'Tên người dùng',
                icon: Icons.person_outline,
                keyboardType: TextInputType.text,
                isPassword: false,
                isPasswordVisible: false,
              ),
              const SizedBox(height: 20),
              // Email input field
              _InputField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                isPassword: false,
                isPasswordVisible: false,
              ),
              const SizedBox(height: 20),
              // Password input field
              _InputField(
                controller: _passwordController,
                hintText: 'Mật khẩu',
                icon: Icons.lock_outline,
                keyboardType: TextInputType.text,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onTogglePassword: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Terms and conditions checkbox
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreeToTerms = !_agreeToTerms;
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _agreeToTerms ? AppColors.primary : Colors.transparent,
                        border: Border.all(
                          color: _agreeToTerms ? AppColors.primary : AppColors.textSecondary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _agreeToTerms
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Đồng ý với Điều khoản & Điều kiện',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Sign Up button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _agreeToTerms ? _signUp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.textSecondary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng Ký',
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
              ),
              const SizedBox(height: 25),
              // Or Continue With text
              Center(
                child: Text(
                  'Hoặc tiếp tục với',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Social media buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                    icon: Icons.g_mobiledata,
                    onTap: () => _showComingSoon(context),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 40),
              // Already have account text
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đã có tài khoản? ',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, AppConstants.routeSignIn);
                      },
                      child: Text(
                        'ĐĂNG NHẬP',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() {
    if (_usernameController.text.isNotEmpty && 
        _emailController.text.isNotEmpty && 
        _passwordController.text.isNotEmpty) {
      // Navigate directly to create PIN screen
      Navigator.pushReplacementNamed(context, AppConstants.routeCreatePin);
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng này sẽ sớm ra mắt!')),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body1.copyWith(
            color: const Color(0xFF505050),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF505050),
            size: 20,
          ),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: onTogglePassword,
                  child: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF505050),
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: const Color(0xFF545454),
          size: 24,
        ),
      ),
    );
  }
}
