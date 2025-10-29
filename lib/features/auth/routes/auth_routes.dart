import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/di/injection_container.dart' as di;
import '../presentation/viewmodels/forgot_password_viewmodel.dart';
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
      forgotPassword: (context) => ChangeNotifierProvider(
        create: (context) => di.sl<ForgotPasswordViewModel>(),
        child: const ForgotPasswordPage(),
      ),
      verifyForgotPassword: (context) {
        final email = ModalRoute.of(context)?.settings.arguments as String?;
        return ChangeNotifierProvider(
          create: (context) => di.sl<ForgotPasswordViewModel>(),
          child: VerifyForgotPasswordOTPPage(email: email ?? ''),
        );
      },
      createNewPassword: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        String email = '';
        String? accessToken;
        if (args is Map<String, dynamic>) {
          email = args['email'] as String? ?? '';
          accessToken = args['accessToken'] as String?;
        } else if (args is String) {
          email = args;
        }
        return ChangeNotifierProvider(
          create: (context) {
            final vm = di.sl<ForgotPasswordViewModel>();
            if (accessToken != null && accessToken.isNotEmpty) {
              vm.setAccessToken(accessToken);
            }
            return vm;
          },
          child: CreateNewPasswordPage(email: email),
        );
      },
    };
  }
}


