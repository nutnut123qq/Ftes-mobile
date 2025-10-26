import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Use case for getting cart count
class GetCartCountUseCase implements UseCase<int, NoParams> {
  final CartRepository repository;

  GetCartCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repository.getCartCount();
  }
}
