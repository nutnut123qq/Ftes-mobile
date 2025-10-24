import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

/// Abstract repository interface for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> login(String email, String password);

  /// Login with Google OAuth
  Future<Either<Failure, User>> loginWithGoogle();

  /// Get current user info
  Future<Either<Failure, User>> getCurrentUser();

  /// Logout
  Future<Either<Failure, void>> logout();
}
