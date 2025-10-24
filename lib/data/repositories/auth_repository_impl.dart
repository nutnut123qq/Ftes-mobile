import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
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
        // Since API doesn't return user info in login response, we'll fetch it separately
        // For now, return a placeholder user
        return Right(UserModel(id: 'temp', email: email));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message)); // AuthException can be treated as a specific ServerFailure
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final authResponse = await remoteDataSource.loginWithGoogle();
        await localDataSource.cacheAccessToken(authResponse.accessToken);
        // Since API doesn't return user info in login response, we'll fetch it separately
        // For now, return a placeholder user
        return Right(UserModel(id: 'temp', email: 'google@user.com'));
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
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
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}