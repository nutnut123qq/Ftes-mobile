import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_summary.dart';
import '../repositories/cart_repository.dart';

/// Use case for adding course to cart
class AddToCartUseCase implements UseCase<bool, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(AddToCartParams params) async {
    return await repository.addToCart(params.courseId);
  }
}

/// Parameters for AddToCartUseCase
class AddToCartParams extends Equatable {
  final String courseId;

  const AddToCartParams({
    required this.courseId,
  });

  @override
  List<Object> get props => [courseId];
}
