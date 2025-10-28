import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/roadmap.dart';
import '../repositories/roadmap_repository.dart';

/// Use case for generating roadmap
class GenerateRoadmapUseCase implements UseCase<Roadmap, GenerateRoadmapParams> {
  final RoadmapRepository repository;

  GenerateRoadmapUseCase(this.repository);

  @override
  Future<Either<Failure, Roadmap>> call(GenerateRoadmapParams params) async {
    return await repository.generateRoadmap(params: params);
  }
}
