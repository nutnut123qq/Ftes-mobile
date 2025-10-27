import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/order.dart' as order_entity;
import '../../domain/entities/order_summary.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

/// Repository implementation for Order feature
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, order_entity.Order>> createOrder({
    required List<String> courseIds,
    String? couponName,
    bool usePoint = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.createOrder(
          courseIds: courseIds,
          couponName: couponName,
          usePoint: usePoint,
        );
        return Right(model.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderSummary>> getOrderById(String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getOrderById(orderId);
        return Right(model.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderSummary>>> getAllOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getAllOrders();
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelPendingOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final success = await remoteDataSource.cancelPendingOrders();
        return Right(success);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
