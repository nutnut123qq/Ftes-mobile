import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/utils/colors.dart';
import 'package:ftes/core/utils/text_styles.dart';
import '../viewmodels/forgot_password_viewmodel.dart';

class VerifyForgotPasswordOTPPage extends StatefulWidget {
  final String email;

  const VerifyForgotPasswordOTPPage({super.key, required this.email});

  @override
  State<VerifyForgotPasswordOTPPage> createState() => _VerifyForgotPasswordOTPPageState();
}

class _VerifyForgotPasswordOTPPageState extends State<VerifyForgotPasswordOTPPage> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _resendCountdown = 59;
  bool _isResendEnabled = false;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _resendCountdown--;
          if (_resendCountdown <= 0) {
            _isResendEnabled = true;
          }
        });
        if (_resendCountdown > 0) {
          _startCountdown();
        }
      }
    });
  }

  void _onOTPChanged(int index, String value) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    _updateOTPCode();
  }

  void _updateOTPCode() {
    _otpCode = _otpControllers.map((controller) => controller.text).join();
    if (_otpCode.length == 6) {
      _verifyOTP();
    }
  }

  void _verifyOTP() async {
    final otp = int.tryParse(_otpCode);
    if (otp == null) return;

    final viewModel = Provider.of<ForgotPasswordViewModel>(context, listen: false);
    final success = await viewModel.verifyOTP(widget.email, otp);
    
    if (success && mounted) {
      Navigator.pushNamed(
        context,
        AppConstants.routeCreateNewPassword,
        arguments: widget.email,
      );
    }
  }

  void _resendCode() async {
    final viewModel = Provider.of<ForgotPasswordViewModel>(context, listen: false);
    final success = await viewModel.sendForgotPasswordEmail(widget.email);
    
    if (success && mounted) {
      setState(() {
        _resendCountdown = 59;
        _isResendEnabled = false;
      });
      _startCountdown();
      
      // Clear OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _otpCode = '';
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
                    'Xác thực OTP',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Description text
              Center(
                child: Text(
                  'Nhập mã xác thực đã được gửi đến\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) => _onOTPChanged(index, value),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              // Verify Button
              Consumer<ForgotPasswordViewModel>(
                builder: (context, viewModel, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading || _otpCode.length != 6 ? null : _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Xác thực',
                              style: AppTextStyles.button.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Resend Code Button
              Center(
                child: Consumer<ForgotPasswordViewModel>(
                  builder: (context, viewModel, child) {
                    return TextButton(
                      onPressed: _isResendEnabled && !viewModel.isLoading ? _resendCode : null,
                      child: Text(
                        _isResendEnabled 
                            ? 'Gửi lại mã' 
                            : 'Gửi lại mã sau ${_resendCountdown}s',
                        style: AppTextStyles.body1.copyWith(
                          color: _isResendEnabled ? AppColors.primary : Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Error message
              Consumer<ForgotPasswordViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.errorMessage != null) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
