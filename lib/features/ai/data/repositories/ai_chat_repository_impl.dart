import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/video_knowledge.dart';
import '../../domain/repositories/ai_chat_repository.dart';
import '../../domain/constants/ai_constants.dart';
import '../datasources/ai_chat_remote_datasource.dart';
import '../datasources/ai_chat_local_datasource.dart';

/// Repository implementation for AI Chat feature with cache-first strategy
class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteDataSource remoteDataSource;
  final AiChatLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AiChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, VideoKnowledge>> checkVideoKnowledge(String videoId) async {
    // 1. Try cache first (even offline)
    final cached = await localDataSource.getCachedVideoKnowledge(
      videoId,
      AiConstants.cacheVideoKnowledgeTTL,
    );
    if (cached != null) {
      return Right(cached);
    }

    // 2. Check network
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    // 3. Fetch from network
    try {
      final knowledge = await remoteDataSource.checkVideoKnowledge(videoId);
      
      // 4. Cache for next time (async, don't block)
      unawaited(
        localDataSource.cacheVideoKnowledge(
          videoId,
          knowledge,
          AiConstants.cacheVideoKnowledgeTTL,
        ).catchError((_) {}),
      );
      
      return Right(knowledge);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AiChatMessage>> sendMessage({
    required String message,
    required String videoId,
    required String lessonTitle,
    required String sessionId,
    required String userId,
  }) async {
    // Check network
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final aiMessage = await remoteDataSource.sendMessage(
        message: message,
        videoId: videoId,
        lessonTitle: lessonTitle,
        sessionId: sessionId,
      );
      
      // Cache message (async, don't block)
      // Note: We'll update the full message list in ViewModel
      unawaited(
        _updateCachedMessages(sessionId, aiMessage).catchError((_) {}),
      );
      
      return Right(aiMessage);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  /// Update cached messages for a session
  Future<void> _updateCachedMessages(
    String sessionId,
    AiChatMessage newMessage,
  ) async {
    final cached = await localDataSource.getCachedMessages(sessionId);
    final updated = [
      ...?cached,
      newMessage,
    ];
    await localDataSource.cacheMessages(sessionId, updated);
  }
}

