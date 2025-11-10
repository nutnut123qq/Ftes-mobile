import 'package:flutter/foundation.dart';
import '../../../../core/network/ai_api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/roadmap_response_model.dart';
import '../models/generate_roadmap_request_model.dart';
import '../helpers/json_parser_helper.dart';
import '../../domain/constants/roadmap_constants.dart';
import 'roadmap_remote_datasource.dart';

/// Remote data source implementation for Roadmap feature
class RoadmapRemoteDataSourceImpl implements RoadmapRemoteDataSource {
  final AiApiClient _aiApiClient;

  RoadmapRemoteDataSourceImpl({required AiApiClient aiApiClient})
      : _aiApiClient = aiApiClient;

  @override
  Future<RoadmapResponseModel> generateRoadmap({
    required GenerateRoadmapRequestModel request,
  }) async {
    try {
      final response = await _aiApiClient.post(
        AppConstants.generateRoadmapEndpoint,
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        final success = response.data['success'];
        if (success == true) {
          // Use compute() isolate for parsing if response is large
          if (response.data.toString().length > RoadmapConstants.computeThreshold * 100) {
            return await compute<Map<String, dynamic>, RoadmapResponseModel>(parseRoadmapResponseJson, response.data);
          } else {
            return parseRoadmapResponseJson(response.data);
          }
        } else {
          throw ServerException(response.data['message'] ?? RoadmapConstants.errorGeneratingRoadmap);
        }
      } else {
        throw ServerException(response.data['message'] ?? RoadmapConstants.errorGeneratingRoadmap);
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${RoadmapConstants.errorGeneratingRoadmap}: ${e.toString()}');
    }
  }
}
