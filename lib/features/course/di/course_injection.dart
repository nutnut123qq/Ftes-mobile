import 'package:get_it/get_it.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../data/datasources/course_remote_datasource.dart';
import '../data/datasources/course_remote_datasource_impl.dart';
import '../data/datasources/course_local_datasource.dart';
import '../data/datasources/course_local_datasource_impl.dart';
import '../data/repositories/course_repository_impl.dart';
import 'package:ftes/features/course/domain/repositories/course_repository.dart';
import 'package:ftes/features/course/domain/usecases/get_course_detail_usecase.dart';
import 'package:ftes/features/course/domain/usecases/get_profile_usecase.dart';
import 'package:ftes/features/course/domain/usecases/check_enrollment_usecase.dart';
import 'package:ftes/features/course/domain/usecases/enroll_course_usecase.dart';
import 'package:ftes/features/course/domain/usecases/get_video_playlist_usecase.dart';
import 'package:ftes/features/course/domain/usecases/get_video_status_usecase.dart';
import '../presentation/viewmodels/course_detail_viewmodel.dart';
import '../presentation/viewmodels/course_video_viewmodel.dart';

/// Dependency injection setup for Course feature
class CourseInjection {
  static void init(GetIt sl) {
    // Data sources
    sl.registerLazySingleton<CourseRemoteDataSource>(
      () => CourseRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );
    sl.registerLazySingleton<CourseLocalDataSource>(
      () => CourseLocalDataSourceImpl(sharedPreferences: sl()),
    );

    // Repositories
    sl.registerLazySingleton<CourseRepository>(
      () => CourseRepositoryImpl(
        remoteDataSource: sl<CourseRemoteDataSource>(),
        localDataSource: sl<CourseLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton<GetCourseDetailUseCase>(
      () => GetCourseDetailUseCase(sl<CourseRepository>()),
    );
    
    sl.registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(sl<CourseRepository>()),
    );
    
    sl.registerLazySingleton<CheckEnrollmentUseCase>(
      () => CheckEnrollmentUseCase(sl<CourseRepository>()),
    );

    sl.registerLazySingleton<EnrollCourseUseCase>(
      () => EnrollCourseUseCase(sl<CourseRepository>()),
    );

    // Video use cases
    sl.registerLazySingleton<GetVideoPlaylistUseCase>(
      () => GetVideoPlaylistUseCase(sl<CourseRepository>()),
    );

    sl.registerLazySingleton<GetVideoStatusUseCase>(
      () => GetVideoStatusUseCase(sl<CourseRepository>()),
    );

    // ViewModels
    sl.registerFactory<CourseDetailViewModel>(
      () => CourseDetailViewModel(
        getCourseDetailUseCase: sl<GetCourseDetailUseCase>(),
        getProfileUseCase: sl<GetProfileUseCase>(),
        checkEnrollmentUseCase: sl<CheckEnrollmentUseCase>(),
        getVideoPlaylistUseCase: sl<GetVideoPlaylistUseCase>(),
      ),
    );

    sl.registerFactory<CourseVideoViewModel>(
      () => CourseVideoViewModel(
        checkEnrollmentUseCase: sl<CheckEnrollmentUseCase>(),
        getVideoPlaylistUseCase: sl<GetVideoPlaylistUseCase>(),
        getVideoStatusUseCase: sl<GetVideoStatusUseCase>(),
      ),
    );
  }
}
