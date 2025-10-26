import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../data/models/upload_image_response_model.dart';
import 'package:dartz/dartz.dart';

/// Use case to get profile by user ID
class GetProfileByIdUseCase implements UseCase<Profile, String> {
  final ProfileRepository _repository;

  GetProfileByIdUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(String userId) async {
    try {
      final profile = await _repository.getProfileById(userId);
      return Right(profile);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}

/// Use case to get profile by username
class GetProfileByUsernameUseCase implements UseCase<Profile, GetProfileByUsernameParams> {
  final ProfileRepository _repository;

  GetProfileByUsernameUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(GetProfileByUsernameParams params) async {
    try {
      final profile = await _repository.getProfileByUsername(
        params.userName,
        postId: params.postId,
      );
      return Right(profile);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}

/// Use case to create profile
class CreateProfileUseCase implements UseCase<Profile, CreateProfileParams> {
  final ProfileRepository _repository;

  CreateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(CreateProfileParams params) async {
    try {
      final profile = await _repository.createProfile(params.userId, params.requestData);
      return Right(profile);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}

/// Use case to update profile
class UpdateProfileUseCase implements UseCase<Profile, UpdateProfileParams> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileParams params) async {
    try {
      final profile = await _repository.updateProfile(params.userId, params.requestData);
      return Right(profile);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}

/// Use case to create profile automatically
class CreateProfileAutoUseCase implements UseCase<Profile, String> {
  final ProfileRepository _repository;

  CreateProfileAutoUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(String userId) async {
    try {
      final profile = await _repository.createProfileAuto(userId);
      return Right(profile);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}

/// Use case to get participants count
class GetParticipantsCountUseCase implements UseCase<int, String> {
  final ProfileRepository _repository;

  GetParticipantsCountUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(String instructorId) async {
    try {
      final count = await _repository.getParticipantsCount(instructorId);
      return Right(count);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}

/// Use case to check apply course
class CheckApplyCourseUseCase implements UseCase<int, CheckApplyCourseParams> {
  final ProfileRepository _repository;

  CheckApplyCourseUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(CheckApplyCourseParams params) async {
    try {
      final status = await _repository.checkApplyCourse(params.userId, params.courseId);
      return Right(status);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}

/// Use case to upload image
class UploadImageUseCase implements UseCase<UploadImageResponseModel, UploadImageParams> {
  final ProfileRepository _repository;

  UploadImageUseCase(this._repository);

  @override
  Future<Either<Failure, UploadImageResponseModel>> call(UploadImageParams params) async {
    try {
      final response = await _repository.uploadImage(
        filePath: params.filePath,
        fileName: params.fileName,
        description: params.description,
        allText: params.allText,
        folderPath: params.folderPath,
      );
      return Right(response);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}

/// Parameters for GetProfileByUsernameUseCase
class GetProfileByUsernameParams {
  final String userName;
  final String? postId;

  GetProfileByUsernameParams({
    required this.userName,
    this.postId,
  });
}

/// Parameters for CreateProfileUseCase
class CreateProfileParams {
  final String userId;
  final Map<String, dynamic> requestData;

  CreateProfileParams({
    required this.userId,
    required this.requestData,
  });
}

/// Parameters for UpdateProfileUseCase
class UpdateProfileParams {
  final String userId;
  final Map<String, dynamic> requestData;

  UpdateProfileParams({
    required this.userId,
    required this.requestData,
  });
}

/// Parameters for CheckApplyCourseUseCase
class CheckApplyCourseParams {
  final String userId;
  final String courseId;

  CheckApplyCourseParams({
    required this.userId,
    required this.courseId,
  });
}

/// Parameters for UploadImageUseCase
class UploadImageParams {
  final String filePath;
  final String? fileName;
  final String? description;
  final String? allText;
  final String? folderPath;

  UploadImageParams({
    required this.filePath,
    this.fileName,
    this.description,
    this.allText,
    this.folderPath,
  });
}

/// Map exceptions to failures
Failure _mapExceptionToFailure(dynamic exception) {
  if (exception is ServerException) {
    return ServerFailure(exception.message);
  } else if (exception is NetworkException) {
    return NetworkFailure(exception.message);
  } else if (exception is ValidationException) {
    return ValidationFailure(exception.message);
  } else if (exception is AuthException) {
    return AuthFailure(exception.message);
  } else {
    return ServerFailure('Unexpected error: ${exception.toString()}');
  }
}
