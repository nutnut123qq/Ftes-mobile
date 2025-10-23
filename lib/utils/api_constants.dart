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
  // Banner & Courses
  static const String bannerEndpoint = '/api/banner';
  static const String featuredCoursesEndpoint = '/api/courses/featured';
  
  // Course endpoints
  static const String coursesEndpoint = '/api/courses';
  static const String courseDetailEndpoint = '/api/courses/detail';
  static const String coursesSearchEndpoint = '/api/courses/search';
  static const String latestCoursesEndpoint = '/api/courses/latest';
  static const String userCoursesEndpoint = '/api/courses/join';
  static const String checkEnrollmentEndpoint = '/api/user-courses/check-enrollment';
  static const String enrollCourseEndpoint = '/api/user-courses';
  
  // Part endpoints
  static const String partsEndpoint = '/api/parts';
  static const String coursePartsEndpoint = '/api/parts/course';
  
  // Lesson endpoints
  static const String lessonsEndpoint = '/api/lessons';
  static const String lessonDetailEndpoint = '/api/lessons';
  static const String partLessonsEndpoint = '/api/lessons/part';
  
  // Profile endpoints
  static const String viewProfileEndpoint = '/api/profiles/view';
  static const String profileDetailEndpoint = '/api/profiles/detail';
  static const String updateProfileEndpoint = '/api/profiles';
  static const String createProfileEndpoint = '/api/profiles/create';
  static const String darkModeEndpoint = '/api/profiles/dark-mode';
  
  // Image upload endpoints
  static const String uploadImageEndpoint = '/api/images/upload';
  static const String githubUploadImageEndpoint = '/api/github/upload-image';
  
  // Blog endpoints
  static const String blogsEndpoint = '/api/blogs';
  static const String blogsByCategoryEndpoint = '/api/blogs/get-by-category';
  static const String blogsSearchEndpoint = '/api/blogs/search';
  static const String blogsInteractiveEndpoint = '/api/blogs/interactive';
  
  // Cart endpoints
  static const String cartEndpoint = '/api/cart';
  static const String cartCountEndpoint = '/api/cart/count';
  static const String cartTotalEndpoint = '/api/cart/total';
  
  // Order endpoints
  static const String orderEndpoint = '/api/order';
  static const String orderCancelEndpoint = '/api/order/cancel';
  
  // Points & Affiliate endpoints
  static const String userPointsEndpoint = '/api/points/user';
  static const String pointTransactionsEndpoint = '/api/points/transactions';
  static const String referralEndpoint = '/api/points/referral';
  static const String referralCountEndpoint = '/api/points/referral/count';
  static const String invitedUsersEndpoint = '/api/points/invited';
  static const String pointsChartEndpoint = '/api/points/chart';
  static const String withdrawPointsEndpoint = '/api/points/withdraw';
  static const String setReferralEndpoint = '/api/points/set-referral';
  
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
