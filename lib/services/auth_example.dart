import '../models/auth_request.dart';
import '../models/user_request.dart';
import 'auth_service.dart';

/// Example usage of AuthService
class AuthExample {
  final AuthService _authService = AuthService();

  /// Initialize the auth service
  Future<void> initialize() async {
    await _authService.initialize();
  }

  /// Example: Login with email and password
  Future<void> loginExample() async {
    try {
      final request = AuthenticationRequest(
        credential: 'user@example.com',
        password: 'password123',
      );

      final response = await _authService.login(request);
      
    } catch (e) {
    }
  }

  /// Example: Login with Google
  Future<void> loginWithGoogleExample() async {
    try {
      final response = await _authService.loginWithGoogle(isAdmin: false);
      
    } catch (e) {
    }
  }

  /// Example: Register new user
  Future<void> registerExample() async {
    try {
      final request = UserRegistrationRequest(
        email: 'newuser@example.com',
        password: 'password123',
        username: 'johndoe',
      );

      await _authService.register(request);
    } catch (e) {
    }
  }

  /// Example: Forgot password
  Future<void> forgotPasswordExample() async {
    try {
      await _authService.forgotPassword('user@example.com');
    } catch (e) {
    }
  }

  /// Example: Get current user info
  Future<void> getCurrentUserExample() async {
    try {
      final userInfo = await _authService.getMyInfo();
    } catch (e) {
    }
  }

  /// Example: Check if user is logged in
  Future<void> checkLoginStatusExample() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
    } catch (e) {
    }
  }

  /// Example: Logout
  Future<void> logoutExample() async {
    try {
      await _authService.logout();
    } catch (e) {
    }
  }

  /// Example: Change password
  Future<void> changePasswordExample() async {
    try {
      final request = ChangePasswordRequest(
        currentPassword: 'oldpassword',
        newPassword: 'newpassword123',
      );

      await _authService.changePassword('user_id_here', request);
    } catch (e) {
    }
  }

  /// Example: Verify OTP
  Future<void> verifyOTPExample() async {
    try {
      final request = GenericAuthCodeRequest(code: '123456');
      final response = await _authService.verifyOTP(request);
      
    } catch (e) {
    }
  }

  /// Example: Send secret key for 2FA
  Future<void> sendSecretKeyExample() async {
    try {
      final response = await _authService.sendSecretKeyFor2FA();
      
    } catch (e) {
    }
  }

  /// Example: Refresh token
  Future<void> refreshTokenExample() async {
    try {
      final request = RefreshTokenRequest(refreshToken: 'your_refresh_token');
      final response = await _authService.refreshToken(request);
      
    } catch (e) {
    }
  }

  /// Example: Introspect token
  Future<void> introspectTokenExample() async {
    try {
      final request = IntrospectRequest(token: 'your_access_token');
      final response = await _authService.introspect(request);
      
    } catch (e) {
    }
  }

  /// Dispose the auth service
  void dispose() {
    _authService.dispose();
  }
}
