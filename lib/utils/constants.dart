class AppConstants {
  // App Information
  static const String appName = 'FTES';
  static const String appVersion = '1.0.1';
  static const String appDescription = 'FTES - AI-Learning Platform';
  
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
  
  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;
  
  // Button Heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 40.0;
  static const double buttonHeightL = 48.0;
  static const double buttonHeightXL = 56.0;
  
  // Card Dimensions
  static const double cardElevation = 2.0;
  static const double cardElevationHover = 4.0;
  static const double cardPadding = 16.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 1000);
  
  // Screen Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  // Grid Settings
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 1.2;
  static const double gridSpacing = 16.0;
  
  // List Settings
  static const double listItemHeight = 72.0;
  static const double listItemPadding = 16.0;
  
  // Image Settings
  static const double avatarSizeS = 32.0;
  static const double avatarSizeM = 48.0;
  static const double avatarSizeL = 64.0;
  static const double avatarSizeXL = 96.0;
  
  // Progress Settings
  static const double progressBarHeight = 8.0;
  static const double progressIndicatorSize = 24.0;
  
  // Shadow Settings
  static const double shadowBlurRadius = 8.0;
  static const double shadowSpreadRadius = 0.0;
  static const double shadowOffsetY = 2.0;
  
  // API Settings (for future use)
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String keyUserData = 'user_data';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyLearningProgress = 'learning_progress';
  
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
  
  // Asset Paths
  static const String assetsImages = 'assets/images/';
  static const String assetsIcons = 'assets/icons/';
  static const String assetsLottie = 'assets/lottie/';
  
  // Default Values
  static const int defaultQuizTime = 300; // 5 minutes in seconds
  static const int maxQuizQuestions = 20;
  static const int minPassingScore = 70;
  
  // Error Messages
  static const String errorGeneral = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorNotFound = 'Content not found.';
}
