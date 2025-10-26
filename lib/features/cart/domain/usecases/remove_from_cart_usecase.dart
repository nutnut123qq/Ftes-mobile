import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Use case for removing item from cart
class RemoveFromCartUseCase implements UseCase<bool, RemoveFromCartParams> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(params.cartItemId);
  }
}

/// Parameters for RemoveFromCartUseCase
class RemoveFromCartParams extends Equatable {
  final String cartItemId;

  const RemoveFromCartParams({
    required this.cartItemId,
  });

  @override
  List<Object> get props => [cartItemId];
}
