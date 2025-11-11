import 'dart:async';
import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/features/auth/domain/constants/auth_constants.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Email validation regex pattern (optional - for validation if input looks like email)
// ignore: deprecated_member_use
final _emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

/// Use case for user login with retry logic
class LoginUseCase {
  final AuthRepository repository;
  final int maxRetries;
  final Duration retryDelay;

  LoginUseCase(
    this.repository, {
    this.maxRetries = AuthConstants.maxRetries,
    this.retryDelay = AuthConstants.retryDelay,
  });

  /// Execute login with credential (email or username) and password
  /// Retries on transient errors (NetworkException, ServerException with 5xx)
  Future<Either<Failure, User>> call(String credential, String password) async {
    // Validate input
    final validationError = _validateInput(credential, password);
    if (validationError != null) {
      return Left(validationError);
    }

    int attempt = 0;
    Duration delay = retryDelay;
    Either<Failure, User>? lastResult;

    while (attempt < maxRetries) {
      final result = await repository.login(credential, password);
      lastResult = result;

      // If success, return immediately
      if (result.isRight()) {
        return result;
      }

      // Check if we should retry
      final failure = result.fold((f) => f, (_) => null);
      if (failure == null || !_shouldRetry(failure, attempt)) {
        return result; // Don't retry, return failure
      }

      attempt++;
      if (attempt >= maxRetries) {
        return result; // Max retries reached
      }

      // Calculate exponential backoff delay
      delay = Duration(
        milliseconds: min(
          (retryDelay.inMilliseconds * pow(2, attempt - 1)).round(),
          Duration(seconds: 30).inMilliseconds, // Max 30 seconds
        ),
      );

      // Wait before retrying
      await Future.delayed(delay);
    }

    // Should never reach here, but just in case
    return lastResult ?? const Left(ServerFailure('Login failed after retries'));
  }

  /// Check if we should retry based on failure type
  bool _shouldRetry(Failure failure, int attempt) {
    // Retry on NetworkException (transient network errors)
    if (failure is NetworkFailure) {
      return true;
    }

    // Retry on ServerException (might be transient server errors)
    // But not on ValidationException or AuthException
    if (failure is ServerFailure) {
      // Only retry if it's likely a transient error (5xx)
      // We can't distinguish 5xx from 4xx here, so retry once
      return attempt < 2; // Retry max 2 times for server errors
    }

    // Don't retry on validation or auth errors
    return false;
  }

  /// Validate credential (email or username) and password input
  ValidationFailure? _validateInput(String credential, String password) {
    // Validate credential (can be email or username)
    if (credential.isEmpty) {
      return const ValidationFailure('Email hoặc tên đăng nhập không được để trống');
    }

    // If it looks like an email (contains @), validate email format
    if (credential.contains('@') && !_emailRegex.hasMatch(credential)) {
      return const ValidationFailure('Email không đúng định dạng');
    }

    // Validate password length
    if (password.isEmpty) {
      return const ValidationFailure('Mật khẩu không được để trống');
    }

    if (password.length < AuthConstants.minPasswordLength) {
      return ValidationFailure(
        'Mật khẩu phải có ít nhất ${AuthConstants.minPasswordLength} ký tự',
      );
    }

    if (password.length > AuthConstants.maxPasswordLength) {
      return ValidationFailure(
        'Mật khẩu không được vượt quá ${AuthConstants.maxPasswordLength} ký tự',
      );
    }

    return null;
  }
}
