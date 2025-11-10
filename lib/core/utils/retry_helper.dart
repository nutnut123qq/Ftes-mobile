import 'dart:async';
import 'dart:math';
import '../error/exceptions.dart';

/// Retry helper with exponential backoff
/// 
/// Retries a function with exponential backoff strategy.
/// Only retries on NetworkException, not on ServerException or ValidationException.
/// 
/// Example:
/// ```dart
/// final result = await retryWithBackoff(
///   () => apiClient.get('/endpoint'),
///   maxRetries: 3,
///   initialDelay: Duration(seconds: 1),
/// );
/// ```
Future<T> retryWithBackoff<T>({
  required Future<T> Function() operation,
  int maxRetries = 3,
  Duration initialDelay = const Duration(seconds: 2),
  Duration? maxDelay,
}) async {
  int attempt = 0;
  Duration delay = initialDelay;
  final maxDelayValue = maxDelay ?? Duration(seconds: 30);

  while (attempt < maxRetries) {
    try {
      return await operation();
    } catch (e) {
      attempt++;
      
      // Only retry on NetworkException
      // Don't retry on ServerException, ValidationException, etc.
      if (e is! NetworkException || attempt >= maxRetries) {
        rethrow;
      }

      // Calculate exponential backoff delay
      // delay = initialDelay * 2^(attempt - 1)
      delay = Duration(
        milliseconds: min(
          (initialDelay.inMilliseconds * pow(2, attempt - 1)).round(),
          maxDelayValue.inMilliseconds,
        ),
      );

      // Wait before retrying
      await Future.delayed(delay);
    }
  }

  // This should never be reached, but just in case
  throw Exception('Retry failed after $maxRetries attempts');
}

