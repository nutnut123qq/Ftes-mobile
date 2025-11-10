import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../features/auth/data/datasources/auth_local_datasource_impl.dart';
import '../services/token_validator.dart';

/// Helper class for authentication operations
class AuthHelper {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool _isLoggingOut = false;

  /// Logout user and navigate to login page
  /// Prevents multiple simultaneous logout attempts
  static Future<void> logoutAndNavigateToLogin() async {
    // Prevent multiple logout attempts
    if (_isLoggingOut) {
      debugPrint('⚠️ Logout already in progress, skipping...');
      return;
    }

    _isLoggingOut = true;

    try {
      debugPrint('🚪 Logging out user...');
      
      // Clear auth data
      final prefs = await SharedPreferences.getInstance();
      final localDataSource = AuthLocalDataSourceImpl(sharedPreferences: prefs);
      await localDataSource.clearAuthData();
      
      // Clear token validator cache
      // TokenValidator is singleton, so we can clear it directly
      TokenValidator.getInstance(null).clearCache();
      
      debugPrint('✅ Auth data cleared');
      
      // Navigate to login page
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppConstants.routeSignIn,
          (route) => false,
        );
        debugPrint('✅ Navigated to login page');
      } else {
        debugPrint('⚠️ Navigator context not available or unmounted');
      }
    } catch (e) {
      debugPrint('❌ Error during logout: $e');
    } finally {
      // Reset flag after a delay
      Future.delayed(const Duration(seconds: 2), () {
        _isLoggingOut = false;
      });
    }
  }
}

