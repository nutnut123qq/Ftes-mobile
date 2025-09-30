import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/utils/constants.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key}); // Force rebuild

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  List<String> _pinDigits = ['', '', '', '', '', '']; // 6 digits
  int _currentIndex = 0;
  int _resendCountdown = 59;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    // Ensure _pinDigits has exactly 6 elements
    _pinDigits = List.filled(6, '');
    print('_pinDigits length: ${_pinDigits.length}'); // Debug
    _startCountdown();
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
      }
      return mounted && _resendCountdown > 0;
    });
  }

  void _resendPin() {
    setState(() {
      _resendCountdown = 59;
      _isResendEnabled = false;
    });
    _startCountdown();
    // TODO: Implement actual PIN resend logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN đã được gửi lại!')),
    );
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
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Create New Pin',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              // Description text
              Center(
                child: Text(
                  'Add a Pin Number to Make Your Account more Secure',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 80),
              // PIN input fields
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    // Safety check to prevent index out of range
                    if (index >= _pinDigits.length) {
                      return Container(width: 50, height: 60);
                    }
                    return Container(
                      margin: EdgeInsets.only(right: index < 5 ? 6 : 0),
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: _currentIndex == index
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _pinDigits[index].isEmpty ? '*' : _pinDigits[index],
                          style: AppTextStyles.body1.copyWith(
                            color: const Color(0xFF505050),
                            fontSize: _pinDigits[index].isEmpty ? 30 : 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 70),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isPinComplete() ? _continue : null,
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
                        'Continue',
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
              const SizedBox(height: 30),
              // Resend PIN section
              Center(
                child: _isResendEnabled
                    ? GestureDetector(
                        onTap: _resendPin,
                        child: Text(
                          'Resend PIN',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        'Resend PIN in ${_resendCountdown}s',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              const SizedBox(height: 30),
              // Number pad
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      // Row 1: 1, 2, 3
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NumberButton('1'),
                          const SizedBox(width: 60),
                          _NumberButton('2'),
                          const SizedBox(width: 60),
                          _NumberButton('3'),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Row 2: 4, 5, 6
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NumberButton('4'),
                          const SizedBox(width: 60),
                          _NumberButton('5'),
                          const SizedBox(width: 60),
                          _NumberButton('6'),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Row 3: 7, 8, 9
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NumberButton('7'),
                          const SizedBox(width: 60),
                          _NumberButton('8'),
                          const SizedBox(width: 60),
                          _NumberButton('9'),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Row 4: *, 0, backspace
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NumberButton('*'),
                          const SizedBox(width: 60),
                          _NumberButton('0'),
                          const SizedBox(width: 60),
                          _BackspaceButton(),
                        ],
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isPinComplete() {
    return _pinDigits.every((digit) => digit.isNotEmpty);
  }

  void _onNumberPressed(String number) {
    if (_currentIndex < 6) {
      setState(() {
        _pinDigits[_currentIndex] = number;
        _currentIndex++;
      });
    }
  }

  void _onBackspacePressed() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pinDigits[_currentIndex] = '';
      });
    }
  }

  void _continue() {
    if (_isPinComplete()) {
      // Navigate directly to congratulations screen
      Navigator.pushReplacementNamed(context, AppConstants.routeCongratulations);
    }
  }
}

class _NumberButton extends StatelessWidget {
  final String number;

  const _NumberButton(this.number);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Access the parent state through context
        final state = context.findAncestorStateOfType<_CreatePinScreenState>();
        state?._onNumberPressed(number);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Center(
          child: Text(
            number,
            style: AppTextStyles.body1.copyWith(
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
  const _BackspaceButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Access the parent state through context
        final state = context.findAncestorStateOfType<_CreatePinScreenState>();
        state?._onBackspacePressed();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Color(0xFF505050),
            size: 20,
          ),
        ),
      ),
    );
  }
}
