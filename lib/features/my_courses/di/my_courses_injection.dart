import 'package:get_it/get_it.dart';
import '../domain/usecases/get_user_courses_usecase.dart';
import '../domain/repositories/my_courses_repository.dart';
import '../data/datasources/my_courses_remote_datasource.dart';
import '../data/datasources/my_courses_remote_datasource_impl.dart';
import '../data/repositories/my_courses_repository_impl.dart';
import '../presentation/viewmodels/my_courses_viewmodel.dart';

final sl = GetIt.instance;

/// Initialize My Courses feature dependencies
Future<void> initMyCourses() async {
  // DataSource
  sl.registerLazySingleton<MyCoursesRemoteDataSource>(
    () => MyCoursesRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<MyCoursesRepository>(
    () => MyCoursesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(() => GetUserCoursesUseCase(sl()));

  // ViewModel
  sl.registerFactory(() => MyCoursesViewModel(getUserCoursesUseCase: sl()));
}
