import '../models/roadmap_response_model.dart';
import '../models/generate_roadmap_request_model.dart';

/// Abstract remote data source for roadmap operations
abstract class RoadmapRemoteDataSource {
  /// Generate roadmap from AI service
  Future<RoadmapResponseModel> generateRoadmap({
    required GenerateRoadmapRequestModel request,
  });
}
