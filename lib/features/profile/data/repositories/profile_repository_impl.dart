import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/constants/profile_constants.dart';
import '../models/profile_model.dart';
import '../models/profile_request_model.dart';
import '../models/upload_image_response_model.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Profile repository implementation
class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl({
    required ApiClient apiClient,
    required NetworkInfo networkInfo,
  })  : _apiClient = apiClient,
        _networkInfo = networkInfo;

  @override
  Future<Profile> getProfileById(String userId) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await _apiClient.get(
        '${ProfileConstants.getProfileByIdEndpoint}/$userId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          return ProfileModel.fromJson(data['result']).toEntity();
        } else {
          throw ServerException(ProfileConstants.errorProfileNotFound);
        }
      } else {
        final data = response.data;
        throw ServerException(
          data?['messageDTO']?['message'] ?? ProfileConstants.errorGetProfileFailed,
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorGetProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<Profile> getProfileByUsername(String userName, {String? postId}) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final queryParams = <String, dynamic>{};
      if (postId != null) {
        queryParams['postId'] = postId;
      }

      final response = await _apiClient.get(
        '${ProfileConstants.getProfileByUsernameEndpoint}/$userName',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          return ProfileModel.fromJson(data['result']).toEntity();
        } else {
          throw ServerException(ProfileConstants.errorProfileNotFound);
        }
      } else {
        final data = response.data;
        throw ServerException(
          data?['messageDTO']?['message'] ?? ProfileConstants.errorGetProfileFailed,
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorGetProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<Profile> createProfile(String userId, Map<String, dynamic> requestData) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await _apiClient.post(
        '${ProfileConstants.createProfileEndpoint}/$userId',
        data: requestData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          return ProfileModel.fromJson(data['result']).toEntity();
        } else {
          throw ServerException(ProfileConstants.errorCreateProfileFailed);
        }
      } else {
        final data = response.data;
        throw ServerException(
          data?['messageDTO']?['message'] ?? ProfileConstants.errorCreateProfileFailed,
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorCreateProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<Profile> updateProfile(String userId, Map<String, dynamic> requestData) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await _apiClient.put(
        '${ProfileConstants.updateProfileEndpoint}/$userId',
        data: requestData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          return ProfileModel.fromJson(data['result']).toEntity();
        } else {
          throw ServerException(ProfileConstants.errorUpdateProfileFailed);
        }
      } else {
        final data = response.data;
        throw ServerException(
          data?['messageDTO']?['message'] ?? ProfileConstants.errorUpdateProfileFailed,
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorUpdateProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<Profile> createProfileAuto(String userId) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await _apiClient.post(
        '${ProfileConstants.createProfileAutoEndpoint}/$userId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          return ProfileModel.fromJson(data['result']).toEntity();
        } else {
          throw ServerException(ProfileConstants.errorCreateProfileFailed);
        }
      } else {
        final data = response.data;
        throw ServerException(
          data?['messageDTO']?['message'] ?? ProfileConstants.errorCreateProfileFailed,
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorCreateProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<int> getParticipantsCount(String instructorId) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await _apiClient.get(
        '${ProfileConstants.countParticipantsEndpoint}/$instructorId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          return data['result'] as int;
        } else {
          throw ServerException(ProfileConstants.errorCountParticipantsFailed);
        }
      } else {
        final data = response.data;
        throw ServerException(
          data?['messageDTO']?['message'] ?? ProfileConstants.errorCountParticipantsFailed,
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorCountParticipantsFailed}: ${e.toString()}');
    }
  }

  @override
  Future<int> checkApplyCourse(String userId, String courseId) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await _apiClient.get(
        '${ProfileConstants.checkApplyCourseEndpoint}/$userId/apply-course/$courseId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          return data['result'] as int;
        } else {
          throw ServerException(ProfileConstants.errorCheckApplyCourseFailed);
        }
      } else {
        final data = response.data;
        throw ServerException(
          data?['messageDTO']?['message'] ?? ProfileConstants.errorCheckApplyCourseFailed,
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorCheckApplyCourseFailed}: ${e.toString()}');
    }
  }

  @override
  Future<UploadImageResponseModel> uploadImage({
    required String filePath,
    String? fileName,
    String? description,
    String? allText,
    String? folderPath,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw ValidationException('File does not exist');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName ?? file.path.split('/').last,
        ),
        if (fileName != null) 'fileName': fileName,
        if (description != null) 'description': description,
        if (allText != null) 'allText': allText,
        if (folderPath != null) 'folderPath': folderPath,
      });

      final response = await _apiClient.post(
        ProfileConstants.uploadImageEndpoint,
        data: formData,
      );

      debugPrint('Upload image response status: ${response.statusCode}');
      debugPrint('Upload image response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          return UploadImageResponseModel.fromJson(data);
        } else {
          throw ServerException(ProfileConstants.errorUploadImageFailed);
        }
      } else {
        final data = response.data;
        throw ServerException(
          data?['messageDTO']?['message'] ?? ProfileConstants.errorUploadImageFailed,
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorUploadImageFailed}: ${e.toString()}');
    }
  }
}
