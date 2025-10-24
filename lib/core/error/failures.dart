/// Abstract base class for all failures in the application
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Server-related failures (API errors, 500, etc.)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Network-related failures (no internet, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Cache-related failures (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Authentication-related failures (login failed, token expired, etc.)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Validation failures (invalid input, etc.)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
