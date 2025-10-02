import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          child: Form(
            key: _formKey,
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
                _buildTextField(
                  controller: _usernameController,
                  label: 'Tên người dùng',
                  hint: 'Nhập tên người dùng',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên người dùng';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Email input field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Nhập địa chỉ email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Password input field
                _buildTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  hint: 'Nhập mật khẩu',
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Confirm password input field
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Xác nhận mật khẩu',
                  hint: 'Nhập lại mật khẩu',
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    }
                    if (value != _passwordController.text) {
                      return 'Mật khẩu không khớp';
                    }
                    return null;
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
                      onTap: () => _signUpWithGoogle(context),
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
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
        try {
          // Use real email and username from form
          final realEmail = _emailController.text;
          final realUsername = _usernameController.text;
          
          final success = await authProvider.register(
            email: realEmail,
            password: _passwordController.text,
            username: realUsername,
          );
        
        if (success && mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to create PIN screen after successful registration
          Navigator.pushReplacementNamed(
            context, 
            AppConstants.routeCreatePin,
            arguments: {
              'contactInfo': realEmail,
              'method': 'email',
            },
          );
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký thất bại. Vui lòng thử lại.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Đăng ký thất bại. Vui lòng thử lại.';
          
          // Provide more specific error messages based on the error
          if (e.toString().contains('M004_DUPLICATE')) {
            if (e.toString().contains('email')) {
              errorMessage = 'Email này đã được sử dụng. Vui lòng sử dụng email khác.';
            } else if (e.toString().contains('username')) {
              errorMessage = 'Tên người dùng này đã được sử dụng. Vui lòng chọn tên khác.';
            }
          } else if (e.toString().contains('BACKEND_CONSTRAINT_VIOLATION')) {
            // This is the known backend bug - show special message and suggest retry
            _showConstraintViolationDialog();
            return;
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng đồng ý với điều khoản sử dụng')),
        );
      }
    }
  }

  Future<void> _signUpWithGoogle(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      final success = await authProvider.loginWithGoogle();
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppConstants.routeHome);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký Google thất bại: $e')),
        );
      }
    }
  }

  void _showConstraintViolationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi Hệ Thống'),
          content: const Text(
            'Hiện tại hệ thống đang gặp sự cố kỹ thuật. Vui lòng thử lại sau vài phút hoặc liên hệ hỗ trợ nếu vấn đề vẫn tiếp diễn.\n\n'
            'Chúng tôi xin lỗi vì sự bất tiện này.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Clear form and let user try again
                _usernameController.clear();
                _emailController.clear();
                _passwordController.clear();
                _confirmPasswordController.clear();
                _agreeToTerms = false;
                setState(() {});
              },
              child: const Text('Thử Lại'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.body1.copyWith(
                color: const Color(0xFF505050),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: const Color(0xFF505050),
                size: 20,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
          ),
        ),
      ],
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
