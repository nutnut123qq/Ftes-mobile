import 'package:flutter/material.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/forgot_password_page.dart';
import '../presentation/pages/verify_forgot_password_otp_page.dart';
import '../presentation/pages/create_new_password_page.dart';

class AuthRoutes {
  // Route names
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyForgotPassword = '/auth/verify-forgot-password';
  static const String createNewPassword = '/auth/create-new-password';

  /// Get all auth routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      verifyForgotPassword: (context) {
        final email = ModalRoute.of(context)?.settings.arguments as String?;
        return VerifyForgotPasswordOTPPage(email: email ?? '');
      },
      createNewPassword: (context) {
        final email = ModalRoute.of(context)?.settings.arguments as String?;
        return CreateNewPasswordPage(email: email ?? '');
      },
    };
  }
}


