import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/core/utils/colors.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/constants/app_constants.dart';
import '../viewmodels/register_viewmodel.dart';
import '../widgets/input_field_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.8),
            radius: 1.25,
            colors: [Colors.white, Color(0xFF6366F1)],
            stops: [0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingL,
                    vertical: AppConstants.spacingXL,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 12),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildInputCard(
                                child: InputFieldWidget(
                                  controller: _usernameController,
                                  hintText: 'Tên đăng nhập',
                                  icon: Icons.person_outline,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _buildInputCard(
                                child: InputFieldWidget(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _buildInputCard(
                                child: InputFieldWidget(
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
                              ),
                              const SizedBox(height: 14),
                              _buildInputCard(
                                child: InputFieldWidget(
                                  controller: _confirmPasswordController,
                                  hintText: 'Xác nhận mật khẩu',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  isPasswordVisible: _isConfirmPasswordVisible,
                                  onTogglePassword: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 18),
                              _buildTermsAndConditions(),
                              const SizedBox(height: 22),
                              _buildSignUpButton(),
                              const SizedBox(height: 18),
                              _buildDivider(),
                              const SizedBox(height: 14),
                              _buildGoogleButton(),
                              const SizedBox(height: 24),
                              _buildSignInLink(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: AppConstants.spacingL,
                left: AppConstants.spacingL,
                child: _buildBackButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Image.asset(
        'assets/app_icon.png',
        width: 180,
        height: 180,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildInputCard({required Widget child}) {
    return Material(
      color: Colors.white,
      elevation: 1.5,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: child,
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _agreeToTerms = !_agreeToTerms;
            });
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _agreeToTerms ? AppColors.primary : AppColors.textWhite,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _agreeToTerms ? AppColors.primary : Colors.white,
                width: 1,
              ),
            ),
            child: _agreeToTerms
                ? const Icon(Icons.check, color: AppColors.textWhite, size: 14)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              children: [
                const TextSpan(text: 'Tôi đồng ý với '),
                TextSpan(
                  text: 'Điều khoản sử dụng',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' và '),
                TextSpan(
                  text: 'Chính sách bảo mật',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Consumer<RegisterViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: _agreeToTerms && !viewModel.isLoading
                ? () => _handleSignUp(viewModel)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _agreeToTerms
                  ? AppColors.primary
                  : Colors.white30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
              foregroundColor: Colors.white,
            ),
            child: viewModel.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.textWhite,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng Ký',
                        style: AppTextStyles.button.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
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

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.white24)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingS),
          child: Text(
            'Hoặc',
            style: AppTextStyles.body1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: Colors.white24)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          // TODO: Handle Google sign up
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: Colors.white54),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/google-icon.png', width: 22, height: 22),
            const SizedBox(width: 10),
            Text(
              'Đăng ký bằng Google',
              style: AppTextStyles.button.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản? ',
          style: AppTextStyles.body1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Đăng nhập',
            style: AppTextStyles.body1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSignUp(RegisterViewModel viewModel) async {
    if (_usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không khớp'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await viewModel.register(
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushNamed(
        context,
        AppConstants.routeVerifyEmail,
        arguments: _emailController.text.trim(),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Đăng ký thất bại'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
