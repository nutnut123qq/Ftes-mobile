import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:ftes/core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for refreshing user information with debounce
class RefreshUserInfoUseCase {
  final AuthRepository repository;
  Timer? _debounceTimer;
  static const Duration debounceDelay = Duration(milliseconds: 300);

  RefreshUserInfoUseCase(this.repository);

  /// Execute refresh with debounce
  /// Returns the latest user info or failure
  Future<Either<Failure, User>> call() async {
    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    // Create a completer to handle debounced execution
    final completer = Completer<Either<Failure, User>>();

    _debounceTimer = Timer(debounceDelay, () async {
      final result = await repository.getCurrentUser();
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    });

    return completer.future;
  }

  /// Cancel any pending refresh operation
  void cancel() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  /// Dispose resources
  void dispose() {
    cancel();
  }
}

