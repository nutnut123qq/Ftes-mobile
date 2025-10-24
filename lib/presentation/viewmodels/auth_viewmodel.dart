import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../core/error/failures.dart';

/// ViewModel for authentication operations
class AuthViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthViewModel({
    required LoginUseCase loginUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _loginWithGoogleUseCase = loginWithGoogleUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _logoutUseCase = logoutUseCase;

  // State variables
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  /// Initialize the ViewModel
  Future<void> initialize() async {
    _setLoading(true);
    try {
      final result = await _getCurrentUserUseCase();
      result.fold(
        (failure) => _setError(_mapFailureToMessage(failure)),
        (user) {
          _currentUser = user;
          _isLoggedIn = true;
        },
      );
    } catch (e) {
      _setError('Initialization failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _loginUseCase(email, password);

      return result.fold(
        (failure) {
          _setError(_mapFailureToMessage(failure));
          return false;
        },
        (user) {
          _currentUser = user;
          _isLoggedIn = true;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError('Login failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Login with Google OAuth
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _loginWithGoogleUseCase();

      return result.fold(
        (failure) {
          _setError(_mapFailureToMessage(failure));
          return false;
        },
        (user) {
          _currentUser = user;
          _isLoggedIn = true;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError('Google login failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout
  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _logoutUseCase();
      result.fold(
        (failure) => _setError(_mapFailureToMessage(failure)),
        (_) {
          _currentUser = null;
          _isLoggedIn = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _setError('Logout failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh user information
  Future<void> refreshUserInfo() async {
    if (!_isLoggedIn) return;

    try {
      final result = await _getCurrentUserUseCase();
      result.fold(
        (failure) => _setError(_mapFailureToMessage(failure)),
        (user) {
          _currentUser = user;
          notifyListeners();
        },
      );
    } catch (e) {
      _setError('Failed to refresh user info: $e');
    }
  }

  /// Clear error message
  void clearError() {
    _clearError();
  }

  // Private helper methods
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
    notifyListeners();
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      case CacheFailure:
        return 'Cache error: ${failure.message}';
      case AuthFailure:
        return 'Authentication error: ${failure.message}';
      case ValidationFailure:
        return 'Validation error: ${failure.message}';
      default:
        return failure.message;
    }
  }
}
