import 'package:get_it/get_it.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../data/datasources/blog_remote_datasource.dart';
import '../data/datasources/blog_remote_datasource_impl.dart';
import '../data/repositories/blog_repository_impl.dart';
import '../domain/repositories/blog_repository.dart';
import '../domain/usecases/get_all_blogs_usecase.dart';
import '../domain/usecases/get_blog_by_id_usecase.dart';
import '../domain/usecases/get_blog_by_slug_usecase.dart';
import '../domain/usecases/search_blogs_usecase.dart';
import '../domain/usecases/get_blog_categories_usecase.dart';
import '../presentation/viewmodels/blog_viewmodel.dart';

/// Dependency injection setup for Blog feature
class BlogInjection {
  static void init(GetIt sl) {
    // Data sources
    sl.registerLazySingleton<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );

    // Repositories
    sl.registerLazySingleton<BlogRepository>(
      () => BlogRepositoryImpl(
        remoteDataSource: sl<BlogRemoteDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton<GetAllBlogsUseCase>(
      () => GetAllBlogsUseCase(sl<BlogRepository>()),
    );
    
    sl.registerLazySingleton<GetBlogByIdUseCase>(
      () => GetBlogByIdUseCase(sl<BlogRepository>()),
    );
    
    sl.registerLazySingleton<GetBlogBySlugUseCase>(
      () => GetBlogBySlugUseCase(sl<BlogRepository>()),
    );
    
    sl.registerLazySingleton<SearchBlogsUseCase>(
      () => SearchBlogsUseCase(sl<BlogRepository>()),
    );
    
    sl.registerLazySingleton<GetBlogCategoriesUseCase>(
      () => GetBlogCategoriesUseCase(sl<BlogRepository>()),
    );

    // ViewModels
    sl.registerFactory<BlogViewModel>(
      () => BlogViewModel(
        getAllBlogsUseCase: sl<GetAllBlogsUseCase>(),
        getBlogBySlugUseCase: sl<GetBlogBySlugUseCase>(),
        searchBlogsUseCase: sl<SearchBlogsUseCase>(),
        getBlogCategoriesUseCase: sl<GetBlogCategoriesUseCase>(),
      ),
    );
  }
}
