import 'package:ftes/core/network/api_client.dart';
import 'package:ftes/core/di/injection_container.dart' as core;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasources/home_remote_datasource.dart';
import '../data/datasources/home_remote_datasource_impl.dart';
import '../data/datasources/home_local_datasource.dart';
import '../data/datasources/home_local_datasource_impl.dart';
import '../data/cache/home_memory_cache.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_latest_courses_usecase.dart';
import '../domain/usecases/get_featured_courses_usecase.dart';
import '../domain/usecases/get_banners_usecase.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/search_courses_usecase.dart';
import '../presentation/viewmodels/home_viewmodel.dart';

/// Initialize home feature dependencies
Future<void> initHomeDependencies() async {
  final sl = core.sl;

  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl<HomeLocalDataSource>(),
      networkInfo: sl(),
      memoryCache: HomeMemoryCache(maxEntries: 50),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetLatestCoursesUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedCoursesUseCase(sl()));
  sl.registerLazySingleton(() => GetBannersUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => SearchCoursesUseCase(sl()));

  // ViewModels
  sl.registerFactory(() => HomeViewModel(
    getLatestCoursesUseCase: sl(),
    getFeaturedCoursesUseCase: sl(),
    getBannersUseCase: sl(),
    getCategoriesUseCase: sl(),
    searchCoursesUseCase: sl(),
  ));
}
