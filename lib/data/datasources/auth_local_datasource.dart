import '../models/user_model.dart';

/// Abstract local data source for authentication operations
abstract class AuthLocalDataSource {
  /// Cache access token
  Future<void> cacheAccessToken(String token);

  /// Get cached access token
  Future<String?> getCachedAccessToken();

  /// Cache refresh token
  Future<void> cacheRefreshToken(String token);

  /// Get cached refresh token
  Future<String?> getCachedRefreshToken();

  /// Clear all tokens
  Future<void> clearTokens();

  /// Cache user data
  Future<void> cacheUser(UserModel user);

  /// Get cached user data
  Future<UserModel?> getCachedUser();

  /// Clear user data
  Future<void> clearUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Set login status
  Future<void> setLoggedIn(bool isLoggedIn);

  /// Clear all authentication data
  Future<void> clearAuthData();
}
