import 'package:ftes/core/di/injection_container.dart' as core;
import 'package:ftes/core/network/api_client.dart';
import '../data/datasources/feedback_remote_datasource.dart';
import '../data/datasources/feedback_remote_datasource_impl.dart';
import '../data/repositories/feedback_repository_impl.dart';
import '../domain/repositories/feedback_repository.dart';
import '../domain/usecases/feedback_usecases.dart';
import '../presentation/viewmodels/feedback_viewmodel.dart';

Future<void> initFeedbackDependencies() async {
  final sl = core.sl;

  // Datasource
  sl.registerLazySingleton<FeedbackRemoteDataSource>(
    () => FeedbackRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<FeedbackRepository>(
    () => FeedbackRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetCourseFeedbacksUseCase(sl()));
  sl.registerLazySingleton(() => CreateFeedbackUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFeedbackUseCase(sl()));
  sl.registerLazySingleton(() => DeleteFeedbackUseCase(sl()));
  sl.registerLazySingleton(() => GetAverageRatingUseCase(sl()));

  // ViewModel
  sl.registerFactory(
    () => FeedbackViewModel(
      getCourseFeedbacksUseCase: sl(),
      createFeedbackUseCase: sl(),
      updateFeedbackUseCase: sl(),
      deleteFeedbackUseCase: sl(),
      getAverageRatingUseCase: sl(),
    ),
  );
}
