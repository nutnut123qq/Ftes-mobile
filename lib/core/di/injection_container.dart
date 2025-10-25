import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../features/auth/di/auth_injection.dart';
import '../../features/home/di/home_injection.dart';

/// Service Locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  
  // Core dependencies
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => ApiClient(dio: sl(), sharedPreferences: sl()));
  
  // Feature dependencies
  await initAuthDependencies();
  await initHomeDependencies();
}
