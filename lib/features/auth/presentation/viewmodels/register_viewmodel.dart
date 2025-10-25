import 'package:flutter/foundation.dart';
import 'package:ftes/core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/verify_email_otp_usecase.dart';
import '../../domain/usecases/resend_verification_code_usecase.dart';

class RegisterViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;
  final VerifyEmailOTPUseCase verifyEmailOTPUseCase;
  final ResendVerificationCodeUseCase resendVerificationCodeUseCase;

  RegisterViewModel({
    required this.registerUseCase,
    required this.verifyEmailOTPUseCase,
    required this.resendVerificationCodeUseCase,
  });

  // State variables
  User? _registeredUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isRegistered = false;
  String? _registeredEmail;

  // Getters
  User? get registeredUser => _registeredUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isRegistered => _isRegistered;
  String? get registeredEmail => _registeredEmail;

  /// Register new user
  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await registerUseCase(RegisterParams(
        username: username,
        email: email,
        password: password,
      ));

      return result.fold(
        (failure) {
          _setError(_mapFailureToMessage(failure));
          return false;
        },
        (user) {
          _registeredUser = user;
          _isRegistered = true;
          _registeredEmail = email;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError('Registration failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Verify email OTP
  Future<bool> verifyOTP(String email, int otp) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await verifyEmailOTPUseCase(VerifyOTPParams(
        email: email,
        otp: otp,
      ));

      return result.fold(
        (failure) {
          _setError(_mapFailureToMessage(failure));
          return false;
        },
        (accessToken) {
          // Token is already cached in repository
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError('OTP verification failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Resend verification code
  Future<bool> resendCode(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await resendVerificationCodeUseCase(email);

      return result.fold(
        (failure) {
          _setError(_mapFailureToMessage(failure));
          return false;
        },
        (_) {
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError('Resend code failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Clear error message
  void clearError() {
    _clearError();
  }

  /// Reset state
  void reset() {
    _registeredUser = null;
    _isRegistered = false;
    _registeredEmail = null;
    _clearError();
    notifyListeners();
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
