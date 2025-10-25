import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Execute logout
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
