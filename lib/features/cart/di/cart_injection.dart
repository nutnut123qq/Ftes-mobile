import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../data/datasources/cart_remote_datasource.dart';
import '../data/datasources/cart_remote_datasource_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../data/datasources/order_remote_datasource.dart';
import '../data/datasources/order_remote_datasource_impl.dart';
import '../data/repositories/order_repository_impl.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/usecases/add_to_cart_usecase.dart';
import '../domain/usecases/get_cart_items_usecase.dart';
import '../domain/usecases/get_cart_count_usecase.dart';
import '../domain/usecases/remove_from_cart_usecase.dart';
import '../domain/usecases/create_order_usecase.dart';
import '../domain/usecases/get_order_by_id_usecase.dart';
import '../domain/usecases/get_all_orders_usecase.dart';
import '../domain/usecases/cancel_pending_orders_usecase.dart';
import '../presentation/viewmodels/cart_viewmodel.dart';
import '../presentation/viewmodels/payment_viewmodel.dart';

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

    // Order data sources
    sl.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );

    // Order repositories
    sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(
        remoteDataSource: sl<OrderRemoteDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // Order use cases
    sl.registerLazySingleton<CreateOrderUseCase>(
      () => CreateOrderUseCase(sl<OrderRepository>()),
    );

    sl.registerLazySingleton<GetOrderByIdUseCase>(
      () => GetOrderByIdUseCase(sl<OrderRepository>()),
    );

    sl.registerLazySingleton<GetAllOrdersUseCase>(
      () => GetAllOrdersUseCase(sl<OrderRepository>()),
    );

    sl.registerLazySingleton<CancelPendingOrdersUseCase>(
      () => CancelPendingOrdersUseCase(sl<OrderRepository>()),
    );

    // ViewModels
    sl.registerFactory<CartViewModel>(
      () => CartViewModel(
        addToCartUseCase: sl<AddToCartUseCase>(),
        getCartItemsUseCase: sl<GetCartItemsUseCase>(),
        getCartCountUseCase: sl<GetCartCountUseCase>(),
        removeFromCartUseCase: sl<RemoveFromCartUseCase>(),
        createOrderUseCase: sl<CreateOrderUseCase>(),
        cancelPendingOrdersUseCase: sl<CancelPendingOrdersUseCase>(),
        sharedPreferences: sl<SharedPreferences>(),
      ),
    );

    sl.registerFactory<PaymentViewModel>(
      () => PaymentViewModel(
        getOrderByIdUseCase: sl<GetOrderByIdUseCase>(),
        sharedPreferences: sl<SharedPreferences>(),
      ),
    );
  }
}
