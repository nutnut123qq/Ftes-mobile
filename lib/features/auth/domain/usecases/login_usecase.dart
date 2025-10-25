import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Execute login with email and password
  Future<Either<Failure, User>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
