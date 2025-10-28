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
    try {
      final userJson = await compute(_encodeUserJson, user.toJson());
      await _sharedPreferences.setString(AppConstants.keyUserData, userJson);
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _sharedPreferences.getString(AppConstants.keyUserData);
      if (userJson != null) {
        final userMap = await compute(_decodeUserJson, userJson);
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _sharedPreferences.remove(AppConstants.keyUserData);
    } catch (e) {
      throw const CacheException(AuthConstants.errorCache);
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
