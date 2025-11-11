import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

/// Use case to get instructor profile by username
class GetInstructorProfileByUsernameUseCase implements UseCase<Profile, String> {
  final ProfileRepository _repository;

  GetInstructorProfileByUsernameUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(String username) async {
    return await _repository.getInstructorProfileByUsername(username);
  }
}
