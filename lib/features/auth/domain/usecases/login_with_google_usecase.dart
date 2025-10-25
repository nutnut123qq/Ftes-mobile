import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for Google OAuth login
class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  /// Execute Google OAuth login
  Future<Either<Failure, User>> call() async {
    return await repository.loginWithGoogle();
  }
}
