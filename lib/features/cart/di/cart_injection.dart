import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../data/datasources/cart_remote_datasource.dart';
import '../data/datasources/cart_remote_datasource_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/usecases/add_to_cart_usecase.dart';
import '../domain/usecases/get_cart_items_usecase.dart';
import '../domain/usecases/get_cart_count_usecase.dart';
import '../domain/usecases/remove_from_cart_usecase.dart';
import '../presentation/viewmodels/cart_viewmodel.dart';

/// Dependency injection setup for Cart feature
class CartInjection {
  static void init(GetIt sl) {
    // Data sources
    sl.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );

    // Repositories
    sl.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(
        remoteDataSource: sl<CartRemoteDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton<AddToCartUseCase>(
      () => AddToCartUseCase(sl<CartRepository>()),
    );
    
    sl.registerLazySingleton<GetCartItemsUseCase>(
      () => GetCartItemsUseCase(sl<CartRepository>()),
    );
    
    sl.registerLazySingleton<GetCartCountUseCase>(
      () => GetCartCountUseCase(sl<CartRepository>()),
    );
    
    sl.registerLazySingleton<RemoveFromCartUseCase>(
      () => RemoveFromCartUseCase(sl<CartRepository>()),
    );

    // ViewModels
    sl.registerFactory<CartViewModel>(
      () => CartViewModel(
        addToCartUseCase: sl<AddToCartUseCase>(),
        getCartItemsUseCase: sl<GetCartItemsUseCase>(),
        getCartCountUseCase: sl<GetCartCountUseCase>(),
        removeFromCartUseCase: sl<RemoveFromCartUseCase>(),
        sharedPreferences: sl<SharedPreferences>(),
      ),
    );
  }
}
