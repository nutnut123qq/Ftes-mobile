import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/error/exceptions.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<void> cacheAccessToken(String token) async {
    try {
      print('💾 Caching access token: ${token.substring(0, 20)}...');
      await _sharedPreferences.setString(AppConstants.keyAccessToken, token);
      print('✅ Access token cached successfully');
    } catch (e) {
      print('❌ Failed to cache access token: $e');
      throw CacheException('Failed to cache access token: $e');
    }
  }

  @override
  Future<String?> getCachedAccessToken() async {
    try {
      return _sharedPreferences.getString(AppConstants.keyAccessToken);
    } catch (e) {
      throw CacheException('Failed to get cached access token: $e');
    }
  }

  @override
  Future<void> cacheRefreshToken(String token) async {
    try {
      await _sharedPreferences.setString(AppConstants.keyRefreshToken, token);
    } catch (e) {
      throw CacheException('Failed to cache refresh token: $e');
    }
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    try {
      return _sharedPreferences.getString(AppConstants.keyRefreshToken);
    } catch (e) {
      throw CacheException('Failed to get cached refresh token: $e');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _sharedPreferences.remove(AppConstants.keyAccessToken);
      await _sharedPreferences.remove(AppConstants.keyRefreshToken);
    } catch (e) {
      throw CacheException('Failed to clear tokens: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _sharedPreferences.setString(AppConstants.keyUserData, userJson);
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _sharedPreferences.getString(AppConstants.keyUserData);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _sharedPreferences.remove(AppConstants.keyUserData);
    } catch (e) {
      throw CacheException('Failed to clear user: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await getCachedAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await _sharedPreferences.setBool('is_logged_in', isLoggedIn);
    } catch (e) {
      throw CacheException('Failed to set login status: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await clearTokens();
      await clearUser();
      await setLoggedIn(false);
    } catch (e) {
      throw CacheException('Failed to clear auth data: $e');
    }
  }
}
