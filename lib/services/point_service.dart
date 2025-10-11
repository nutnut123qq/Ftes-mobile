import 'dart:convert';
import '../models/point_response.dart';
import 'http_client.dart';

class PointService {
  final HttpClient _http = HttpClient();

  /// Get user points balance
  Future<UserPointsResponse> getUserPoints() async {
    try {
      final response = await _http.get('/api/points/user');
      final responseBody = jsonDecode(response.body);
      
      // Handle different response formats
      final data = responseBody['result'] ?? responseBody['data'] ?? responseBody;
      
      return UserPointsResponse.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get user points: $e');
    }
  }

  /// Get point transaction history
  Future<List<PointTransactionResponse>> getPointTransactions({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _http.get(
        '/api/points/transactions',
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      );
      final responseBody = jsonDecode(response.body);
      
      // Handle different response formats
      final data = responseBody['result'] ?? responseBody['data'] ?? responseBody;
      
      if (data is List) {
        return data.map((item) => PointTransactionResponse.fromJson(item)).toList();
      } else if (data is Map && data['data'] != null) {
        final List<dynamic> transactionsList = data['data'];
        return transactionsList.map((item) => PointTransactionResponse.fromJson(item)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get point transactions: $e');
    }
  }

  /// Get referral information
  Future<ReferralResponse> getReferralInfo() async {
    try {
      final response = await _http.get('/api/points/referral');
      final responseBody = jsonDecode(response.body);
      
      // Handle different response formats
      final data = responseBody['result'] ?? responseBody['data'] ?? responseBody;
      
      return ReferralResponse.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get referral info: $e');
    }
  }

  /// Get referral count statistics
  Future<ReferralCountResponse> getReferralCount() async {
    try {
      final response = await _http.get('/api/points/referral/count');
      final responseBody = jsonDecode(response.body);
      
      // Handle different response formats
      final data = responseBody['result'] ?? responseBody['data'] ?? responseBody;
      
      return ReferralCountResponse.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get referral count: $e');
    }
  }

  /// Get list of invited users
  Future<List<InvitedUserResponse>> getInvitedUsers({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _http.get(
        '/api/points/invited',
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      );
      final responseBody = jsonDecode(response.body);
      
      // Handle different response formats
      final data = responseBody['result'] ?? responseBody['data'] ?? responseBody;
      
      if (data is List) {
        return data.map((item) => InvitedUserResponse.fromJson(item)).toList();
      } else if (data is Map && data['data'] != null) {
        final List<dynamic> usersList = data['data'];
        return usersList.map((item) => InvitedUserResponse.fromJson(item)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get invited users: $e');
    }
  }

  /// Get points chart data
  Future<PointChartResponse> getPointsChart() async {
    try {
      final response = await _http.get('/api/points/chart');
      final responseBody = jsonDecode(response.body);
      
      // Handle different response formats
      final data = responseBody['result'] ?? responseBody['data'] ?? responseBody;
      
      return PointChartResponse.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get points chart: $e');
    }
  }

  /// Withdraw points
  Future<bool> withdrawPoints(WithdrawPointsRequest request) async {
    try {
      await _http.post(
        '/api/points/withdraw',
        body: request.toJson(),
      );
      return true;
    } catch (e) {
      throw Exception('Failed to withdraw points: $e');
    }
  }

  /// Set referral code
  Future<bool> setReferral(String referralCode) async {
    try {
      await _http.post(
        '/api/points/set-referral',
        body: SetReferralRequest(referralCode: referralCode).toJson(),
      );
      return true;
    } catch (e) {
      throw Exception('Failed to set referral: $e');
    }
  }
}