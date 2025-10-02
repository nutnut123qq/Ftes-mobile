class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://localhost:8081';
  
  // Authentication endpoints
  static const String loginEndpoint = '/api/auth/token';
  static const String googleAuthEndpoint = '/api/auth/outbound/authentication';
  static const String refreshTokenEndpoint = '/api/auth/refresh';
  static const String logoutEndpoint = '/api/auth/logout';
  static const String introspectEndpoint = '/api/auth/introspect';
  static const String verifyOtpEndpoint = '/api/auth/verify-otp';
  static const String verifyPinEndpoint = '/api/auth/verify-pin';
  static const String sendSecretKeyEndpoint = '/api/auth/send-secret-key';
  static const String verifyEmailCodeEndpoint = '/api/auth/verify-email-code';
  static const String verifyUpdateEmailEndpoint = '/api/auth/verify-update-email';
  
  // User management endpoints
  static const String userRegistrationEndpoint = '/api/users/registration';
  static const String resendVerifyCodeEndpoint = '/api/users/mail/resend-verify-code';
  static const String activeUserEndpoint = '/api/users/active-user';
  static const String forgotPasswordEndpoint = '/api/users/mail/forgot-password';
  static const String changePasswordEndpoint = '/api/users/change-password';
  static const String myInfoEndpoint = '/api/users/my-info';
  static const String updateGmailEndpoint = '/api/users/update-gmail-for-user';
  
  // Profile endpoints
  static const String viewProfileEndpoint = '/api/profiles/view';
  static const String profileDetailEndpoint = '/api/profiles/detail';
  static const String updateProfileEndpoint = '/api/profiles';
  static const String createProfileEndpoint = '/api/profiles/create';
  static const String darkModeEndpoint = '/api/profiles/dark-mode';
  
  // Image upload endpoints
  static const String uploadImageEndpoint = '/api/images/upload';
  static const String githubUploadImageEndpoint = '/api/github/upload-image';
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
