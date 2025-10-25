import 'package:ftes/core/network/api_client.dart';
import 'package:ftes/core/di/injection_container.dart' as core;
import '../data/datasources/home_remote_datasource.dart';
import '../data/datasources/home_remote_datasource_impl.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_latest_courses_usecase.dart';
import '../domain/usecases/get_featured_courses_usecase.dart';
import '../domain/usecases/get_banners_usecase.dart';
import '../presentation/viewmodels/home_viewmodel.dart';

/// Initialize home feature dependencies
Future<void> initHomeDependencies() async {
  final sl = core.sl;

  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetLatestCoursesUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedCoursesUseCase(sl()));
  sl.registerLazySingleton(() => GetBannersUseCase(sl()));

  // ViewModels
  sl.registerFactory(() => HomeViewModel(
    getLatestCoursesUseCase: sl(),
    getFeaturedCoursesUseCase: sl(),
    getBannersUseCase: sl(),
  ));
}
