import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../domain/repositories/profile_repository.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../data/datasources/profile_remote_datasource.dart';
import '../data/datasources/profile_remote_datasource_impl.dart';
import '../data/datasources/profile_local_datasource.dart';
import '../data/datasources/profile_local_datasource_impl.dart';
import '../domain/usecases/profile_usecases.dart';
import '../domain/usecases/get_instructor_profile_usecase.dart';
import '../domain/usecases/get_instructor_courses_usecase.dart';
import '../presentation/viewmodels/profile_viewmodel.dart';
import '../presentation/viewmodels/instructor_profile_viewmodel.dart';

/// Dependency injection setup for Profile feature
class ProfileInjection {
  static void init(GetIt sl) {
    // Data sources
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );
    
    sl.registerLazySingleton<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
    );

    // Repositories
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteDataSource: sl<ProfileRemoteDataSource>(),
        localDataSource: sl<ProfileLocalDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton<GetProfileByIdUseCase>(
      () => GetProfileByIdUseCase(sl<ProfileRepository>()),
    );
    
    sl.registerLazySingleton<GetProfileByUsernameUseCase>(
      () => GetProfileByUsernameUseCase(sl<ProfileRepository>()),
    );
    
    sl.registerLazySingleton<GetInstructorProfileByUsernameUseCase>(
      () => GetInstructorProfileByUsernameUseCase(sl<ProfileRepository>()),
    );
    
    sl.registerLazySingleton<GetInstructorCoursesUseCase>(
      () => GetInstructorCoursesUseCase(sl<ProfileRepository>()),
    );
    
    sl.registerLazySingleton<CreateProfileUseCase>(
      () => CreateProfileUseCase(sl<ProfileRepository>()),
    );
    
    sl.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(sl<ProfileRepository>()),
    );
    
    sl.registerLazySingleton<CreateProfileAutoUseCase>(
      () => CreateProfileAutoUseCase(sl<ProfileRepository>()),
    );
    
    sl.registerLazySingleton<GetParticipantsCountUseCase>(
      () => GetParticipantsCountUseCase(sl<ProfileRepository>()),
    );
    
    sl.registerLazySingleton<CheckApplyCourseUseCase>(
      () => CheckApplyCourseUseCase(sl<ProfileRepository>()),
    );
    
    sl.registerLazySingleton<UploadImageUseCase>(
      () => UploadImageUseCase(sl<ProfileRepository>()),
    );

    // ViewModels
    sl.registerFactory<ProfileViewModel>(
      () => ProfileViewModel(
        getProfileByIdUseCase: sl<GetProfileByIdUseCase>(),
        getProfileByUsernameUseCase: sl<GetProfileByUsernameUseCase>(),
        createProfileUseCase: sl<CreateProfileUseCase>(),
        updateProfileUseCase: sl<UpdateProfileUseCase>(),
        createProfileAutoUseCase: sl<CreateProfileAutoUseCase>(),
        getParticipantsCountUseCase: sl<GetParticipantsCountUseCase>(),
        checkApplyCourseUseCase: sl<CheckApplyCourseUseCase>(),
        uploadImageUseCase: sl<UploadImageUseCase>(),
        localDataSource: sl<ProfileLocalDataSource>(),
        sharedPreferences: sl<SharedPreferences>(),
      ),
    );
    
    sl.registerFactory<InstructorProfileViewModel>(
      () => InstructorProfileViewModel(
        getInstructorProfileUseCase: sl<GetInstructorProfileByUsernameUseCase>(),
        getInstructorCoursesUseCase: sl<GetInstructorCoursesUseCase>(),
        getParticipantsCountUseCase: sl<GetParticipantsCountUseCase>(),
      ),
    );
  }
}
