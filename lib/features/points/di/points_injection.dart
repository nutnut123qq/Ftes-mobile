import 'package:ftes/core/di/injection_container.dart' as core;
import 'package:get_it/get_it.dart';
import 'package:ftes/core/network/api_client.dart';
import '../data/datasources/points_remote_datasource.dart';
import '../data/datasources/points_remote_datasource_impl.dart';
import '../data/repositories/points_repository_impl.dart';
import '../domain/repositories/points_repository.dart';
import '../domain/usecases/points_usecases.dart';
import '../presentation/viewmodels/points_viewmodel.dart';

class PointsInjection {
  static void init(GetIt sl) {
    // Datasource
    sl.registerLazySingleton<PointsRemoteDataSource>(
      () => PointsRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );

    // Repository
    sl.registerLazySingleton<PointsRepository>(
      () => PointsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );

    // Usecases
    sl.registerLazySingleton(() => GetPointsSummaryUseCase(sl()));
    sl.registerLazySingleton(() => GetPointTransactionsUseCase(sl()));
    sl.registerLazySingleton(() => GetReferralInfoUseCase(sl()));
    sl.registerLazySingleton(() => GetReferralStatsUseCase(sl()));
    sl.registerLazySingleton(() => GetInvitedUsersUseCase(sl()));
    sl.registerLazySingleton(() => GetPointsChartUseCase(sl()));
    sl.registerLazySingleton(() => WithdrawPointsUseCase(sl()));
    sl.registerLazySingleton(() => SetReferralUseCase(sl()));

    // ViewModel
    sl.registerFactory(
      () => PointsViewModel(
        getPointsSummaryUseCase: sl(),
        getReferralInfoUseCase: sl(),
        getReferralStatsUseCase: sl(),
        getInvitedUsersUseCase: sl(),
        getPointTransactionsUseCase: sl(),
        getPointsChartUseCase: sl(),
        withdrawPointsUseCase: sl(),
        setReferralUseCase: sl(),
      ),
    );
  }
}
