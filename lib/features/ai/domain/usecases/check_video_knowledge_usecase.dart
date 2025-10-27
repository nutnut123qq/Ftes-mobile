import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/video_knowledge.dart';
import '../repositories/ai_chat_repository.dart';

/// Use case to check if video has knowledge
class CheckVideoKnowledgeUseCase implements UseCase<VideoKnowledge, String> {
  final AiChatRepository repository;

  CheckVideoKnowledgeUseCase(this.repository);

  @override
  Future<Either<Failure, VideoKnowledge>> call(String videoId) async {
    return await repository.checkVideoKnowledge(videoId);
  }
}

