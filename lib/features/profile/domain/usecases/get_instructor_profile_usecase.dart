import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

/// Use case to get instructor profile by username
class GetInstructorProfileByUsernameUseCase implements UseCase<Profile, String> {
  final ProfileRepository _repository;

  GetInstructorProfileByUsernameUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(String username) async {
    try {
      final profile = await _repository.getInstructorProfileByUsername(username);
      return Right(profile);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    } else {
      return ServerFailure('Unexpected error: $exception');
    }
  }
}
