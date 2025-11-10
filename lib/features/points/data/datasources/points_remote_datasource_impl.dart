import 'package:flutter/foundation.dart';
import 'package:ftes/core/constants/app_constants.dart';
import 'package:ftes/core/error/exceptions.dart';
import 'package:ftes/core/network/api_client.dart';
import '../../domain/constants/points_constants.dart';
import '../models/invited_user_model.dart';
import '../models/point_transaction_model.dart';
import '../models/points_chart_model.dart';
import '../models/points_summary_model.dart';
import '../models/referral_info_model.dart';
import '../models/referral_stats_model.dart';
import '../models/withdraw_points_request_model.dart';
import 'points_remote_datasource.dart';

class PointsRemoteDataSourceImpl implements PointsRemoteDataSource {
  final ApiClient _apiClient;

  PointsRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<PointsSummaryModel> getPointsSummary() async {
    try {
      final response = await _apiClient.get(AppConstants.pointsUserEndpoint);
      if (response.statusCode != 200) {
        throw const ServerException(PointsConstants.errorLoadSummary);
      }
      final data = _unwrap(response.data);
      return PointsSummaryModel.fromJson(_ensureMap(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('${PointsConstants.errorLoadSummary}: $e');
    }
  }

  @override
  Future<List<PointTransactionModel>> getTransactions({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        AppConstants.pointsTransactionsEndpoint,
        queryParameters: {'page': '$page', 'size': '$size'},
      );
      if (response.statusCode != 200) {
        throw const ServerException(PointsConstants.errorLoadTransactions);
      }
      final data = _unwrap(response.data);
      final list = _extractList(data);
      return list
          .map((e) => PointTransactionModel.fromJson(_ensureMap(e)))
          .toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('${PointsConstants.errorLoadTransactions}: $e');
    }
  }

  @override
  Future<ReferralInfoModel> getReferralInfo() async {
    try {
      final response = await _apiClient.get(
        AppConstants.pointsReferralEndpoint,
      );
      if (response.statusCode != 200) {
        throw const ServerException(PointsConstants.errorLoadReferral);
      }
      final data = _unwrap(response.data);
      if (data is String) {
        return ReferralInfoModel(referralCode: data);
      }
      return ReferralInfoModel.fromJson(_ensureMap(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('${PointsConstants.errorLoadReferral}: $e');
    }
  }

  @override
  Future<ReferralStatsModel> getReferralStats() async {
    try {
      final response = await _apiClient.get(
        AppConstants.pointsReferralCountEndpoint,
      );
      if (response.statusCode != 200) {
        throw const ServerException(PointsConstants.errorLoadReferral);
      }
      final data = _unwrap(response.data);
      if (data is int) {
        return ReferralStatsModel(totalInvited: data);
      }
      return ReferralStatsModel.fromJson(_ensureMap(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('${PointsConstants.errorLoadReferral}: $e');
    }
  }

  @override
  Future<List<InvitedUserModel>> getInvitedUsers({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        AppConstants.pointsInvitedUsersEndpoint,
        queryParameters: {'page': '$page', 'size': '$size'},
      );
      if (response.statusCode != 200) {
        throw const ServerException(PointsConstants.errorLoadInvitedUsers);
      }
      final data = _unwrap(response.data);
      final list = _extractList(data);
      return list.map((e) => InvitedUserModel.fromJson(_ensureMap(e))).toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('${PointsConstants.errorLoadInvitedUsers}: $e');
    }
  }

  @override
  Future<PointsChartModel> getPointsChart() async {
    try {
      final response = await _apiClient.get(AppConstants.pointsChartEndpoint);
      if (response.statusCode != 200) {
        throw const ServerException(PointsConstants.errorLoadChart);
      }
      final data = _unwrap(response.data);
      return PointsChartModel.fromJson(_ensureMap(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('${PointsConstants.errorLoadChart}: $e');
    }
  }

  @override
  Future<bool> withdrawPoints(WithdrawPointsRequestModel command) async {
    try {
      final response = await _apiClient.post(
        AppConstants.pointsWithdrawEndpoint,
        data: command.toJson(),
      );
      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('${PointsConstants.errorWithdraw}: $e');
    }
  }

  @override
  Future<bool> setReferral(String referralCode) async {
    try {
      final response = await _apiClient.post(
        AppConstants.pointsSetReferralEndpoint,
        data: {'referralCode': referralCode},
      );
      return response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('${PointsConstants.errorSetReferral}: $e');
    }
  }

  dynamic _unwrap(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return raw['result'] ?? raw['data'] ?? raw;
    }
    return raw;
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic> && data['data'] is List) {
      return data['data'] as List<dynamic>;
    }
    if (data == null) return const [];
    throw const ServerException(PointsConstants.errorUnexpectedFormat);
  }

  Map<String, dynamic> _ensureMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw const ServerException(PointsConstants.errorUnexpectedFormat);
  }
}
