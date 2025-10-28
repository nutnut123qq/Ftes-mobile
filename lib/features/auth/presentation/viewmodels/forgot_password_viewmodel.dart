import 'package:flutter/foundation.dart';
import 'package:ftes/features/auth/domain/constants/auth_constants.dart';
import '../../domain/usecases/send_forgot_password_email_usecase.dart';
import '../../domain/usecases/verify_forgot_password_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

enum ForgotPasswordStep { email, otp, resetPassword }

class ForgotPasswordViewModel extends ChangeNotifier {
  final SendForgotPasswordEmailUseCase sendForgotPasswordEmailUseCase;
  final VerifyForgotPasswordOTPUseCase verifyForgotPasswordOTPUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordViewModel({
    required this.sendForgotPasswordEmailUseCase,
    required this.verifyForgotPasswordOTPUseCase,
    required this.resetPasswordUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  String? _email;
  String? _accessToken;
  ForgotPasswordStep _currentStep = ForgotPasswordStep.email;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get email => _email;
  String? get accessToken => _accessToken;
  ForgotPasswordStep get currentStep => _currentStep;

  Future<bool> sendForgotPasswordEmail(String email) async {
    _setLoading(true);
    _clearError();
    
    final result = await sendForgotPasswordEmailUseCase(email);
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (_) {
        _email = email;
        _currentStep = ForgotPasswordStep.otp;
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> verifyOTP(String email, int otp) async {
    _setLoading(true);
    _clearError();
    
    final result = await verifyForgotPasswordOTPUseCase(
      VerifyOTPParams(email: email, otp: otp),
    );
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (accessToken) {
        _accessToken = accessToken;
        _currentStep = ForgotPasswordStep.resetPassword;
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> resetPassword(String password) async {
    if (_accessToken == null) {
      _setError(AuthConstants.errorAccessTokenMissing);
      return false;
    }

    _setLoading(true);
    _clearError();
    
    final result = await resetPasswordUseCase(
      ResetPasswordParams(password: password, accessToken: _accessToken!),
    );
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (_) {
        _setLoading(false);
        return true;
      },
    );
  }

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

  void resetState() {
    _isLoading = false;
    _errorMessage = null;
    _email = null;
    _accessToken = null;
    _currentStep = ForgotPasswordStep.email;
    notifyListeners();
  }
}
