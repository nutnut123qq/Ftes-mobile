/// Base exception class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(super.message);
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(super.message);
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message);
}
