import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/update_profile_request.dart';
import '../models/profile_response.dart';
import '../models/user_request.dart';
import '../core/constants/app_constants.dart';
import 'http_client.dart';

/// Service để xử lý các thao tác liên quan đến profile
class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  final HttpClient _httpClient = HttpClient();

  void initialize() {
    _httpClient.initialize();
  }

  void dispose() {
    _httpClient.dispose();
  }

  // Helper method to handle standard API responses
  Future<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
    String errorMessage,
  ) async {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return fromJson(data['result']);
    } else {
      throw Exception('$errorMessage: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get user profile
  Future<ProfileResponse> getProfile(String userId) async {
    try {
      final response = await _httpClient.get('${AppConstants.viewProfileEndpoint}/$userId');

      if (response.statusCode == 200) {
        return await _handleResponse<ProfileResponse>(
          response,
          ProfileResponse.fromJson,
          'Get profile failed',
        );
      } else if (response.statusCode == 400) {
        // Profile doesn't exist, create it first
        await createProfile(userId);
        // Try to get profile again
        final retryResponse = await _httpClient.get('${AppConstants.viewProfileEndpoint}/$userId');
        return await _handleResponse<ProfileResponse>(
          retryResponse,
          ProfileResponse.fromJson,
          'Get profile failed after creation',
        );
      } else {
        throw Exception('Get profile failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Get profile error: $e');
    }
  }

  /// Create user profile
  Future<void> createProfile(String userId) async {
    try {
      final response = await _httpClient.post('${AppConstants.createProfileEndpoint}/$userId');
      
      if (response.statusCode != 200) {
        throw Exception('Create profile failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Create profile error: $e');
    }
  }

  /// Update user profile
  Future<ProfileResponse> updateProfile(String userId, UpdateProfileRequest request) async {
    try {
      final response = await _httpClient.put(
        '${AppConstants.updateProfileEndpoint}/$userId',
        body: request.toJson(),
      );
      
      return await _handleResponse<ProfileResponse>(
        response,
        ProfileResponse.fromJson,
        'Update profile failed',
      );
    } catch (e) {
      throw Exception('Update profile error: $e');
    }
  }

  /// Update Gmail
  Future<void> updateGmail(UpdateGmailRequest request) async {
    try {
      final response = await _httpClient.post(
        AppConstants.updateGmailEndpoint,
        body: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Update Gmail failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Update Gmail error: $e');
    }
  }
}
