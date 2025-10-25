import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting current user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  /// Execute get current user
  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
}
