import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/course_repository.dart';
import '../entities/video_status.dart';

/// Use case for getting video status
class GetVideoStatusUseCase implements UseCase<VideoStatus, GetVideoStatusParams> {
  final CourseRepository repository;

  GetVideoStatusUseCase(this.repository);

  @override
  Future<Either<Failure, VideoStatus>> call(GetVideoStatusParams params) async {
    return await repository.getVideoStatus(params.videoId);
  }
}

/// Parameters for GetVideoStatusUseCase
class GetVideoStatusParams {
  final String videoId;

  const GetVideoStatusParams({
    required this.videoId,
  });
}

