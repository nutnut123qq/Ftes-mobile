import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile.dart';
import '../repositories/course_repository.dart';

/// Use case for getting profile by userId
class GetProfileUseCase implements UseCase<Profile, GetProfileParams> {
  final CourseRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Profile>> call(GetProfileParams params) async {
    return await repository.getProfile(params.userId);
  }
}

/// Parameters for GetProfileUseCase
class GetProfileParams {
  final String userId;

  const GetProfileParams({
    required this.userId,
  });
}
