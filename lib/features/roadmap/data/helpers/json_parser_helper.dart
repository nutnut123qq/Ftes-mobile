import '../models/roadmap_response_model.dart';

/// Parse roadmap response JSON in isolate
RoadmapResponseModel parseRoadmapResponseJson(Map<String, dynamic> json) {
  try {
    return RoadmapResponseModel.fromJson(json);
  } catch (e) {
    rethrow;
  }
}
