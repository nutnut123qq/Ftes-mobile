import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/core/utils/colors.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/constants/app_constants.dart';
import '../viewmodels/forgot_password_viewmodel.dart';

class CreateNewPasswordPage extends StatefulWidget {
  final String email;

  const CreateNewPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {}); // Update UI when text changes
    });
    _confirmPasswordController.addListener(() {
      setState(() {}); // Update UI when text changes
    });
  }

  @override
  void dispose() {
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
          padding: EdgeInsets.all(AppConstants.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Back button
              _buildBackButton(),
              const SizedBox(height: 30),
              // Title section
              _buildTitleSection(),
              const SizedBox(height: 40),
              // Password input field
              _buildPasswordInputField(),
              const SizedBox(height: 20),
              // Confirm password input field
              _buildConfirmPasswordInputField(),
              const SizedBox(height: 30),
              // Create password button
              _buildCreatePasswordButton(),
              const SizedBox(height: 30),
              // Help text
              _buildHelpText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.textPrimary,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tạo mật khẩu mới',
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Vui lòng nhập mật khẩu mới cho tài khoản',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.email,
          style: AppTextStyles.body1.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mật khẩu phải có ít nhất 6 ký tự',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordInputField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        style: AppTextStyles.body1.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Mật khẩu mới',
          hintStyle: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordInputField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _confirmPasswordController,
        obscureText: !_isConfirmPasswordVisible,
        style: AppTextStyles.body1.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Xác nhận mật khẩu mới',
          hintStyle: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            child: Icon(
              _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatePasswordButton() {
    return Consumer<ForgotPasswordViewModel>(
      builder: (context, viewModel, child) {
        final isFormValid = _passwordController.text.trim().isNotEmpty &&
            _confirmPasswordController.text.trim().isNotEmpty &&
            _passwordController.text.trim() == _confirmPasswordController.text.trim();

        return SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: !viewModel.isLoading && isFormValid
                ? () => _handleCreatePassword(viewModel)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: !viewModel.isLoading && isFormValid
                  ? AppColors.primary
                  : AppColors.textSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
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
                        'Tạo mật khẩu mới',
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

  Widget _buildHelpText() {
    return Column(
      children: [
        Text(
          'Mật khẩu xác nhận phải khớp với mật khẩu mới',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _handleCreatePassword(ForgotPasswordViewModel viewModel) async {
    if (_passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập mật khẩu mới'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu phải có ít nhất 6 ký tự'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng xác nhận mật khẩu'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không khớp'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await viewModel.resetPassword(_passwordController.text.trim());

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu đã được tạo thành công!'),
          backgroundColor: AppColors.success,
        ),
      );
      // Navigate back to login page
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppConstants.routeSignIn,
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Tạo mật khẩu thất bại'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}