import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/course_detail_model.dart';
import '../models/profile_model.dart';
import '../models/video_playlist_model.dart';
import '../models/video_status_model.dart';
import '../helpers/json_parser_helper.dart';
import '../../domain/constants/course_constants.dart';
import 'course_remote_datasource.dart';

/// Remote data source implementation for Course feature
class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient _apiClient;

  CourseRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<CourseDetailModel> getCourseDetailBySlug(String slugName, String? userId) async {
    try {
      debugPrint('📚 Fetching course detail: ${AppConstants.baseUrl}${AppConstants.courseDetailEndpoint}/$slugName');
      debugPrint('🔑 Slug: $slugName');
      if (userId != null) {
        debugPrint('👤 User ID: $userId');
      }
      
      final queryParams = <String, dynamic>{};
      if (userId != null && userId.isNotEmpty) {
        queryParams['userId'] = userId;
      }
      
      final response = await _apiClient.get(
        '${AppConstants.courseDetailEndpoint}/$slugName',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      
      debugPrint('📥 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null) {
          // Calculate complexity to decide if compute isolate should be used
          final partsCount = countParts(result);
          final totalLessons = calculateTotalLessons(result);
          
          debugPrint('📊 Course complexity: $partsCount parts, $totalLessons lessons');
          
          // Use compute isolate for complex course data to avoid blocking main thread
          if (partsCount > CourseConstants.defaultCourseDetailThreshold || 
              totalLessons > CourseConstants.defaultLessonThreshold) {
            debugPrint('⚡ Using compute isolate for JSON parsing');
            return await compute<Map<String, dynamic>, CourseDetailModel>(parseCourseDetailJson, result);
          } else {
            debugPrint('⚡ Parsing JSON on main thread (simple data)');
            return parseCourseDetailJson(result);
          }
        } else {
          throw ServerException(CourseConstants.errorInvalidResponse);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? CourseConstants.errorLoadCourseFailed);
      }
    } catch (e) {
      debugPrint('❌ Get course detail error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${CourseConstants.errorLoadCourseFailed}: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      debugPrint('👤 Fetching profile: ${AppConstants.baseUrl}${AppConstants.profileViewEndpoint}/$userId');
      
      final response = await _apiClient.get(
        '${AppConstants.profileViewEndpoint}/$userId',
      );
      
      debugPrint('📥 Profile response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null) {
          // Profile data is lightweight, no need for compute isolate
          return parseProfileJson(result);
        } else {
          throw ServerException(CourseConstants.errorInvalidResponse);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? CourseConstants.errorLoadProfileFailed);
      }
    } catch (e) {
      debugPrint('❌ Get profile error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${CourseConstants.errorLoadProfileFailed}: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkEnrollment(String userId, String courseId) async {
    try {
      debugPrint('🔍 Checking enrollment: ${AppConstants.baseUrl}${AppConstants.checkEnrollmentByUserEndpoint}/$userId/apply-course/$courseId');
      
      final response = await _apiClient.get(
        '${AppConstants.checkEnrollmentByUserEndpoint}/$userId/apply-course/$courseId',
      );
      
      debugPrint('📥 Enrollment response status: ${response.statusCode}');
      debugPrint('📥 Enrollment response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null) {
          // API returns 0 = not enrolled, 1 = enrolled
          return result == 1;
        } else {
          throw ServerException(CourseConstants.errorInvalidResponse);
        }
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? CourseConstants.errorCheckEnrollmentFailed);
      }
    } catch (e) {
      debugPrint('❌ Check enrollment error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${CourseConstants.errorCheckEnrollmentFailed}: ${e.toString()}');
    }
  }

  @override
  Future<void> enrollCourse(String userId, String courseId) async {
    try {
      debugPrint('✅ Enrolling in course: ${AppConstants.baseUrl}${AppConstants.enrollCourseEndpoint}');
      debugPrint('👤 User ID: $userId, 📚 Course ID: $courseId');
      
      final response = await _apiClient.post(
        AppConstants.enrollCourseEndpoint,
        data: {
          'userId': userId,
          'courseId': courseId,
        },
      );
      
      debugPrint('📥 Enroll response status: ${response.statusCode}');
      debugPrint('📥 Enroll response data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Successfully enrolled in course');
        return;
      } else {
        throw ServerException(response.data['messageDTO']?['message'] ?? CourseConstants.errorEnrollFailed);
      }
    } catch (e) {
      debugPrint('❌ Enroll course error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${CourseConstants.errorEnrollFailed}: ${e.toString()}');
    }
  }

  @override
  Future<VideoPlaylistModel> getVideoPlaylist(String videoId, {bool presign = false}) async {
    try {
      // Video ID format: "video_81f4308f-25d" (giữ nguyên prefix "video_")
      debugPrint('🎬 Fetching video playlist for ID: $videoId');
      debugPrint('🎬 Video stream base URL: ${AppConstants.videoStreamBaseUrl}');
      
      // Construct full URL for video API (dùng videoStreamBaseUrl)
      final playlistUrl = '${AppConstants.videoStreamBaseUrl}${AppConstants.videoPlaylistEndpoint}/$videoId/playlist';
      final queryParams = presign ? {'presign': 'true'} : null;
      
      debugPrint('🔗 Full URL: $playlistUrl${queryParams != null ? '?presign=true' : ''}');
      
      // Try to call video API from stream.ftes.cloud
      try {
        // Tạo request trực tiếp tới video stream server
        final dio = _apiClient.dio;
        final token = _apiClient.sharedPreferences.getString(AppConstants.keyAccessToken);
        
        final response = await dio.get(
          playlistUrl,
          queryParameters: queryParams,
          options: Options(
            headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          ),
        );
        
        debugPrint('📥 Video playlist response status: ${response.statusCode}');
        debugPrint('📥 Video playlist response data: ${response.data}');
        
        if (response.statusCode == 200) {
          // Extract proxy URL - could be relative or absolute
          var proxyUrl = response.data['proxyPlaylistUrl'];
          if (proxyUrl == null || proxyUrl.isEmpty) {
            // Fallback: construct full proxy URL
            proxyUrl = '${AppConstants.videoStreamBaseUrl}${AppConstants.videoProxyEndpoint}/$videoId/master.m3u8';
          } else if (!proxyUrl.startsWith('http')) {
            // Relative path - prepend base URL
            proxyUrl = '${AppConstants.videoStreamBaseUrl}$proxyUrl';
          }
          
          return VideoPlaylistModel(
            videoId: videoId,
            cdnPlaylistUrl: response.data['cdnPlaylistUrl'] ?? '',
            presignedUrl: response.data['presignedUrl'],
            proxyPlaylistUrl: proxyUrl,
          );
        }
      } catch (apiError) {
        debugPrint('⚠️ Video playlist API error: $apiError');
        debugPrint('⚠️ Falling back to direct proxy URL');
      }
      
      // Fallback: Use direct proxy URL from streaming server
      final proxyUrl = '${AppConstants.videoStreamBaseUrl}${AppConstants.videoProxyEndpoint}/$videoId/master.m3u8';
      debugPrint('✅ Using direct proxy URL: $proxyUrl');
      
      return VideoPlaylistModel(
        videoId: videoId,
        cdnPlaylistUrl: '',
        presignedUrl: null,
        proxyPlaylistUrl: proxyUrl,
      );
    } catch (e) {
      debugPrint('❌ Get video playlist error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException(AppConstants.videoFailedMessage);
    }
  }

  @override
  Future<VideoStatusModel> getVideoStatus(String videoId) async {
    try {
      // Video ID format: "video_81f4308f-25d" (giữ nguyên)
      debugPrint('⏳ Fetching video status for ID: $videoId');
      debugPrint('⏳ Video stream base URL: ${AppConstants.videoStreamBaseUrl}');
      
      // Construct full URL for video status API (dùng videoStreamBaseUrl)
      final statusUrl = '${AppConstants.videoStreamBaseUrl}${AppConstants.videoStatusEndpoint}/$videoId/status';
      debugPrint('🔗 Full URL: $statusUrl');
      
      try {
        // Tạo request trực tiếp tới video stream server
        final dio = _apiClient.dio;
        final token = _apiClient.sharedPreferences.getString(AppConstants.keyAccessToken);
        
        final response = await dio.get(
          statusUrl,
          options: Options(
            headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          ),
        );
        
        debugPrint('📥 Video status response status: ${response.statusCode}');
        debugPrint('📥 Video status response data: ${response.data}');
        
        if (response.statusCode == 200) {
          return VideoStatusModel.fromJson(response.data);
        } else {
          throw ServerException(response.data['message'] ?? AppConstants.videoFailedMessage);
        }
      } catch (apiError) {
        debugPrint('❌ Video status API error: $apiError');
        throw ServerException(AppConstants.videoFailedMessage);
      }
    } catch (e) {
      debugPrint('❌ Get video status error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException(AppConstants.videoFailedMessage);
    }
  }
}
