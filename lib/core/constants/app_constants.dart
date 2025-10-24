/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'FTES';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Flutter Learning App for educational purposes';
  
  // API Configuration
  static const String baseUrl = 'https://api.ftes.vn';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;
  static const double radiusCircle = 50.0;
  
  // Card Settings
  static const double cardElevation = 2.0;
  static const double cardElevationHover = 4.0;
  
  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserData = 'user_data';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyFirstLaunch = 'first_launch';
  
  // Route Names
  static const String routeSplash = '/';
  static const String routeLaunching = '/launching';
  static const String routeIntro = '/intro';
  static const String routeLetsYouIn = '/lets-you-in';
  static const String routeSignIn = '/signin';
  static const String routeSignUp = '/signup';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeVerifyForgotPassword = '/verify-forgot-password';
  static const String routeCreateNewPassword = '/create-new-password';
  static const String routeCongratulations = '/congratulations';
  static const String routeCreatePin = '/create-pin';
  static const String routeHome = '/home';
  static const String routeSearch = '/search';
  static const String routePopularCourses = '/popular-courses';
  static const String routeTopMentors = '/top-mentors';
  static const String routeCoursesList = '/courses-list';
  static const String routeMentorsList = '/mentors-list';
  static const String routeSingleMentorDetails = '/single-mentor-details';
  static const String routeCourseDetail = '/course-detail';
  static const String routeLearning = '/learning';
  static const String routeQuiz = '/quiz';
  static const String routeProfile = '/profile';
  static const String routeNotifications = '/notifications';
  static const String routeChatMessages = '/chat-messages';
  static const String routeCurriculum = '/curriculum';
  static const String routeReviews = '/reviews';
  static const String routeWriteReview = '/write-review';
  static const String routePayment = '/payment';
  static const String routeEnrollSuccess = '/enroll-success';
  static const String routeMyCourses = '/my-courses';
  static const String routeMyCourseOngoingLessons = '/my-course-ongoing-lessons';
  static const String routeMyCourseOngoingVideo = '/my-course-ongoing-video';
  static const String routeInviteFriends = '/invite-friends';
  static const String routeCart = '/cart';
  static const String routeBlogDetail = '/blog-detail';
  
  // API Endpoints
  static const String loginEndpoint = '/api/auth/token';
  static const String registerEndpoint = '/auth/register';
  static const String googleAuthEndpoint = '/auth/google';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String verifyEmailCodeEndpoint = '/auth/verify-email';
  static const String resendVerifyCodeEndpoint = '/auth/resend-verification';
  static const String activeUserEndpoint = '/auth/activate';
  static const String myInfoEndpoint = '/user/me';
  static const String introspectEndpoint = '/auth/introspect';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String sendSecretKeyEndpoint = '/auth/2fa/send-secret';
  static const String verifyUpdateEmailEndpoint = '/auth/verify-update-email';
  static const String changePasswordEndpoint = '/user/change-password';
  static const String updateGmailEndpoint = '/user/update-gmail';
  
  // Default Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Error Messages
  static const String errorGeneral = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorNotFound = 'Content not found.';
  static const String errorUnauthorized = 'Unauthorized. Please login again.';
  static const String errorServer = 'Server error. Please try again later.';
}
