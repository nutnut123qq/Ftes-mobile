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

  // AI API Client
  // Reuse base Dio configuration from DI (headers/timeouts) instead of raw new Dio(),
  // but keep a dedicated instance to avoid changing baseUrl/options used by ApiClient.
  sl.registerLazySingleton<AiApiClient>(() {
    final baseDio = sl<Dio>();
    final aiDio = Dio();
    // Copy common headers if any (avoid mutating shared instance)
    aiDio.options.headers.addAll(Map<String, dynamic>.from(baseDio.options.headers));
    // Interceptors will be set up by AiApiClient itself
    return AiApiClient(dio: aiDio);
  });

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
