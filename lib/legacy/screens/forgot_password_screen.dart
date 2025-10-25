import 'package:flutter/material.dart';

@Deprecated('Use features/auth/presentation/pages/forgot_password_page.dart instead. '
    'This file will be removed in v2.0.0')
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Legacy ForgotPasswordScreen - Use new implementation in features/auth/'),
      ),
    );
  }
}