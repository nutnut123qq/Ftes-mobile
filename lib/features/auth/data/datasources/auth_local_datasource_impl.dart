import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/error/exceptions.dart';
import 'package:ftes/features/auth/domain/constants/auth_constants.dart';
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
      await _sharedPreferences.setString(AppConstants.keyAccessToken, token);
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
    }
  }

  @override
  Future<void> cacheUserId(String userId) async {
    try {
      await _sharedPreferences.setString(AppConstants.keyUserId, userId);
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
    }
  }

  @override
  Future<String?> getCachedAccessToken() async {
    try {
      return _sharedPreferences.getString(AppConstants.keyAccessToken);
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
    }
  }

  @override
  Future<void> cacheRefreshToken(String token) async {
    try {
      await _sharedPreferences.setString(AppConstants.keyRefreshToken, token);
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
    }
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    try {
      return _sharedPreferences.getString(AppConstants.keyRefreshToken);
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _sharedPreferences.remove(AppConstants.keyAccessToken);
      await _sharedPreferences.remove(AppConstants.keyRefreshToken);
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    // Use TTL version with default TTL for backward compatibility
    await cacheUserWithTTL(user, AuthConstants.userCacheTTL);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    // Use TTL version with default TTL for backward compatibility
    return await getCachedUserWithTTL(AuthConstants.userCacheTTL);
  }

  @override
  Future<void> cacheUserWithTTL(UserModel user, Duration ttl) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final userJson = await compute(_encodeUserJson, user.toJson());
      final payload = jsonEncode({
        'ts': now,
        'data': userJson,
      });
      await _sharedPreferences.setString(
        '${AuthConstants.cacheKeyPrefixUser}${AppConstants.keyUserData}',
        payload,
      );
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUserWithTTL(Duration ttl) async {
    try {
      final raw = _sharedPreferences.getString(
        '${AuthConstants.cacheKeyPrefixUser}${AppConstants.keyUserData}',
      );
      if (raw == null) {
        // Fallback to old cache key for backward compatibility
        final oldUserJson = _sharedPreferences.getString(AppConstants.keyUserData);
        if (oldUserJson != null) {
          final userMap = await compute(_decodeUserJson, oldUserJson);
          return UserModel.fromJson(userMap);
        }
        return null;
      }

      final map = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (map['ts'] as num?)?.toInt() ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > ttl.inMilliseconds) {
        // expired
        await _sharedPreferences.remove(
          '${AuthConstants.cacheKeyPrefixUser}${AppConstants.keyUserData}',
        );
        return null;
      }
      final userJson = map['data'] as String;
      final userMap = await compute(_decodeUserJson, userJson);
      return UserModel.fromJson(userMap);
    } catch (e) {
      // Silently fail and remove corrupted cache
      try {
        await _sharedPreferences.remove(
          '${AuthConstants.cacheKeyPrefixUser}${AppConstants.keyUserData}',
        );
      } catch (_) {}
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await Future.wait([
        _sharedPreferences.remove(AppConstants.keyUserData),
        _sharedPreferences.remove(
          '${AuthConstants.cacheKeyPrefixUser}${AppConstants.keyUserData}',
        ),
      ]);
    } catch (e) {
      // Silently fail cache operations
      // ignore: avoid_print
      print('Failed to clear user cache: $e');
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
      throw const CacheException(AuthConstants.errorCache);
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        clearTokens(),
        clearUser(),
        setLoggedIn(false),
      ]);
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
    }
  }
}

// Off-main-thread helpers for JSON (compute requires top-level functions)
String _encodeUserJson(Map<String, dynamic> json) => jsonEncode(json);
Map<String, dynamic> _decodeUserJson(String jsonStr) => jsonDecode(jsonStr) as Map<String, dynamic>;
