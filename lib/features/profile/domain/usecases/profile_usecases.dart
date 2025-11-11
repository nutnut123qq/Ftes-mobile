import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
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
    return await _repository.getProfileById(userId);
  }
}

/// Use case to get profile by username
class GetProfileByUsernameUseCase implements UseCase<Profile, GetProfileByUsernameParams> {
  final ProfileRepository _repository;

  GetProfileByUsernameUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(GetProfileByUsernameParams params) async {
    return await _repository.getProfileByUsername(
      params.userName,
      postId: params.postId,
    );
  }
}

/// Use case to create profile
class CreateProfileUseCase implements UseCase<Profile, CreateProfileParams> {
  final ProfileRepository _repository;

  CreateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(CreateProfileParams params) async {
    return await _repository.createProfile(params.userId, params.requestData);
  }
}

/// Use case to update profile
class UpdateProfileUseCase implements UseCase<Profile, UpdateProfileParams> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileParams params) async {
    return await _repository.updateProfile(params.userId, params.requestData);
  }
}

/// Use case to create profile automatically
class CreateProfileAutoUseCase implements UseCase<Profile, String> {
  final ProfileRepository _repository;

  CreateProfileAutoUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(String userId) async {
    return await _repository.createProfileAuto(userId);
  }
}

/// Use case to get participants count
class GetParticipantsCountUseCase implements UseCase<int, String> {
  final ProfileRepository _repository;

  GetParticipantsCountUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(String instructorId) async {
    return await _repository.getParticipantsCount(instructorId);
  }
}

/// Use case to check apply course
class CheckApplyCourseUseCase implements UseCase<int, CheckApplyCourseParams> {
  final ProfileRepository _repository;

  CheckApplyCourseUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(CheckApplyCourseParams params) async {
    return await _repository.checkApplyCourse(params.userId, params.courseId);
  }
}

/// Use case to upload image
class UploadImageUseCase implements UseCase<UploadImageResponseModel, UploadImageParams> {
  final ProfileRepository _repository;

  UploadImageUseCase(this._repository);

  @override
  Future<Either<Failure, UploadImageResponseModel>> call(UploadImageParams params) async {
    return await _repository.uploadImage(
      filePath: params.filePath,
      fileName: params.fileName,
      description: params.description,
      allText: params.allText,
      folderPath: params.folderPath,
    );
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

