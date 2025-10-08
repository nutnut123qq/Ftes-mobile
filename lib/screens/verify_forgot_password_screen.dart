import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';
import '../providers/auth_provider.dart';

class VerifyForgotPasswordScreen extends StatefulWidget {
  final String? contactInfo;
  final String? method; // 'email' or 'sms'
  
  const VerifyForgotPasswordScreen({
    super.key,
    this.contactInfo,
    this.method,
  });

  @override
  State<VerifyForgotPasswordScreen> createState() => _VerifyForgotPasswordScreenState();
}

class _VerifyForgotPasswordScreenState extends State<VerifyForgotPasswordScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _resendCountdown = 59;
  bool _isResendEnabled = false;
  String _otpCode = '';
  String _contactInfo = '';
  String _method = 'email';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get arguments from navigation
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _contactInfo = args['contactInfo'] ?? widget.contactInfo ?? '';
      _method = args['method'] ?? widget.method ?? 'email';
    } else {
      _contactInfo = widget.contactInfo ?? '';
      _method = widget.method ?? 'email';
    }
    
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
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _isResendEnabled = true;
          }
        });
        return _resendCountdown > 0;
      }
      return false;
    });
  }

  void _onNumberPressed(String number) {
    if (_otpCode.length < 6) {
      setState(() {
        _otpCode += number;
        _otpControllers[_otpCode.length - 1].text = number;
      });
      
      if (_otpCode.length < 6) {
        _focusNodes[_otpCode.length].requestFocus();
      }
    }
  }

  void _onBackspacePressed() {
    if (_otpCode.isNotEmpty) {
      setState(() {
        _otpCode = _otpCode.substring(0, _otpCode.length - 1);
        _otpControllers[_otpCode.length].text = '';
      });
      
      if (_otpCode.isNotEmpty) {
        _focusNodes[_otpCode.length].requestFocus();
      } else {
        _focusNodes[0].requestFocus();
      }
    }
  }

  void _resendCode() async {
    if (_isResendEnabled) {
      setState(() {
        _resendCountdown = 59;
        _isResendEnabled = false;
        _otpCode = '';
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      });
      _startCountdown();
      
      // Call the backend to resend verification code
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        final success = await authProvider.resendVerificationCode(_contactInfo);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _method == 'email' 
                    ? 'Mã xác thực mới đã được gửi đến email của bạn!'
                    : 'Mã xác thực mới đã được gửi đến số điện thoại của bạn!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gửi lại mã xác thực thất bại. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gửi lại mã xác thực thất bại: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _verifyCode() async {
    if (_otpCode.length == 6) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      try {
        final success = await authProvider.verifyEmailOTP(_contactInfo, _otpCode);
          
          if (success && mounted) {
            // Navigate to congratulations screen after successful email verification
            Navigator.pushReplacementNamed(context, AppConstants.routeCongratulations);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Xác thực email thất bại: $e')),
            );
          }
        }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ 6 số!')),
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
                    'Forgot Password',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 134),
              // Description text
              Center(
                child: Text(
                  'Code has been Send to $_contactInfo',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 50,
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
                      border: _otpCode.length == index && _otpCode.isNotEmpty
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.heading1.copyWith(
                        color: const Color(0xFF505050),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          setState(() {
                            _otpCode = _otpCode.length > index 
                                ? _otpCode.substring(0, index) + value + _otpCode.substring(index + 1)
                                : _otpCode + value;
                          });
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 50),
              // Resend code text
              Center(
                child: GestureDetector(
                  onTap: _isResendEnabled ? _resendCode : null,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Resend Code in ',
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF545454),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: '$_resendCountdown',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 's',
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF545454),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Verify button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _otpCode.length == 6 ? _verifyCode : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _otpCode.length == 6 
                        ? AppColors.primary 
                        : AppColors.textSecondary.withOpacity(0.3),
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
                        'Verify',
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
              const SizedBox(height: 64),
              // Number pad
              Center(
                child: _NumberPad(
                  onNumberPressed: _onNumberPressed,
                  onBackspacePressed: _onBackspacePressed,
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

class _NumberPad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;

  const _NumberPad({
    required this.onNumberPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 297,
      height: 267,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Row 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NumberButton('1', onNumberPressed),
              _NumberButton('2', onNumberPressed),
              _NumberButton('3', onNumberPressed),
            ],
          ),
          // Row 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NumberButton('4', onNumberPressed),
              _NumberButton('5', onNumberPressed),
              _NumberButton('6', onNumberPressed),
            ],
          ),
          // Row 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NumberButton('7', onNumberPressed),
              _NumberButton('8', onNumberPressed),
              _NumberButton('9', onNumberPressed),
            ],
          ),
          // Row 4: *, 0, backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NumberButton('*', onNumberPressed),
              _NumberButton('0', onNumberPressed),
              _BackspaceButton(onBackspacePressed),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final String number;
  final Function(String) onPressed;

  const _NumberButton(this.number, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(number),
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Center(
          child: Text(
            number,
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF505050),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackspaceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackspaceButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Color(0xFF505050),
            size: 24,
          ),
        ),
      ),
    );
  }
}
