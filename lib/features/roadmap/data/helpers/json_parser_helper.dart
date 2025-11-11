import '../models/roadmap_response_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/constants/roadmap_constants.dart';

/// Parse roadmap response JSON in isolate
RoadmapResponseModel parseRoadmapResponseJson(Map<String, dynamic> json) {
  try {
    return RoadmapResponseModel.fromJson(json);
  } on FormatException catch (_) {
    throw ValidationException(RoadmapConstants.errorInvalidData);
  } on TypeError catch (_) {
    throw ValidationException(RoadmapConstants.errorInvalidData);
  } catch (e) {
    throw ServerException('${RoadmapConstants.errorGeneratingRoadmap}: $e');
  }
}
