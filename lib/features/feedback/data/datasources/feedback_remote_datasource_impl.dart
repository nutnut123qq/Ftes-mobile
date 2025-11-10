import 'package:flutter/foundation.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/error/exceptions.dart';
import 'package:ftes/core/network/api_client.dart';
import '../../domain/constants/feedback_constants.dart';
import '../helpers/feedback_json_parser_helper.dart';
import '../models/create_feedback_request_model.dart';
import '../models/feedback_model.dart';
import '../models/paginated_feedback_model.dart';
import '../models/update_feedback_request_model.dart';
import 'feedback_remote_datasource.dart';

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final ApiClient _apiClient;

  FeedbackRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<PaginatedFeedbackModel> getFeedbacksByCourse({
    required int courseId,
    int page = FeedbackConstants.defaultPageNumber,
    int size = FeedbackConstants.defaultPageSize,
  }) async {
    try {
      final response = await _apiClient.get(
        '${AppConstants.feedbacksByCourseEndpoint}/$courseId',
        queryParameters: {'page': page.toString(), 'size': size.toString()},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          '${FeedbackConstants.errorLoadFeedbacks}: ${response.statusCode}',
        );
      }

      final payload = _extractPayload(response.data);
      final rawList = _extractContentList(payload);

      final feedbackModels = rawList.length > FeedbackConstants.computeThreshold
          ? await compute(parseFeedbackListJson, rawList)
          : parseFeedbackListJson(rawList);

      return PaginatedFeedbackModel(
        content: feedbackModels,
        totalElements:
            _toInt(payload['totalElements']) ?? feedbackModels.length,
        totalPages: _toInt(payload['totalPages']) ?? 1,
        currentPage:
            _toInt(payload['number'] ?? payload['currentPage']) ??
            FeedbackConstants.defaultPageNumber,
        pageSize:
            _toInt(payload['size'] ?? payload['pageSize']) ??
            feedbackModels.length,
        isFirst: payload['first'] as bool? ?? (page == 0),
        isLast:
            payload['last'] as bool? ??
            (feedbackModels.length < size || feedbackModels.isEmpty),
      );
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${FeedbackConstants.errorLoadFeedbacks}: $e');
    }
  }

  @override
  Future<FeedbackModel> createFeedback(
    CreateFeedbackRequestModel request,
  ) async {
    try {
      final response = await _apiClient.post(
        AppConstants.feedbacksEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          '${FeedbackConstants.errorCreateFeedback}: ${response.statusCode}',
        );
      }

      final payload = _extractPayload(response.data);
      return FeedbackModel.fromJson(_ensureMap(payload));
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${FeedbackConstants.errorCreateFeedback}: $e');
    }
  }

  @override
  Future<FeedbackModel> updateFeedback(
    int feedbackId,
    UpdateFeedbackRequestModel request,
  ) async {
    try {
      final response = await _apiClient.put(
        '${AppConstants.feedbacksEndpoint}/$feedbackId',
        data: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw ServerException(
          '${FeedbackConstants.errorUpdateFeedback}: ${response.statusCode}',
        );
      }

      final payload = _extractPayload(response.data);
      return FeedbackModel.fromJson(_ensureMap(payload));
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${FeedbackConstants.errorUpdateFeedback}: $e');
    }
  }

  @override
  Future<void> deleteFeedback(int feedbackId) async {
    try {
      final response = await _apiClient.delete(
        '${AppConstants.feedbacksEndpoint}/$feedbackId',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          '${FeedbackConstants.errorDeleteFeedback}: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('${FeedbackConstants.errorDeleteFeedback}: $e');
    }
  }

  Map<String, dynamic> _extractPayload(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      if (raw['result'] is Map<String, dynamic>) {
        return raw['result'] as Map<String, dynamic>;
      }
      if (raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }

    if (raw is List) {
      return {
        'content': raw,
        'totalElements': raw.length,
        'totalPages': 1,
        'number': 0,
        'size': raw.length,
        'first': true,
        'last': true,
      };
    }

    throw const ServerException(FeedbackConstants.errorUnexpectedFormat);
  }

  List<dynamic> _extractContentList(Map<String, dynamic> payload) {
    final content = payload['content'] ?? payload['data'] ?? payload['result'];
    if (content is List) {
      return content;
    }
    if (content == null) {
      return const [];
    }
    throw const ServerException(FeedbackConstants.errorUnexpectedFormat);
  }

  Map<String, dynamic> _ensureMap(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      if (payload.containsKey('result') &&
          payload['result'] is Map<String, dynamic>) {
        return payload['result'] as Map<String, dynamic>;
      }
      return payload;
    }
    throw const ServerException(FeedbackConstants.errorUnexpectedFormat);
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
