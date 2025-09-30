import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePasswords);
    _confirmPasswordController.addListener(_validatePasswords);
    // Initial validation
    _validatePasswords();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    final isPasswordValid = password.length >= 6;
    final isConfirmPasswordValid = confirmPassword.length >= 6 && 
        password.length >= 6 &&
        password == confirmPassword;
    
    // Debug print
    print('Password: $password (${password.length} chars), Confirm: $confirmPassword (${confirmPassword.length} chars)');
    print('Password valid: $isPasswordValid, Confirm valid: $isConfirmPasswordValid');
    print('Both valid: ${isPasswordValid && isConfirmPasswordValid}');
    
    if (_isPasswordValid != isPasswordValid || _isConfirmPasswordValid != isConfirmPasswordValid) {
      setState(() {
        _isPasswordValid = isPasswordValid;
        _isConfirmPasswordValid = isConfirmPasswordValid;
      });
    }
  }

  void _createNewPassword() {
    if (_isPasswordValid && _isConfirmPasswordValid) {
      // Create new password logic - placeholder for future implementation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu mới đã được tạo thành công!')),
      );
      // Navigate to congratulations screen
      Navigator.pushNamed(context, AppConstants.routeCongratulations);
    } else {
      String message = '';
      if (!_isPasswordValid) {
        message = 'Mật khẩu phải có ít nhất 6 ký tự!';
      } else if (!_isConfirmPasswordValid) {
        message = 'Mật khẩu xác nhận không khớp!';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
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
              const SizedBox(height: 25),
              // Navigation bar with back button and title
              Row(
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
                        color: AppColors.textPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Tạo mật khẩu mới',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 371),
              // Title
              Text(
                'Tạo mật khẩu mới của bạn',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              // Password input field
              _PasswordField(
                controller: _passwordController,
                hintText: 'Mật khẩu',
                isPasswordVisible: _isPasswordVisible,
                onTogglePassword: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                isValid: _isPasswordValid,
                onChanged: _validatePasswords,
              ),
              const SizedBox(height: 20),
              // Confirm Password input field
              _PasswordField(
                controller: _confirmPasswordController,
                hintText: 'Xác nhận mật khẩu',
                isPasswordVisible: _isConfirmPasswordVisible,
                onTogglePassword: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                isValid: _isConfirmPasswordValid,
                onChanged: _validatePasswords,
              ),
              const SizedBox(height: 50),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: (_isPasswordValid && _isConfirmPasswordValid) ? _createNewPassword : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_isPasswordValid && _isConfirmPasswordValid) 
                        ? AppColors.primary 
                        : const Color(0xFFB4BDC4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tiếp tục',
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPasswordVisible;
  final VoidCallback onTogglePassword;
  final bool isValid;
  final VoidCallback? onChanged;

  const _PasswordField({
    required this.controller,
    required this.hintText,
    required this.isPasswordVisible,
    required this.onTogglePassword,
    required this.isValid,
    this.onChanged,
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
        border: isValid 
            ? Border.all(color: AppColors.primary, width: 2)
            : Border.all(color: Colors.transparent, width: 2),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isPasswordVisible,
        onChanged: onChanged != null ? (value) => onChanged!() : null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body1.copyWith(
            color: const Color(0xFF505050),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF505050),
            size: 20,
          ),
          suffixIcon: GestureDetector(
            onTap: onTogglePassword,
            child: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF505050),
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }
}
