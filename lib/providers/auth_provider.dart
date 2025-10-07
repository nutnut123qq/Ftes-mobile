import 'package:flutter/foundation.dart';
import '../models/auth_response.dart';
import '../models/auth_request.dart';
import '../models/user_request.dart';
import '../services/auth_service.dart';
import '../utils/error_handler.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserInfo? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Getters
  UserInfo? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  // Khởi tạo provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Initialize AuthService first
      _authService.initialize();
      
      _isLoggedIn = await _authService.isLoggedIn();
      if (_isLoggedIn) {
        _currentUser = await _authService.getMyInfo();
      }
    } catch (e) {
      _setError('Khởi tạo thất bại: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Đăng nhập với email/password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = AuthenticationRequest(
        credential: email,  // Sử dụng credential thay vì email
        password: password,
      );
      
      final response = await _authService.login(request);
      _currentUser = response.user;
      _isLoggedIn = response.authenticated ?? true; // Sử dụng authenticated field hoặc mặc định true
      
      notifyListeners();
      return true;
    } catch (e) {
      final errorMessage = ErrorHandler.parseLoginError(e);
      _setError(errorMessage);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Đăng nhập với Google
  Future<bool> loginWithGoogle({bool isAdmin = false}) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _authService.loginWithGoogle(isAdmin: isAdmin);
      _currentUser = response.user;
      _isLoggedIn = response.authenticated ?? true; // Sử dụng authenticated field hoặc mặc định true
      
      notifyListeners();
      return true;
    } catch (e) {
      final errorMessage = ErrorHandler.parseError(e);
      _setError(errorMessage);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Đăng ký
  Future<bool> register({
    required String email,
    required String password,
    required String username,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = UserRegistrationRequest(
        email: email,
        password: password,
        username: username,
      );
      
      await _authService.register(request);
      return true;
    } catch (e) {
      final errorMessage = ErrorHandler.parseRegisterError(e);
      _setError(errorMessage);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Xác thực email OTP
  Future<bool> verifyEmailOTP(String email, String code) async {
    _setLoading(true);
    _clearError();
    
    try {
      
      await _authService.verifyEmailOTP(email, code);
      
      // Update state after successful verification and activation
      _isLoggedIn = true;
      
      try {
        _currentUser = await _authService.getMyInfo();
      } catch (e) {
        // Don't fail the whole process if getMyInfo fails
        _currentUser = null;
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      final errorMessage = ErrorHandler.parseVerificationError(e);
      _setError(errorMessage);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Xác thực PIN
  Future<bool> verifyPin(String pin) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.verifyPin(pin);
      return true;
    } catch (e) {
      _setError('Xác thực PIN thất bại: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Quên mật khẩu
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.forgotPassword(email);
      return true;
    } catch (e) {
      _setError('Gửi email reset thất bại: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.logout();
      _currentUser = null;
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      _setError('Đăng xuất thất bại: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Làm mới thông tin người dùng
  Future<void> refreshUserInfo() async {
    if (!_isLoggedIn) return;
    
    try {
      _currentUser = await _authService.getMyInfo();
      notifyListeners();
    } catch (e) {
      _setError('Lấy thông tin người dùng thất bại: $e');
    }
  }

  // Đổi mật khẩu
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      await _authService.changePassword(_currentUser!.id, request);
      return true;
    } catch (e) {
      _setError('Đổi mật khẩu thất bại: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Xác thực OTP
  Future<bool> verifyOTP(String code) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = GenericAuthCodeRequest(code: code);
      await _authService.verifyOTP(request);
      return true;
    } catch (e) {
      _setError('Xác thực OTP thất bại: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Gửi lại mã xác thực
  Future<bool> resendVerificationCode(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.resendVerifyCode(email);
      return true;
    } catch (e) {
      _setError('Gửi lại mã xác thực thất bại: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Kích hoạt tài khoản
  Future<bool> activateAccount(String accessToken) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.activateUser(accessToken);
      return true;
    } catch (e) {
      _setError('Kích hoạt tài khoản thất bại: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Dispose
  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }
}
