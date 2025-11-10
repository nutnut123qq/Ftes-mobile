import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../data/datasources/ai_chat_remote_datasource.dart';
import '../data/datasources/ai_chat_remote_datasource_impl.dart';
import '../data/datasources/ai_chat_local_datasource.dart';
import '../data/datasources/ai_chat_local_datasource_impl.dart';
import '../data/repositories/ai_chat_repository_impl.dart';
import '../domain/repositories/ai_chat_repository.dart';
import '../domain/usecases/send_ai_message_usecase.dart';
import '../domain/usecases/check_video_knowledge_usecase.dart';
import '../presentation/viewmodels/ai_chat_viewmodel.dart';

/// Dependency injection setup for AI Chat feature
class AiInjection {
  static void init(GetIt sl) {
    // Data sources
    sl.registerLazySingleton<AiChatRemoteDataSource>(
      () => AiChatRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );

    // Local data source
    sl.registerLazySingleton<AiChatLocalDataSource>(
      () => AiChatLocalDataSourceImpl(
        sharedPreferences: sl<SharedPreferences>(),
      ),
    );

    // Repositories
    sl.registerLazySingleton<AiChatRepository>(
      () => AiChatRepositoryImpl(
        remoteDataSource: sl<AiChatRemoteDataSource>(),
        localDataSource: sl<AiChatLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton<SendAiMessageUseCase>(
      () => SendAiMessageUseCase(sl<AiChatRepository>()),
    );

    sl.registerLazySingleton<CheckVideoKnowledgeUseCase>(
      () => CheckVideoKnowledgeUseCase(sl<AiChatRepository>()),
    );

    // ViewModels (factory để tạo mới mỗi lần)
    sl.registerFactory<AiChatViewModel>(
      () {
        // Get user ID from SharedPreferences
        final sharedPreferences = sl<SharedPreferences>();
        final userId = sharedPreferences.getString('user_id') ?? '';
        
        return AiChatViewModel(
          sendAiMessageUseCase: sl<SendAiMessageUseCase>(),
          localDataSource: sl<AiChatLocalDataSource>(),
          userId: userId,
        );
      },
    );
  }
}

