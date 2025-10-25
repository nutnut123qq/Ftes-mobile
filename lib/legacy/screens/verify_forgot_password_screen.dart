import 'package:flutter/material.dart';

@Deprecated('Use features/auth/presentation/pages/verify_forgot_password_otp_page.dart instead. '
    'This file will be removed in v2.0.0')
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Legacy VerifyForgotPasswordScreen - Use new implementation in features/auth/'),
      ),
    );
  }
}