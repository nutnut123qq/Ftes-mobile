import 'package:flutter/material.dart';
import '../screens/loading_screen.dart';
import '../screens/launching_screen.dart';
import '../screens/intro_screen.dart';
import '../screens/lets_you_in_screen.dart';
import '../screens/register_screen.dart';
import '../screens/login_screen.dart';
import '../presentation/pages/auth/login_page.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/verify_forgot_password_screen.dart';
import '../screens/create_new_password_screen.dart';
import '../screens/congratulations_screen.dart';
import '../screens/create_pin_screen.dart';
import '../screens/home_screen.dart';
import '../screens/popular_courses_screen.dart';
import '../screens/top_mentors_screen.dart';
import '../screens/courses_list_screen.dart';
import '../screens/mentors_list_screen.dart';
import '../screens/single_mentor_details_screen.dart';
import '../screens/course_detail_screen.dart';
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
import '../screens/my_courses_screen.dart';
import '../screens/my_course_ongoing_lessons_screen.dart';
import '../screens/my_course_ongoing_video_screen.dart';
import '../screens/invite_friends_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/blog_detail_screen.dart';
import '../models/course_item.dart';
import '../models/chat_item.dart';
import '../models/mentor_item.dart';
import '../utils/constants.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    AppConstants.routeSplash: (context) => const LoadingScreen(),
    AppConstants.routeLaunching: (context) => const LaunchingScreen(),
    AppConstants.routeIntro: (context) => const IntroScreen(),
    AppConstants.routeLetsYouIn: (context) => const LetsYouInScreen(),
    AppConstants.routeSignUp: (context) => const RegisterScreen(),
    AppConstants.routeSignIn: (context) => const LoginPage(),
    AppConstants.routeForgotPassword: (context) => const ForgotPasswordScreen(),
    AppConstants.routeVerifyForgotPassword: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return VerifyForgotPasswordScreen(
        contactInfo: args?['contactInfo'] ?? '',
        method: args?['method'] ?? 'email',
      );
    },
    AppConstants.routeCreateNewPassword: (context) => const CreateNewPasswordScreen(),
    AppConstants.routeCongratulations: (context) => const CongratulationsScreen(),
    AppConstants.routeCreatePin: (context) => const CreatePinScreen(),
    AppConstants.routeHome: (context) => const HomeScreen(),
    AppConstants.routePopularCourses: (context) => const PopularCoursesScreen(),
    AppConstants.routeTopMentors: (context) => const TopMentorsScreen(),
    AppConstants.routeCoursesList: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return CoursesListScreen(
        initialSearchQuery: args?['searchQuery'],
      );
    },
    AppConstants.routeMentorsList: (context) => const MentorsListScreen(),
    AppConstants.routeSingleMentorDetails: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return SingleMentorDetailsScreen(
        mentor: args?['mentor'] ?? MentorItem(
          name: 'Default Mentor',
          specialization: 'Design',
          avatarUrl: 'https://via.placeholder.com/66x66/000000/FFFFFF?text=M',
        ),
      );
    },
    AppConstants.routeCourseDetail: (context) {
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
          Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      
      return CourseDetailScreen(course: course);
    },
    AppConstants.routeProfile: (context) => const ProfileScreen(),
    AppConstants.routeNotifications: (context) => const NotificationsScreen(),
    AppConstants.routeChatMessages: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return ChatMessagesScreen(
        chat: args?['chat'],
        lessonId: args?['lessonId'],
        lessonTitle: args?['lessonTitle'],
      );
    },
    AppConstants.routeCurriculum: (context) => const CurriculumScreen(),
    AppConstants.routeReviews: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return ReviewsScreen(
        courseId: args?['courseId'] ?? '',
        courseName: args?['courseName'],
      );
    },
    AppConstants.routeWriteReview: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return WriteReviewScreen(
        courseId: args?['courseId'] ?? '',
        userId: args?['userId'] ?? '',
        courseName: args?['courseName'],
      );
    },
    AppConstants.routePayment: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return PaymentScreen(
        orderId: args?['orderId'] ?? '',
        qrCodeUrl: args?['qrCodeUrl'],
        description: args?['description'],
      );
    },
    AppConstants.routeEnrollSuccess: (context) => const EnrollSuccessScreen(),
    AppConstants.routeMyCourses: (context) => const MyCoursesScreen(),
    AppConstants.routeMyCourseOngoingLessons: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return MyCourseOngoingLessonsScreen(
        courseId: args?['courseId'] ?? '',
        courseTitle: args?['courseTitle'] ?? 'Course Title',
        courseImage: args?['courseImage'] ?? '',
      );
    },
    AppConstants.routeMyCourseOngoingVideo: (context) {
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
    AppConstants.routeInviteFriends: (context) => const InviteFriendsScreen(),
    AppConstants.routeCart: (context) => const CartScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.routeSplash:
        return MaterialPageRoute(
          builder: (context) => const LoadingScreen(),
          settings: settings,
        );
      case AppConstants.routeLaunching:
        return MaterialPageRoute(
          builder: (context) => const LaunchingScreen(),
          settings: settings,
        );
      case AppConstants.routeIntro:
        return MaterialPageRoute(
          builder: (context) => const IntroScreen(),
          settings: settings,
        );
      case AppConstants.routeLetsYouIn:
        return MaterialPageRoute(
          builder: (context) => const LetsYouInScreen(),
          settings: settings,
        );
      case AppConstants.routeSignUp:
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
          settings: settings,
        );
      case AppConstants.routeSignIn:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
          settings: settings,
        );
      case AppConstants.routeForgotPassword:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
          settings: settings,
        );
      case AppConstants.routeVerifyForgotPassword:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => VerifyForgotPasswordScreen(
            contactInfo: args?['contactInfo'] ?? '',
            method: args?['method'] ?? 'email',
          ),
          settings: settings,
        );
      case AppConstants.routeCreateNewPassword:
        return MaterialPageRoute(
          builder: (context) => const CreateNewPasswordScreen(),
          settings: settings,
        );
      case AppConstants.routeCongratulations:
        return MaterialPageRoute(
          builder: (context) => const CongratulationsScreen(),
          settings: settings,
        );
      case AppConstants.routeCreatePin:
        return MaterialPageRoute(
          builder: (context) => const CreatePinScreen(),
          settings: settings,
        );
      case AppConstants.routeHome:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
          settings: settings,
        );
      case AppConstants.routePopularCourses:
        return MaterialPageRoute(
          builder: (context) => const PopularCoursesScreen(),
          settings: settings,
        );
      case AppConstants.routeTopMentors:
        return MaterialPageRoute(
          builder: (context) => const TopMentorsScreen(),
          settings: settings,
        );
      case AppConstants.routeCoursesList:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => CoursesListScreen(
            initialSearchQuery: args?['searchQuery'],
          ),
          settings: settings,
        );
      case AppConstants.routeMentorsList:
        return MaterialPageRoute(
          builder: (context) => const MentorsListScreen(),
          settings: settings,
        );
      case AppConstants.routeSingleMentorDetails:
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
      case AppConstants.routeCourseDetail:
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
                Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
            settings: settings,
          );
        }
        
        return MaterialPageRoute(
          builder: (context) => CourseDetailScreen(course: course!),
          settings: settings,
        );
      case AppConstants.routeLearning:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => LearningScreen(
            lessonId: args?['lessonId'] ?? '',
            categoryId: args?['categoryId'] ?? '',
          ),
          settings: settings,
        );
      case AppConstants.routeQuiz:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => QuizScreen(
            exerciseId: args?['exerciseId'] ?? 0,
            userId: args?['userId'] ?? 0,
            exerciseTitle: args?['exerciseTitle'],
          ),
          settings: settings,
        );
      case AppConstants.routeProfile:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
          settings: settings,
        );
      case AppConstants.routeNotifications:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
          settings: settings,
        );
      case AppConstants.routeChatMessages:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ChatMessagesScreen(
            chat: args?['chat'],
            lessonId: args?['lessonId'],
            lessonTitle: args?['lessonTitle'],
          ),
          settings: settings,
        );
      case AppConstants.routeCurriculum:
        return MaterialPageRoute(
          builder: (context) => const CurriculumScreen(),
          settings: settings,
        );
      case AppConstants.routeReviews:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ReviewsScreen(
            courseId: args?['courseId'] ?? '',
            courseName: args?['courseName'],
          ),
          settings: settings,
        );
      case AppConstants.routeWriteReview:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => WriteReviewScreen(
            courseId: args?['courseId'] ?? '',
            userId: args?['userId'] ?? '',
            courseName: args?['courseName'],
          ),
          settings: settings,
        );
      case AppConstants.routePayment:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => PaymentScreen(
            orderId: args?['orderId'] ?? '',
            qrCodeUrl: args?['qrCodeUrl'],
            description: args?['description'],
          ),
          settings: settings,
        );
      case AppConstants.routeEnrollSuccess:
        return MaterialPageRoute(
          builder: (context) => const EnrollSuccessScreen(),
          settings: settings,
        );
      case AppConstants.routeMyCourses:
        return MaterialPageRoute(
          builder: (context) => const MyCoursesScreen(),
          settings: settings,
        );
      case AppConstants.routeMyCourseOngoingLessons:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => MyCourseOngoingLessonsScreen(
            courseId: args?['courseId'] ?? '',
            courseTitle: args?['courseTitle'] ?? 'Course Title',
            courseImage: args?['courseImage'] ?? '',
          ),
          settings: settings,
        );
      case AppConstants.routeMyCourseOngoingVideo:
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
      case AppConstants.routeInviteFriends:
        return MaterialPageRoute(
          builder: (context) => const InviteFriendsScreen(),
          settings: settings,
        );
      case AppConstants.routeCart:
        return MaterialPageRoute(
          builder: (context) => const CartScreen(),
          settings: settings,
        );
      case AppConstants.routeBlogDetail:
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
    Navigator.pushReplacementNamed(context, AppConstants.routeHome);
  }

  static void navigateToPopularCourses(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routePopularCourses);
  }

  static void navigateToTopMentors(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routeTopMentors);
  }

  static void navigateToCoursesList(BuildContext context, {String? searchQuery}) {
    Navigator.pushNamed(
      context, 
      AppConstants.routeCoursesList,
      arguments: searchQuery != null ? {'searchQuery': searchQuery} : null,
    );
  }

  static void navigateToMentorsList(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routeMentorsList);
  }

  static void navigateToSingleMentorDetails(BuildContext context, {required MentorItem mentor}) {
    Navigator.pushNamed(
      context,
      AppConstants.routeSingleMentorDetails,
      arguments: {'mentor': mentor},
    );
  }

  static void navigateToCourseDetail(BuildContext context, {required CourseItem course}) {
    Navigator.pushNamed(
      context,
      AppConstants.routeCourseDetail,
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
      AppConstants.routeLearning,
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
      AppConstants.routeQuiz,
      arguments: {
        'exerciseId': exerciseId,
        'userId': userId,
        'exerciseTitle': exerciseTitle,
      },
    );
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routeProfile);
  }


  static void navigateToNotifications(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routeNotifications);
  }

  static void navigateToChatMessages(BuildContext context, {required ChatItem chat}) {
    Navigator.pushNamed(
      context,
      AppConstants.routeChatMessages,
      arguments: {'chat': chat},
    );
  }


  static void navigateToCurriculum(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routeCurriculum);
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
      AppConstants.routePayment,
      arguments: {
        'orderId': orderId,
        'qrCodeUrl': qrCodeUrl,
        'description': description,
      },
    );
  }

  static void navigateToEnrollSuccess(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routeEnrollSuccess);
  }

  static void navigateToMyCourses(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routeMyCourses);
  }




  static void navigateToMyCourseOngoingLessons(BuildContext context, {
    required String courseId,
    required String courseTitle,
    required String courseImage,
  }) {
    Navigator.pushNamed(
      context,
      AppConstants.routeMyCourseOngoingLessons,
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
      AppConstants.routeMyCourseOngoingVideo,
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
    Navigator.pushNamed(context, AppConstants.routeInviteFriends);
  }

  static void navigateToCart(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.routeCart);
  }

  static void navigateToBlogDetail(BuildContext context, {required String slugName}) {
    Navigator.pushNamed(
      context,
      AppConstants.routeBlogDetail,
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
