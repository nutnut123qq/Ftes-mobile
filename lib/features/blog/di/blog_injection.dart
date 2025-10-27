import 'package:ftes/core/network/api_client.dart';
import 'package:ftes/core/di/injection_container.dart' as core;
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

/// Initialize blog feature dependencies
Future<void> initBlogDependencies() async {
  final sl = core.sl;

  // Data sources
  sl.registerLazySingleton<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<BlogRepository>(
    () => BlogRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllBlogsUseCase(sl()));
  sl.registerLazySingleton(() => GetBlogByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetBlogBySlugUseCase(sl()));
  sl.registerLazySingleton(() => SearchBlogsUseCase(sl()));
  sl.registerLazySingleton(() => GetBlogCategoriesUseCase(sl()));

  // ViewModels
  sl.registerFactory(() => BlogViewModel(
    getAllBlogsUseCase: sl(),
    getBlogBySlugUseCase: sl(),
    searchBlogsUseCase: sl(),
    getBlogCategoriesUseCase: sl(),
  ));
}
