import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart' as core_constants;
import '../screens/loading_screen.dart';
import '../screens/launching_screen.dart';
import '../screens/intro_screen.dart';
import '../screens/lets_you_in_screen.dart';
import '../features/auth/routes/auth_routes.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/verify_email_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/verify_forgot_password_otp_page.dart';
import '../features/auth/presentation/pages/create_new_password_page.dart';
import '../screens/congratulations_screen.dart';
import '../screens/create_pin_screen.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/viewmodels/home_viewmodel.dart';
import '../features/my_courses/presentation/pages/my_courses_page.dart';
import '../features/my_courses/presentation/viewmodels/my_courses_viewmodel.dart';
import '../features/my_courses/di/my_courses_injection.dart';
import '../screens/popular_courses_screen.dart';
import '../screens/top_mentors_screen.dart';
import '../screens/courses_list_screen.dart';
import '../screens/mentors_list_screen.dart';
import '../screens/single_mentor_details_screen.dart';
import '../features/course/presentation/pages/course_detail_page.dart';
import '../screens/learning_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/chat_messages_screen.dart';
import '../screens/curriculum_screen.dart';
import '../screens/reviews_screen.dart';
import '../screens/write_review_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/enroll_success_screen.dart';
import '../screens/my_course_ongoing_lessons_screen.dart';
import '../screens/my_course_ongoing_video_screen.dart';
import '../screens/invite_friends_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/blog_detail_screen.dart';
import '../models/course_item.dart';
import '../models/chat_item.dart';
import 'package:provider/provider.dart';
import '../core/di/injection_container.dart' as di;
import '../models/mentor_item.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    core_constants.AppConstants.routeSplash: (context) => const LoadingScreen(),
    core_constants.AppConstants.routeLaunching: (context) => const LaunchingScreen(),
    core_constants.AppConstants.routeIntro: (context) => const IntroScreen(),
    core_constants.AppConstants.routeLetsYouIn: (context) => const LetsYouInScreen(),
    core_constants.AppConstants.routeSignIn: (context) => const LoginPage(), // Add signin route
    core_constants.AppConstants.routeSignUp: (context) => const RegisterPage(), // Use new RegisterPage
    core_constants.AppConstants.routeVerifyEmail: (context) {
      final email = ModalRoute.of(context)?.settings.arguments as String?;
      return VerifyEmailPage(email: email ?? '');
    }, // Add verify email route
    core_constants.AppConstants.routeForgotPassword: (context) => const ForgotPasswordPage(), // Add forgot password route
    core_constants.AppConstants.routeVerifyForgotPassword: (context) {
      final email = ModalRoute.of(context)?.settings.arguments as String?;
      return VerifyForgotPasswordOTPPage(email: email ?? '');
    }, // Add verify forgot password route
    core_constants.AppConstants.routeCreateNewPassword: (context) {
      final email = ModalRoute.of(context)?.settings.arguments as String?;
      return CreateNewPasswordPage(email: email ?? '');
    }, // Add create new password route
    // Auth routes
    ...AuthRoutes.getRoutes(),
    core_constants.AppConstants.routeCongratulations: (context) => const CongratulationsScreen(),
    core_constants.AppConstants.routeCreatePin: (context) => const CreatePinScreen(),
    core_constants.AppConstants.routeHome: (context) => ChangeNotifierProvider(
      create: (context) => di.sl<HomeViewModel>(),
      child: const HomePage(),
    ),
    core_constants.AppConstants.routePopularCourses: (context) => const PopularCoursesScreen(),
    core_constants.AppConstants.routeTopMentors: (context) => const TopMentorsScreen(),
    core_constants.AppConstants.routeCoursesList: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return CoursesListScreen(
        initialSearchQuery: args?['searchQuery'],
      );
    },
    core_constants.AppConstants.routeMentorsList: (context) => const MentorsListScreen(),
    core_constants.AppConstants.routeSingleMentorDetails: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return SingleMentorDetailsScreen(
        mentor: args?['mentor'] ?? MentorItem(
          name: 'Default Mentor',
          specialization: 'Design',
          avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=M',
        ),
      );
    },
    core_constants.AppConstants.routeCourseDetail: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      CourseItem? course;
      
      if (arguments is Map<String, dynamic>) {
        course = arguments['course'] as CourseItem?;
      } else if (arguments is String) {
        // If slug is passed, create a CourseItem with just the id
        course = CourseItem(
          id: arguments,
          category: '',
          title: '',
          price: '0',
          rating: '0',
          students: '0',
          imageUrl: '',
        );
      }
      
      // If no valid course, navigate to home
      if (course == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed(core_constants.AppConstants.routeHome);
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      
      return CourseDetailPage(course: course);
    },
    core_constants.AppConstants.routeProfile: (context) => const ProfileScreen(),
    core_constants.AppConstants.routeNotifications: (context) => const NotificationsScreen(),
    core_constants.AppConstants.routeChatMessages: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return ChatMessagesScreen(
        chat: args?['chat'],
        lessonId: args?['lessonId'],
        lessonTitle: args?['lessonTitle'],
      );
    },
    core_constants.AppConstants.routeCurriculum: (context) => const CurriculumScreen(),
    core_constants.AppConstants.routeReviews: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return ReviewsScreen(
        courseId: args?['courseId'] ?? '',
        courseName: args?['courseName'],
      );
    },
    core_constants.AppConstants.routeWriteReview: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return WriteReviewScreen(
        courseId: args?['courseId'] ?? '',
        userId: args?['userId'] ?? '',
        courseName: args?['courseName'],
      );
    },
    core_constants.AppConstants.routePayment: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return PaymentScreen(
        orderId: args?['orderId'] ?? '',
        qrCodeUrl: args?['qrCodeUrl'],
        description: args?['description'],
      );
    },
    core_constants.AppConstants.routeEnrollSuccess: (context) => const EnrollSuccessScreen(),
    core_constants.AppConstants.routeMyCourses: (context) => ChangeNotifierProvider(
      create: (context) => sl<MyCoursesViewModel>(),
      child: const MyCoursesPage(),
    ),
    core_constants.AppConstants.routeMyCourseOngoingLessons: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return MyCourseOngoingLessonsScreen(
        courseId: args?['courseId'] ?? '',
        courseTitle: args?['courseTitle'] ?? 'Course Title',
        courseImage: args?['courseImage'] ?? '',
      );
    },
    core_constants.AppConstants.routeMyCourseOngoingVideo: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return MyCourseOngoingVideoScreen(
        lessonId: args?['lessonId'] ?? '',
        lessonTitle: args?['lessonTitle'] ?? 'Lesson Title',
        courseTitle: args?['courseTitle'] ?? 'Course Title',
        videoUrl: args?['videoUrl'] ?? '',
        currentTime: args?['currentTime'] ?? 0,
        totalTime: args?['totalTime'] ?? 0,
      );
    },
    core_constants.AppConstants.routeInviteFriends: (context) => const InviteFriendsScreen(),
    core_constants.AppConstants.routeCart: (context) => const CartScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case core_constants.AppConstants.routeSplash:
        return MaterialPageRoute(
          builder: (context) => const LoadingScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeLaunching:
        return MaterialPageRoute(
          builder: (context) => const LaunchingScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeIntro:
        return MaterialPageRoute(
          builder: (context) => const IntroScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeLetsYouIn:
        return MaterialPageRoute(
          builder: (context) => const LetsYouInScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeSignUp:
        return MaterialPageRoute(
          builder: (context) => const RegisterPage(),
          settings: settings,
        );
      // Auth routes are handled by AuthRoutes.getRoutes()
      // These cases are now managed by the auth feature
      case core_constants.AppConstants.routeCongratulations:
        return MaterialPageRoute(
          builder: (context) => const CongratulationsScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeCreatePin:
        return MaterialPageRoute(
          builder: (context) => const CreatePinScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeHome:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => di.sl<HomeViewModel>(),
            child: const HomePage(),
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routePopularCourses:
        return MaterialPageRoute(
          builder: (context) => const PopularCoursesScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeTopMentors:
        return MaterialPageRoute(
          builder: (context) => const TopMentorsScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeCoursesList:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => CoursesListScreen(
            initialSearchQuery: args?['searchQuery'],
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeMentorsList:
        return MaterialPageRoute(
          builder: (context) => const MentorsListScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeSingleMentorDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => SingleMentorDetailsScreen(
            mentor: args?['mentor'] ?? MentorItem(
              name: 'Default Mentor',
              specialization: 'Design',
              avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=M',
            ),
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeCourseDetail:
        // Handle both Map (from navigation) and String (from deep linking/web)
        CourseItem? course;
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          course = args['course'] as CourseItem?;
        } else if (settings.arguments is String) {
          // If slug is passed, create a CourseItem with just the id (slug)
          // The CourseDetailScreen will fetch full details from API using this id
          final slug = settings.arguments as String;
          course = CourseItem(
            id: slug,
            category: '',
            title: '',
            price: '0',
            rating: '0',
            students: '0',
            imageUrl: '',
          );
        }
        
        // If no valid course, redirect to home
        if (course == null) {
          return MaterialPageRoute(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(core_constants.AppConstants.routeHome);
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
            settings: settings,
          );
        }
        
        return MaterialPageRoute(
          builder: (context) => CourseDetailPage(course: course!),
          settings: settings,
        );
      case core_constants.AppConstants.routeLearning:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => LearningScreen(
            lessonId: args?['lessonId'] ?? '',
            categoryId: args?['categoryId'] ?? '',
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeQuiz:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => QuizScreen(
            exerciseId: args?['exerciseId'] ?? 0,
            userId: args?['userId'] ?? 0,
            exerciseTitle: args?['exerciseTitle'],
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeProfile:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeNotifications:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeChatMessages:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ChatMessagesScreen(
            chat: args?['chat'],
            lessonId: args?['lessonId'],
            lessonTitle: args?['lessonTitle'],
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeCurriculum:
        return MaterialPageRoute(
          builder: (context) => const CurriculumScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeReviews:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ReviewsScreen(
            courseId: args?['courseId'] ?? '',
            courseName: args?['courseName'],
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeWriteReview:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => WriteReviewScreen(
            courseId: args?['courseId'] ?? '',
            userId: args?['userId'] ?? '',
            courseName: args?['courseName'],
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routePayment:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => PaymentScreen(
            orderId: args?['orderId'] ?? '',
            qrCodeUrl: args?['qrCodeUrl'],
            description: args?['description'],
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeEnrollSuccess:
        return MaterialPageRoute(
          builder: (context) => const EnrollSuccessScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeMyCourses:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => sl<MyCoursesViewModel>(),
            child: const MyCoursesPage(),
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeMyCourseOngoingLessons:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => MyCourseOngoingLessonsScreen(
            courseId: args?['courseId'] ?? '',
            courseTitle: args?['courseTitle'] ?? 'Course Title',
            courseImage: args?['courseImage'] ?? '',
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeMyCourseOngoingVideo:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => MyCourseOngoingVideoScreen(
            lessonId: args?['lessonId'] ?? '',
            lessonTitle: args?['lessonTitle'] ?? 'Lesson Title',
            courseTitle: args?['courseTitle'] ?? 'Course Title',
            videoUrl: args?['videoUrl'] ?? '',
            currentTime: args?['currentTime'] ?? 0,
            totalTime: args?['totalTime'] ?? 0,
          ),
          settings: settings,
        );
      case core_constants.AppConstants.routeInviteFriends:
        return MaterialPageRoute(
          builder: (context) => const InviteFriendsScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeCart:
        return MaterialPageRoute(
          builder: (context) => const CartScreen(),
          settings: settings,
        );
      case core_constants.AppConstants.routeBlogDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => BlogDetailScreen(
            slugName: args?['slugName'] ?? '',
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const LoadingScreen(),
          settings: settings,
        );
    }
  }

  // Navigation helpers
  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, core_constants.AppConstants.routeHome);
  }

  static void navigateToPopularCourses(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routePopularCourses);
  }

  static void navigateToTopMentors(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routeTopMentors);
  }

  static void navigateToCoursesList(BuildContext context, {String? searchQuery}) {
    Navigator.pushNamed(
      context, 
      core_constants.AppConstants.routeCoursesList,
      arguments: searchQuery != null ? {'searchQuery': searchQuery} : null,
    );
  }

  static void navigateToMentorsList(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routeMentorsList);
  }

  static void navigateToSingleMentorDetails(BuildContext context, {required MentorItem mentor}) {
    Navigator.pushNamed(
      context,
      core_constants.AppConstants.routeSingleMentorDetails,
      arguments: {'mentor': mentor},
    );
  }

  static void navigateToCourseDetail(BuildContext context, {required CourseItem course}) {
    Navigator.pushNamed(
      context,
      core_constants.AppConstants.routeCourseDetail,
      arguments: {'course': course},
    );
  }


  static void navigateToLearning(
    BuildContext context, {
    required String lessonId,
    required String categoryId,
  }) {
    Navigator.pushNamed(
      context,
      core_constants.AppConstants.routeLearning,
      arguments: {
        'lessonId': lessonId,
        'categoryId': categoryId,
      },
    );
  }

  static void navigateToQuiz(
    BuildContext context, {
    required int exerciseId,
    required int userId,
    String? exerciseTitle,
  }) {
    Navigator.pushNamed(
      context,
      core_constants.AppConstants.routeQuiz,
      arguments: {
        'exerciseId': exerciseId,
        'userId': userId,
        'exerciseTitle': exerciseTitle,
      },
    );
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routeProfile);
  }


  static void navigateToNotifications(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routeNotifications);
  }

  static void navigateToChatMessages(BuildContext context, {required ChatItem chat}) {
    Navigator.pushNamed(
      context,
      core_constants.AppConstants.routeChatMessages,
      arguments: {'chat': chat},
    );
  }


  static void navigateToCurriculum(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routeCurriculum);
  }

  static void navigateToReviews(
    BuildContext context, {
    required String courseId,
    String? courseName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewsScreen(
          courseId: courseId,
          courseName: courseName,
        ),
      ),
    );
  }

  static void navigateToWriteReview(
    BuildContext context, {
    required String courseId,
    required String userId,
    String? courseName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteReviewScreen(
          courseId: courseId,
          userId: userId,
          courseName: courseName,
        ),
      ),
    );
  }

  static void navigateToPayment(
    BuildContext context, {
    required String orderId,
    String? qrCodeUrl,
    String? description,
  }) {
    Navigator.pushNamed(
      context,
      core_constants.AppConstants.routePayment,
      arguments: {
        'orderId': orderId,
        'qrCodeUrl': qrCodeUrl,
        'description': description,
      },
    );
  }

  static void navigateToEnrollSuccess(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routeEnrollSuccess);
  }

  static void navigateToMyCourses(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routeMyCourses);
  }




  static void navigateToMyCourseOngoingLessons(BuildContext context, {
    required String courseId,
    required String courseTitle,
    required String courseImage,
  }) {
    Navigator.pushNamed(
      context,
      core_constants.AppConstants.routeMyCourseOngoingLessons,
      arguments: {
        'courseId': courseId,
        'courseTitle': courseTitle,
        'courseImage': courseImage,
      },
    );
  }

  static void navigateToMyCourseOngoingVideo(BuildContext context, {
    required String lessonId,
    required String lessonTitle,
    required String courseTitle,
    required String videoUrl,
    int currentTime = 0,
    int totalTime = 0,
  }) {
    Navigator.pushNamed(
      context,
      core_constants.AppConstants.routeMyCourseOngoingVideo,
      arguments: {
        'lessonId': lessonId,
        'lessonTitle': lessonTitle,
        'courseTitle': courseTitle,
        'videoUrl': videoUrl,
        'currentTime': currentTime,
        'totalTime': totalTime,
      },
    );
  }




  static void navigateToInviteFriends(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routeInviteFriends);
  }

  static void navigateToCart(BuildContext context) {
    Navigator.pushNamed(context, core_constants.AppConstants.routeCart);
  }

  static void navigateToBlogDetail(BuildContext context, {required String slugName}) {
    Navigator.pushNamed(
      context,
      core_constants.AppConstants.routeBlogDetail,
      arguments: {'slugName': slugName},
    );
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void navigateAndClearStack(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }
}
