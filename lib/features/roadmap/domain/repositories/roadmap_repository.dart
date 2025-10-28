import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/roadmap.dart';

/// Abstract repository interface for roadmap operations
abstract class RoadmapRepository {
  /// Generate roadmap based on user parameters
  Future<Either<Failure, Roadmap>> generateRoadmap({
    required GenerateRoadmapParams params,
  });
}

/// Parameters for generating roadmap
class GenerateRoadmapParams {
  final String specialization;
  final List<String> currentSkills;
  final int term;

  const GenerateRoadmapParams({
    required this.specialization,
    required this.currentSkills,
    required this.term,
  });
}
