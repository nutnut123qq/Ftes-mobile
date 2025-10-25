import 'package:flutter/material.dart';

@Deprecated('Use features/auth/presentation/pages/create_new_password_page.dart instead. '
    'This file will be removed in v2.0.0')
class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Legacy CreateNewPasswordScreen - Use new implementation in features/auth/'),
      ),
    );
  }
}