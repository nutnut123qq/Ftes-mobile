import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/video_knowledge.dart';
import '../../domain/repositories/ai_chat_repository.dart';
import '../datasources/ai_chat_remote_datasource.dart';

/// Repository implementation for AI Chat feature
class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AiChatRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, VideoKnowledge>> checkVideoKnowledge(String videoId) async {
    if (await networkInfo.isConnected) {
      try {
        final knowledge = await remoteDataSource.checkVideoKnowledge(videoId);
        return Right(knowledge);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AiChatMessage>> sendMessage({
    required String message,
    required String lessonId,
    required String lessonTitle,
    required String sessionId,
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final aiMessage = await remoteDataSource.sendMessage(
          message: message,
          lessonId: lessonId,
          lessonTitle: lessonTitle,
          sessionId: sessionId,
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
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}

