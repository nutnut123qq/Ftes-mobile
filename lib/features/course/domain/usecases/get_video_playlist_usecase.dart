import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/course_repository.dart';
import '../entities/video_playlist.dart';

/// Use case for getting video playlist
class GetVideoPlaylistUseCase implements UseCase<VideoPlaylist, GetVideoPlaylistParams> {
  final CourseRepository repository;

  GetVideoPlaylistUseCase(this.repository);

  @override
  Future<Either<Failure, VideoPlaylist>> call(GetVideoPlaylistParams params) async {
    return await repository.getVideoPlaylist(params.videoId, params.presign);
  }
}

/// Parameters for GetVideoPlaylistUseCase
class GetVideoPlaylistParams {
  final String videoId;
  final bool presign;

  const GetVideoPlaylistParams({
    required this.videoId,
    this.presign = false,
  });
}

