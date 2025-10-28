import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/network/ai_api_client.dart';
import '../data/datasources/roadmap_remote_datasource.dart';
import '../data/datasources/roadmap_remote_datasource_impl.dart';
import '../data/repositories/roadmap_repository_impl.dart';
import '../domain/repositories/roadmap_repository.dart';
import '../domain/usecases/generate_roadmap_usecase.dart';
import '../presentation/viewmodels/roadmap_viewmodel.dart';

/// Initialize roadmap feature dependencies
Future<void> initRoadmapDependencies() async {
  final sl = GetIt.instance;

  // AI API Client (separate Dio instance for AI service)
  sl.registerLazySingleton<AiApiClient>(
    () => AiApiClient(dio: Dio()),
  );

  // Data sources
  sl.registerLazySingleton<RoadmapRemoteDataSource>(
    () => RoadmapRemoteDataSourceImpl(aiApiClient: sl<AiApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<RoadmapRepository>(
    () => RoadmapRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GenerateRoadmapUseCase(sl()));

  // ViewModels
  sl.registerFactory(() => RoadmapViewModel(
    generateRoadmapUseCase: sl(),
  ));
  
  // RoadmapResultViewModel is created with roadmap data, not registered as singleton
}
