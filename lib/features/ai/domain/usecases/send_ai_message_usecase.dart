import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/ai_chat_message.dart';
import '../repositories/ai_chat_repository.dart';

/// Use case to send a message to AI and receive response
class SendAiMessageUseCase implements UseCase<AiChatMessage, SendAiMessageParams> {
  final AiChatRepository repository;

  SendAiMessageUseCase(this.repository);

  @override
  Future<Either<Failure, AiChatMessage>> call(SendAiMessageParams params) async {
    return await repository.sendMessage(
      message: params.message,
      videoId: params.videoId,
      lessonTitle: params.lessonTitle,
      sessionId: params.sessionId,
      userId: params.userId,
    );
  }
}

/// Parameters for SendAiMessageUseCase
class SendAiMessageParams {
  final String message;
  final String videoId; // Video ID for HLS streaming (e.g., "video_ab83bee3-b55")
  final String lessonTitle;
  final String sessionId;
  final String userId;

  const SendAiMessageParams({
    required this.message,
    required this.videoId,
    required this.lessonTitle,
    required this.sessionId,
    required this.userId,
  });
}

