import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/retry_helper.dart';
import '../../domain/constants/profile_constants.dart';
import '../models/profile_model.dart';
import '../models/instructor_course_model.dart';
import '../models/upload_image_response_model.dart';
import '../helpers/instructor_json_parser_helper.dart';
import '../helpers/profile_json_parser_helper.dart';
import 'profile_remote_datasource.dart';

/// Remote data source implementation for Profile feature
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ProfileModel> getProfileById(String userId) async {
    try {
      debugPrint('👤 Fetching profile by ID: $userId');

      final response = await retryWithBackoff(
        operation: () => _apiClient.get(
          '${ProfileConstants.getProfileByIdEndpoint}/$userId',
        ),
        maxRetries: ProfileConstants.maxRetries,
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Profile response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;
          
          // Use isolate parsing if response is large
          final jsonString = data.toString();
          if (jsonString.length > ProfileConstants.jsonParsingThreshold) {
            debugPrint('⚡ Using compute isolate for profile parsing (${jsonString.length}B > ${ProfileConstants.jsonParsingThreshold}B)');
            return await compute(parseProfileJson, result);
          } else {
            return ProfileModel.fromJson(result);
          }
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
      debugPrint('❌ Get profile by ID error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorGetProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> getProfileByUsername(String userName, {String? postId}) async {
    try {
      debugPrint('👤 Fetching profile by username: $userName');

      final queryParams = <String, dynamic>{};
      if (postId != null) {
        queryParams['postId'] = postId;
      }

      final response = await retryWithBackoff(
        operation: () => _apiClient.get(
          '${ProfileConstants.getProfileByUsernameEndpoint}/$userName',
          queryParameters: queryParams,
        ),
        maxRetries: ProfileConstants.maxRetries,
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Profile response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;
          
          // Use isolate parsing if response is large
          final jsonString = data.toString();
          if (jsonString.length > ProfileConstants.jsonParsingThreshold) {
            debugPrint('⚡ Using compute isolate for profile parsing');
            return await compute(parseProfileJson, result);
          } else {
            return ProfileModel.fromJson(result);
          }
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
      debugPrint('❌ Get profile by username error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorGetProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> getInstructorProfileByUsername(String userName) async {
    try {
      debugPrint('👨‍🏫 Fetching instructor profile by username: $userName');

      final response = await retryWithBackoff(
        operation: () => _apiClient.get(
          '${ProfileConstants.getProfileByUsernameEndpoint}/$userName',
        ),
        maxRetries: ProfileConstants.maxRetries,
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Instructor profile response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;
          
          // Use isolate parsing if response is large
          final jsonString = data.toString();
          if (jsonString.length > ProfileConstants.jsonParsingThreshold) {
            debugPrint('⚡ Using compute isolate for instructor profile parsing');
            return await compute(parseProfileJson, result);
          } else {
            return ProfileModel.fromJson(result);
          }
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
      debugPrint('❌ Get instructor profile error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorGetProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<List<InstructorCourseModel>> getCoursesByCreator(String userId) async {
    try {
      debugPrint('📚 Fetching instructor courses for user: $userId');

      final response = await retryWithBackoff(
        operation: () => _apiClient.get(
          '${ProfileConstants.getInstructorCoursesEndpoint}/$userId',
        ),
        maxRetries: ProfileConstants.maxRetries,
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Instructor courses response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          final result = data['result'];
          List<dynamic> coursesList;
          
          if (result['data'] is List) {
            coursesList = result['data'] as List;
          } else {
            coursesList = [];
          }

          // Use compute isolate for parsing if list is large
          if (coursesList.length > ProfileConstants.instructorCoursesThreshold) {
            debugPrint('🔄 Using compute() isolate for parsing ${coursesList.length} instructor courses');
            return await compute(parseInstructorCoursesJson, coursesList);
          } else {
            return parseInstructorCoursesJson(coursesList);
          }
        } else {
          throw ServerException(ProfileConstants.errorGetInstructorCoursesFailed);
        }
      } else {
        final data = response.data;
        throw ServerException(
          data?['messageDTO']?['message'] ?? ProfileConstants.errorGetInstructorCoursesFailed,
        );
      }
    } catch (e) {
      debugPrint('❌ Get instructor courses error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorGetInstructorCoursesFailed}: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> createProfile(String userId, Map<String, dynamic> requestData) async {
    try {
      debugPrint('➕ Creating profile for user: $userId');

      final response = await retryWithBackoff(
        operation: () => _apiClient.post(
          '${ProfileConstants.createProfileEndpoint}/$userId',
          data: requestData,
        ),
        maxRetries: ProfileConstants.maxRetries,
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Create profile response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;
          return ProfileModel.fromJson(result);
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
      debugPrint('❌ Create profile error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorCreateProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> updateProfile(String userId, Map<String, dynamic> requestData) async {
    try {
      debugPrint('✏️ Updating profile for user: $userId');

      final response = await retryWithBackoff(
        operation: () => _apiClient.put(
          '${ProfileConstants.updateProfileEndpoint}/$userId',
          data: requestData,
        ),
        maxRetries: ProfileConstants.maxRetries,
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Update profile response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;
          return ProfileModel.fromJson(result);
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
      debugPrint('❌ Update profile error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorUpdateProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> createProfileAuto(String userId) async {
    try {
      debugPrint('⚡ Creating profile automatically for user: $userId');

      final response = await retryWithBackoff(
        operation: () => _apiClient.post(
          '${ProfileConstants.createProfileAutoEndpoint}/$userId',
        ),
        maxRetries: ProfileConstants.maxRetries,
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Create profile auto response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;
          return ProfileModel.fromJson(result);
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
      debugPrint('❌ Create profile auto error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorCreateProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<int> getParticipantsCount(String instructorId) async {
    try {
      debugPrint('👥 Fetching participants count for instructor: $instructorId');

      final response = await retryWithBackoff(
        operation: () => _apiClient.get(
          '${ProfileConstants.countParticipantsEndpoint}/$instructorId',
        ),
        maxRetries: ProfileConstants.maxRetries,
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Participants count response status: ${response.statusCode}');

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
      debugPrint('❌ Get participants count error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorCountParticipantsFailed}: ${e.toString()}');
    }
  }

  @override
  Future<int> checkApplyCourse(String userId, String courseId) async {
    try {
      debugPrint('✅ Checking apply course for user: $userId, course: $courseId');

      final response = await retryWithBackoff(
        operation: () => _apiClient.get(
          '${ProfileConstants.checkApplyCourseEndpoint}/$userId/apply-course/$courseId',
        ),
        maxRetries: ProfileConstants.maxRetries,
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Check apply course response status: ${response.statusCode}');

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
      debugPrint('❌ Check apply course error: $e');
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
    try {
      debugPrint('📤 Uploading image: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        throw ValidationException('File does not exist');
      }

      // Read file bytes in isolate to avoid blocking UI
      final fileBytes = await compute(_readFileBytes, filePath);
      final multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName ?? file.path.split('/').last,
      );

      final formData = FormData.fromMap({
        'file': multipartFile,
        if (fileName != null) 'fileName': fileName,
        if (description != null) 'description': description,
        if (allText != null) 'allText': allText,
        if (folderPath != null) 'folderPath': folderPath,
      });

      // Use dio directly for upload with custom timeout and progress
      final response = await retryWithBackoff(
        operation: () => _apiClient.dio.post(
          ProfileConstants.uploadImageEndpoint,
          data: formData,
          options: Options(
            sendTimeout: ProfileConstants.uploadImageTimeout,
            receiveTimeout: const Duration(seconds: 30),
          ),
          onSendProgress: (sent, total) {
            if (total > 0) {
              final progress = (sent / total * 100).toStringAsFixed(1);
              debugPrint('📤 Upload progress: $progress% ($sent/$total bytes)');
            }
          },
        ),
        maxRetries: 2, // Upload only retry 2 times
        initialDelay: ProfileConstants.retryDelay,
      );

      debugPrint('📥 Upload image response status: ${response.statusCode}');
      debugPrint('📥 Upload image response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          return UploadImageResponseModel.fromJson(data as Map<String, dynamic>);
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
      debugPrint('❌ Upload image error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${ProfileConstants.errorUploadImageFailed}: ${e.toString()}');
    }
  }
}

/// Top-level function for reading file bytes in isolate
List<int> _readFileBytes(String filePath) {
  final file = File(filePath);
  return file.readAsBytesSync();
}


