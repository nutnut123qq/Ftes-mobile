/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'FTES';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Flutter Learning App for educational purposes';
  
  // API Configuration
  static const String baseUrl = 'https://api.ftes.vn';
  static const String videoStreamBaseUrl = 'https://stream.ftes.cloud'; // Video streaming server
  static const String videoCdnBaseUrl = 'https://ftes-cdn.b-cdn.net'; // Video CDN server
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
  static const String keyUserId = 'user_id';
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
  static const String routeVerifyEmail = '/verify-email';
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
  static const String routeCourseVideo = '/course-video';
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
  static const String routeBlogList = '/blog-list';
  static const String routeBlogDetail = '/blog-detail';
  
  // API Endpoints
  static const String loginEndpoint = '/api/auth/token';
  static const String registerEndpoint = '/api/users/registration';
  static const String googleAuthEndpoint = '/api/auth/outbound/authentication';
  static const String verifyEmailCodeEndpoint = '/api/auth/verify-email-code';
  static const String resendVerifyCodeEndpoint = '/users/mail/resend-verify-code';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String activeUserEndpoint = '/auth/activate';
  static const String myInfoEndpoint = '/user/me';
  static const String introspectEndpoint = '/auth/introspect';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String sendSecretKeyEndpoint = '/auth/2fa/send-secret';
  static const String verifyUpdateEmailEndpoint = '/auth/verify-update-email';
  static const String changePasswordEndpoint = '/user/change-password';
  static const String updateGmailEndpoint = '/user/update-gmail';
  static const String bannerEndpoint = '/api/banner';
  static const String featuredCoursesEndpoint = '/api/courses/featured';
  static const String latestCoursesEndpoint = '/api/courses';
  static const String coursesSearchEndpoint = '/api/courses/search';
  static const String courseDetailEndpoint = '/api/courses/detail';
  static const String profileViewEndpoint = '/api/profiles/view';
  static const String checkEnrollmentByUserEndpoint = '/api/profiles';
  static const String profileEndpoint = '/api/profiles';
  
  // Auth Endpoints
  static const String verifyPinEndpoint = '/auth/verify-pin';
  static const String userRegistrationEndpoint = '/api/users/registration';
  
  // Blog Endpoints
  static const String blogCategoriesEndpoint = '/api/blog-categories/search';
  static const String blogsEndpoint = '/api/blogs';
  static const String blogsSearchEndpoint = '/api/blogs/search';
  static const String blogsByCategoryEndpoint = '/api/blogs/category';
  static const String blogsInteractiveEndpoint = '/api/blogs/interactive';
  
  // Cart Endpoints
  static const String cartEndpoint = '/api/cart';
  static const String cartCountEndpoint = '/api/cart/count';
  static const String cartTotalEndpoint = '/api/cart/total';
  
  // Course Endpoints
  static const String coursesEndpoint = '/api/courses';
  static const String userCoursesEndpoint = '/user/courses';
  static const String myCoursesEndpoint = '/api/courses/join';
  static const String lessonDetailEndpoint = '/lessons/detail';
  static const String checkEnrollmentEndpoint = '/enrollments/check';
  static const String enrollCourseEndpoint = '/enrollments/enroll';
  static const String courseCategoriesEndpoint = '/api/course-categories';
  
  // Video Endpoints (sử dụng videoStreamBaseUrl)
  static const String videoPlaylistEndpoint = '/api/videos'; // /{videoId}/playlist
  static const String videoStatusEndpoint = '/api/videos'; // /{videoId}/status
  static const String videoProgressEndpoint = '/api/videos'; // /{videoId}/progress
  static const String videoProxyEndpoint = '/api/videos/proxy'; // /{videoId}/master.m3u8
  
  // Image Endpoints
  static const String uploadImageEndpoint = '/images/upload';
  
  // Order Endpoints
  static const String orderEndpoint = '/api/order';
  static const String orderCancelEndpoint = '/api/order/cancel';
  
  // Profile Endpoints
  static const String viewProfileEndpoint = '/profile/view';
  static const String createProfileEndpoint = '/profile/create';
  static const String updateProfileEndpoint = '/profile/update';
  
  // Default Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Forgot Password Endpoints
  static const String sendForgotPasswordEmailEndpoint = '/api/users/mail/forgot-password';
  static const String resetPasswordEndpoint = '/api/users/reset-password';
  
  // Error Messages
  static const String errorGeneral = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorNotFound = 'Content not found.';
  static const String errorUnauthorized = 'Unauthorized. Please login again.';
  static const String errorServer = 'Server error. Please try again later.';
  
  // Video Messages
  static const String videoLoadingMessage = 'Đang tải video...';
  static const String videoProcessingMessage = 'Video đang được xử lý, vui lòng đợi...';
  static const String videoFailedMessage = 'Không thể tải video. Vui lòng thử lại sau.';
  static const String videoNotFoundMessage = 'Video không tồn tại.';
  static const String videoReadyMessage = 'Video đã sẵn sàng';
  
  // Video Status Constants
  static const String videoStatusReady = 'ready';
  static const String videoStatusProcessing = 'processing';
  static const String videoStatusFailed = 'failed';
  static const String videoStatusPending = 'pending';
  
  // Video Type Detection
  static const String youtubeEmbedUrl = 'https://www.youtube.com/embed/';
  static const String vimeoEmbedUrl = 'https://player.vimeo.com/video/';
  
  // AI Chat Endpoints
  static const String aiChatEndpoint = '/api/ai/chat';
  static const String aiCheckVideoKnowledgeEndpoint = 'https://ai.ftes.vn/api/ai/check-video-knowledge';
}
