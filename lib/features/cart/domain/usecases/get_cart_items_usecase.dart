import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_summary.dart';
import '../repositories/cart_repository.dart';

/// Use case for getting cart items with pagination
class GetCartItemsUseCase implements UseCase<CartSummary, GetCartItemsParams> {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  @override
  Future<Either<Failure, CartSummary>> call(GetCartItemsParams params) async {
    return await repository.getCartItems(
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
      sortField: params.sortField,
      sortOrder: params.sortOrder,
    );
  }
}

/// Parameters for GetCartItemsUseCase
class GetCartItemsParams extends Equatable {
  final int pageNumber;
  final int pageSize;
  final String? sortField;
  final String sortOrder;

  const GetCartItemsParams({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.sortField,
    this.sortOrder = 'ASC',
  });

  @override
  List<Object?> get props => [pageNumber, pageSize, sortField, sortOrder];
}
