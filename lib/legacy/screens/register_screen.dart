import 'package:flutter/material.dart';

@Deprecated('Use features/auth/presentation/pages/register_page.dart instead. '
    'This file will be removed in v2.0.0')
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Legacy RegisterScreen - Use new implementation in features/auth/'),
      ),
    );
  }
}