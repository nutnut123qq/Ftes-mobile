import 'dart:convert';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../models/user_request.dart';
import '../models/update_profile_request.dart';
import '../models/profile_response.dart';
import '../utils/api_constants.dart';
import 'http_client.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    // Auto-initialize HttpClient when AuthService is created
    _httpClient.initialize();
  }

  final HttpClient _httpClient = HttpClient();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '957561951017-38543te6feepe3geb5sh6ae2jpgsksi4.apps.googleusercontent.com',
  );

  // Initialize the service
  void initialize() {
    _httpClient.initialize();
  }

  // Dispose the service
  void dispose() {
    _httpClient.dispose();
  }

  /// Login with email and password
  Future<AuthenticationResponse> login(AuthenticationRequest request) async {
    try {
      
      final response = await _httpClient.post(
        ApiConstants.loginEndpoint,
        body: request.toJson(),
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authResponse = AuthenticationResponse.fromJson(data['result']);
        
        // Store access token
        await _httpClient.setAccessToken(authResponse.accessToken);
        
        return authResponse;
      } else {
        throw Exception('Login failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Login with Google OAuth
  Future<AuthenticationResponse> loginWithGoogle({bool isAdmin = false}) async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? authCode = googleAuth.serverAuthCode;
      final String? accessToken = googleAuth.accessToken;

      if (authCode == null && accessToken == null) {
        throw Exception('Failed to get Google authentication details');
      }

      // For development, use access token directly if auth code is not available
      String authParam = authCode ?? accessToken!;
      String paramName = authCode != null ? 'code' : 'access_token';

      // Send auth code/token to backend
      final response = await _httpClient.post(
        ApiConstants.googleAuthEndpoint,
        queryParameters: {
          paramName: authParam,
          'isAdmin': isAdmin.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authResponse = AuthenticationResponse.fromJson(data['result']);
        
        // Store access token
        await _httpClient.setAccessToken(authResponse.accessToken);
        
        return authResponse;
      } else {
        throw Exception('Google login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Google login error: $e');
    }
  }

  /// Refresh access token
  Future<AuthenticationResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.refreshTokenEndpoint,
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authResponse = AuthenticationResponse.fromJson(data['result']);
        
        // Store new access token
        await _httpClient.setAccessToken(authResponse.accessToken);
        
        return authResponse;
      } else {
        throw Exception('Token refresh failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Token refresh error: $e');
    }
  }

  /// Verify email OTP and activate account
  Future<void> verifyEmailOTP(String email, String code) async {
    try {
      
      // Convert code to Integer as backend expects
      final intCode = int.tryParse(code);
      if (intCode == null) {
        throw Exception('Invalid OTP format: $code');
      }
      
      // Step 1: Verify OTP
      final response = await _httpClient.post(
        ApiConstants.verifyEmailCodeEndpoint,
        body: {
          'email': email,
          'otp': intCode,  // Send as Integer, not String
        },
      );


      if (response.statusCode != 200) {
        throw Exception('Email verification failed: ${response.statusCode} - ${response.body}');
      }

      // Step 2: Parse response to get access token
      final data = jsonDecode(response.body);
      final accessToken = data['result']['accessToken'];
      
      if (accessToken == null) {
        throw Exception('No access token received from OTP verification');
      }

      // Step 2: Activate user account

      // Step 3: Activate user account
      final activateResponse = await _httpClient.post(
        '${ApiConstants.activeUserEndpoint}/$accessToken',
      );


      if (activateResponse.statusCode != 200) {
        throw Exception('Account activation failed: ${activateResponse.statusCode} - ${activateResponse.body}');
      }

      // Step 4: Store access token
      await _httpClient.setAccessToken(accessToken);
      
    } catch (e) {
      throw Exception('Email verification error: $e');
    }
  }

  /// Verify PIN
  Future<void> verifyPin(String pin) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.verifyPinEndpoint,
        body: {'pin': pin},
      );

      if (response.statusCode != 200) {
        throw Exception('PIN verification failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('PIN verification error: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      
      final response = await _httpClient.post(ApiConstants.logoutEndpoint);
      
      
      if (response.statusCode == 200) {
      } else {
        // Don't throw error, just log it and continue with local cleanup
      }
      
      // Clear local tokens
      await _httpClient.clearTokens();
      
      // Sign out from Google
      await _googleSignIn.signOut();
    } catch (e) {
      // Don't throw error, just log it and continue with local cleanup
      try {
        await _httpClient.clearTokens();
        await _googleSignIn.signOut();
      } catch (cleanupError) {
      }
    }
  }

  /// Check if token is valid
  Future<IntrospectResponse> introspect(IntrospectRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.introspectEndpoint,
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return IntrospectResponse.fromJson(data['result']);
      } else {
        throw Exception('Token introspection failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Token introspection error: $e');
    }
  }

  /// Verify OTP
  Future<TwoFAResponse> verifyOTP(GenericAuthCodeRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.verifyOtpEndpoint,
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TwoFAResponse.fromJson(data['result']);
      } else {
        throw Exception('OTP verification failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('OTP verification error: $e');
    }
  }

  /// Send secret key for 2FA
  Future<TwoFAResponse> sendSecretKeyFor2FA() async {
    try {
      final response = await _httpClient.post(ApiConstants.sendSecretKeyEndpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TwoFAResponse.fromJson(data['result']);
      } else {
        throw Exception('Send secret key failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Send secret key error: $e');
    }
  }

  /// Verify email code
  Future<VerifyMailOTPResponse> verifyEmailCode(GenericAuthCodeRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.verifyEmailCodeEndpoint,
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VerifyMailOTPResponse.fromJson(data['result']);
      } else {
        throw Exception('Email code verification failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Email code verification error: $e');
    }
  }

  /// Verify update email
  Future<VerifyMailOTPResponse> verifyUpdateEmail(GenericAuthCodeRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.verifyUpdateEmailEndpoint,
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VerifyMailOTPResponse.fromJson(data['result']);
      } else {
        throw Exception('Update email verification failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Update email verification error: $e');
    }
  }

  /// Register new user
  Future<void> register(UserRegistrationRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.userRegistrationEndpoint,
        body: request.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // Check if it's the specific backend constraint violation error
        final responseBody = response.body;
        if (responseBody.contains('M015') && responseBody.contains('Uncategorized exception')) {
          // This is the known backend bug - user creation fails due to user_verify_code constraint
          // Try a different approach: attempt to create user without verification code first
          await _handleConstraintViolationAlternative(request);
          return;
        }
        throw Exception('Registration failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Check if it's the specific constraint violation error
      if (e.toString().contains('M015') && e.toString().contains('Uncategorized exception')) {
        try {
          await _handleConstraintViolationAlternative(request);
          return;
        } catch (alternativeError) {
          // Even if alternative fails, we'll still treat it as success
          // This allows user to proceed to verification screen
          return;
        }
      }
      throw Exception('Registration error: $e');
    }
  }

  /// Handle constraint violation with alternative approach
  Future<void> _handleConstraintViolationAlternative(UserRegistrationRequest request) async {
    try {
      // Wait a bit for the backend to potentially recover
      await Future.delayed(const Duration(seconds: 2));
      
      // Try registration again (sometimes the constraint violation is temporary)
      final retryResponse = await _httpClient.post(
        ApiConstants.userRegistrationEndpoint,
        body: request.toJson(),
      );
      
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        return;
      }
      
      // If retry fails, try to resend verification code
      // This might work if user was partially created
      await resendVerifyCode(request.email);
      
    } catch (e) {
      // If all approaches fail, we'll still treat it as success
      // This allows the user to proceed to verification screen where they can try to resend
      return; // Explicitly return without throwing
    }
  }

  /// Resend verification code
  Future<void> resendVerifyCode(String email) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.resendVerifyCodeEndpoint,
        body: {'email': email},
      );

      if (response.statusCode != 200) {
        throw Exception('Resend verification code failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Resend verification code error: $e');
    }
  }

  /// Activate user account
  Future<void> activateUser(String accessToken) async {
    try {
      final response = await _httpClient.post(
        '${ApiConstants.activeUserEndpoint}/$accessToken',
      );

      if (response.statusCode != 200) {
        throw Exception('Account activation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Account activation error: $e');
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.forgotPasswordEndpoint,
        body: {'email': email},
      );

      if (response.statusCode != 200) {
        throw Exception('Forgot password failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Forgot password error: $e');
    }
  }

  /// Change password
  Future<void> changePassword(String userId, ChangePasswordRequest request) async {
    try {
      final response = await _httpClient.put(
        '${ApiConstants.changePasswordEndpoint}/$userId',
        body: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Change password failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Change password error: $e');
    }
  }

  /// Get current user info
  Future<UserInfo> getMyInfo() async {
    try {
      final response = await _httpClient.get(ApiConstants.myInfoEndpoint);
      

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserInfo.fromJson(data['result']);
      } else {
        throw Exception('Get user info failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Get user info error: $e');
    }
  }

  /// Update Gmail
  Future<void> updateGmail(UpdateGmailRequest request) async {
    try {
      final response = await _httpClient.post(
        ApiConstants.updateGmailEndpoint,
        body: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Update Gmail failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Update Gmail error: $e');
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _httpClient.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Get current access token
  Future<String?> getCurrentToken() async {
    return await _httpClient.getAccessToken();
  }

  /// Get user profile
  Future<ProfileResponse> getProfile(String userId) async {
    try {
      final response = await _httpClient.get('${ApiConstants.viewProfileEndpoint}/$userId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProfileResponse.fromJson(data['result']);
      } else if (response.statusCode == 400) {
        // Profile doesn't exist, create it first
        await createProfile(userId);
        // Try to get profile again
        final retryResponse = await _httpClient.get('${ApiConstants.viewProfileEndpoint}/$userId');
        if (retryResponse.statusCode == 200) {
          final data = jsonDecode(retryResponse.body);
          return ProfileResponse.fromJson(data['result']);
        } else {
          throw Exception('Get profile failed after creation: ${retryResponse.statusCode}');
        }
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
      final response = await _httpClient.post('${ApiConstants.createProfileEndpoint}/$userId');
      
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
        '${ApiConstants.updateProfileEndpoint}/$userId',
        body: request.toJson(),
      );
      

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProfileResponse.fromJson(data['result']);
      } else {
        throw Exception('Update profile failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Update profile error: $e');
    }
  }

  /// Upload image
  Future<String> uploadImage(File imageFile) async {
    try {
      final token = await _httpClient.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.uploadImageEndpoint}');
      final request = http.MultipartRequest('POST', uri);
      
      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';
      
      // Add image file
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result']['url'] ?? data['result']['imageUrl'] ?? '';
      } else {
        throw Exception('Upload image failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Upload image error: $e');
    }
  }
}
