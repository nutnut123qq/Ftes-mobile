import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'utils/colors.dart';
import 'utils/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/app_data_provider.dart';
import 'providers/blog_provider.dart';
import 'providers/course_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/point_provider.dart';
import 'providers/enrollment_provider.dart';
import 'providers/feedback_provider.dart';
import 'providers/exercise_provider.dart';
import 'providers/video_provider.dart';
import 'providers/ai_chat_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (context) => AppDataProvider()),
        ChangeNotifierProvider(create: (context) => BlogProvider()..initialize()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()..initializeCart()),
        ChangeNotifierProvider(create: (context) => PointProvider()),
        ChangeNotifierProvider(create: (context) => EnrollmentProvider()),
        ChangeNotifierProvider(create: (context) => FeedbackProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseProvider()),
        ChangeNotifierProvider(create: (context) => VideoProvider()),
        ChangeNotifierProxyProvider<AuthProvider, AIChatProvider>(
          create: (context) => AIChatProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, auth, previous) => previous ?? AIChatProvider(auth),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingL,
                vertical: AppConstants.spacingM,
              ),
            ),
          ),
        ),
        initialRoute: AppConstants.routeIntro,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
