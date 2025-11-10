import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'core/utils/colors.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart' as di;
import 'core/utils/auth_helper.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/auth/presentation/viewmodels/register_viewmodel.dart';
import 'features/course/presentation/viewmodels/course_detail_viewmodel.dart';
import 'features/blog/presentation/viewmodels/blog_viewmodel.dart';
import 'features/profile/presentation/viewmodels/profile_viewmodel.dart';
// import 'legacy/providers/auth_provider.dart'; // Deprecated - use auth feature instead
import 'features/points/presentation/viewmodels/points_viewmodel.dart';
// import 'providers/ai_chat_provider.dart'; // Unused import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // New Clean Architecture ViewModels
        ChangeNotifierProvider(
          create: (context) => di.sl<AuthViewModel>()..initialize(),
        ),
        ChangeNotifierProvider(create: (context) => di.sl<RegisterViewModel>()),
        ChangeNotifierProvider(
          create: (context) => di.sl<CourseDetailViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => di.sl<BlogViewModel>()..initialize(),
        ),
        ChangeNotifierProvider(create: (context) => di.sl<ProfileViewModel>()),
        // Legacy providers (temporary for backward compatibility) - DEPRECATED
        // ChangeNotifierProvider(create: (context) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (context) => di.sl<PointsViewModel>()),
        // ChangeNotifierProxyProvider<AuthProvider, AIChatProvider>(
        //   create: (context) => AIChatProvider(Provider.of<AuthProvider>(context, listen: false)),
        //   update: (context, auth, previous) => previous ?? AIChatProvider(auth),
        // ),
      ],
      child: MaterialApp(
        navigatorKey: AuthHelper.navigatorKey,
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
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingL,
                vertical: AppConstants.spacingM,
              ),
            ),
          ),
        ),
        initialRoute: AppConstants.routeSplash,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
