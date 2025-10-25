import 'package:dartz/dartz.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:ftes/core/error/exceptions.dart';
import 'package:ftes/core/error/failures.dart';
import 'package:ftes/core/network/network_info.dart';
import 'package:ftes/core/config/env_config.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final authResponse = await remoteDataSource.login(email, password);
        await localDataSource.cacheAccessToken(authResponse.accessToken);
        
        // Cache userId if available in response
        if (authResponse.userId != null && authResponse.userId!.isNotEmpty) {
          await localDataSource.cacheUserId(authResponse.userId!);
        }
        
        // Since API doesn't return user info in login response, we'll fetch it separately
        // For now, return a placeholder user
        return Right(UserModel(id: authResponse.userId ?? 'temp', email: email));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message)); // AuthException can be treated as a specific ServerFailure
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        // Step 1: Get authorization code from Google OAuth
        final authCode = await _getGoogleAuthCode();
        if (authCode == null) {
          return const Left(ServerFailure('Google authentication cancelled'));
        }
        
        // Step 2: Exchange code with backend
        final authResponse = await remoteDataSource.loginWithGoogle(authCode, isAdmin: false);
        await localDataSource.cacheAccessToken(authResponse.accessToken);
        
        // Step 3: Fetch user info
        final userInfo = await remoteDataSource.getMyInfo();
        await localDataSource.cacheUser(userInfo);
        
        return Right(userInfo);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  Future<String?> _getGoogleAuthCode() async {
    try {
      final googleAuthUrl = Uri.https('accounts.google.com', '/o/oauth2/auth', {
        'client_id': EnvConfig.googleClientId,
        'redirect_uri': EnvConfig.redirectUri,
        'response_type': 'code',
        'scope': 'openid email profile',
      });
      
      final result = await FlutterWebAuth.authenticate(
        url: googleAuthUrl.toString(),
        callbackUrlScheme: 'http',
      );
      
      final code = Uri.parse(result).queryParameters['code'];
      return code;
    } catch (e) {
      print('❌ Google OAuth error: $e');
      return null;
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      if (user != null) {
        return Right(user);
      }
      // Optionally try to fetch from remote if not in cache and online
      if (await networkInfo.isConnected) {
        final remoteUser = await remoteDataSource.getMyInfo();
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      }
      return const Left(CacheFailure('No cached user found'));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAuthData();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> register(String username, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.register(username, email, password);
        if (response.success && response.result != null) {
          return Right(response.result!);
        } else {
          return Left(ServerFailure(response.messageDTO?.message ?? 'Registration failed'));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyEmailOTP(String email, int otp) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyEmailOTP(email, otp);
        if (response.success && response.result != null) {
          // Cache the access token
          await localDataSource.cacheAccessToken(response.result!.accessToken);
          return Right(response.result!.accessToken);
        } else {
          return Left(ServerFailure(response.messageDTO?.message ?? 'OTP verification failed'));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationCode(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resendVerificationCode(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> sendForgotPasswordEmail(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendForgotPasswordEmail(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyForgotPasswordOTP(String email, int otp) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyForgotPasswordOTP(email, otp);
        return Right(response.result.accessToken);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String password, String accessToken) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(password, accessToken);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}