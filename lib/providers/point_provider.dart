import 'package:flutter/foundation.dart';
import '../models/point_response.dart';
import '../services/point_service.dart';

class PointProvider extends ChangeNotifier {
  final PointService _pointService = PointService();
  
  // User points
  UserPointsResponse? _userPoints;
  UserPointsResponse? get userPoints => _userPoints;
  
  // Referral info
  ReferralResponse? _referralInfo;
  ReferralResponse? get referralInfo => _referralInfo;
  
  // Referral count
  ReferralCountResponse? _referralCount;
  ReferralCountResponse? get referralCount => _referralCount;
  
  // Invited users
  List<InvitedUserResponse> _invitedUsers = [];
  List<InvitedUserResponse> get invitedUsers => _invitedUsers;
  
  // Point transactions
  List<PointTransactionResponse> _pointTransactions = [];
  List<PointTransactionResponse> get pointTransactions => _pointTransactions;
  
  // Chart data
  PointChartResponse? _pointsChart;
  PointChartResponse? get pointsChart => _pointsChart;
  
  // Loading states
  bool _isLoadingPoints = false;
  bool _isLoadingReferral = false;
  bool _isLoadingInvitedUsers = false;
  bool _isLoadingTransactions = false;
  bool _isLoadingChart = false;
  
  bool get isLoadingPoints => _isLoadingPoints;
  bool get isLoadingReferral => _isLoadingReferral;
  bool get isLoadingInvitedUsers => _isLoadingInvitedUsers;
  bool get isLoadingTransactions => _isLoadingTransactions;
  bool get isLoadingChart => _isLoadingChart;
  
  // Error handling
  String? _error;
  String? get error => _error;
  
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Fetch user points balance
  Future<void> fetchUserPoints() async {
    _isLoadingPoints = true;
    _setError(null);
    notifyListeners();
    
    try {
      _userPoints = await _pointService.getUserPoints();
    } catch (e) {
      _setError('Không thể tải thông tin điểm: ${e.toString()}');
    } finally {
      _isLoadingPoints = false;
      notifyListeners();
    }
  }

  /// Fetch referral information
  Future<void> fetchReferralInfo() async {
    _isLoadingReferral = true;
    _setError(null);
    notifyListeners();
    
    try {
      _referralInfo = await _pointService.getReferralInfo();
      _referralCount = await _pointService.getReferralCount();
    } catch (e) {
      _setError('Không thể tải thông tin giới thiệu: ${e.toString()}');
    } finally {
      _isLoadingReferral = false;
      notifyListeners();
    }
  }

  /// Fetch invited users list
  Future<void> fetchInvitedUsers({int page = 0, int size = 20}) async {
    _isLoadingInvitedUsers = true;
    _setError(null);
    notifyListeners();
    
    try {
      final newUsers = await _pointService.getInvitedUsers(page: page, size: size);
      
      if (page == 0) {
        _invitedUsers = newUsers;
      } else {
        _invitedUsers.addAll(newUsers);
      }
    } catch (e) {
      _setError('Không thể tải danh sách người được mời: ${e.toString()}');
    } finally {
      _isLoadingInvitedUsers = false;
      notifyListeners();
    }
  }

  /// Fetch point transactions
  Future<void> fetchPointTransactions({int page = 0, int size = 20}) async {
    _isLoadingTransactions = true;
    _setError(null);
    notifyListeners();
    
    try {
      final newTransactions = await _pointService.getPointTransactions(page: page, size: size);
      
      if (page == 0) {
        _pointTransactions = newTransactions;
      } else {
        _pointTransactions.addAll(newTransactions);
      }
    } catch (e) {
      _setError('Không thể tải lịch sử giao dịch: ${e.toString()}');
    } finally {
      _isLoadingTransactions = false;
      notifyListeners();
    }
  }

  /// Fetch points chart data
  Future<void> fetchPointsChart() async {
    _isLoadingChart = true;
    _setError(null);
    notifyListeners();
    
    try {
      _pointsChart = await _pointService.getPointsChart();
    } catch (e) {
      _setError('Không thể tải biểu đồ điểm: ${e.toString()}');
    } finally {
      _isLoadingChart = false;
      notifyListeners();
    }
  }

  /// Withdraw points
  Future<bool> withdrawPoints({
    required int amount,
    String? bankAccount,
    String? bankName,
  }) async {
    try {
      final request = WithdrawPointsRequest(
        amount: amount,
        bankAccount: bankAccount,
        bankName: bankName,
      );
      
      final success = await _pointService.withdrawPoints(request);
      
      if (success) {
        // Refresh user points after withdrawal
        await fetchUserPoints();
        await fetchPointTransactions();
      }
      
      return success;
    } catch (e) {
      _setError('Không thể rút điểm: ${e.toString()}');
      return false;
    }
  }

  /// Set referral code
  Future<bool> setReferral(String referralCode) async {
    try {
      final success = await _pointService.setReferral(referralCode);
      
      if (success) {
        // Refresh referral info after setting
        await fetchReferralInfo();
      }
      
      return success;
    } catch (e) {
      _setError('Không thể thiết lập mã giới thiệu: ${e.toString()}');
      return false;
    }
  }

  /// Initialize all data for invite friends screen
  Future<void> initializeInviteFriendsData() async {
    await Future.wait([
      fetchUserPoints(),
      fetchReferralInfo(),
      fetchInvitedUsers(),
    ]);
  }

  /// Refresh all data
  Future<void> refreshAllData() async {
    await Future.wait([
      fetchUserPoints(),
      fetchReferralInfo(),
      fetchInvitedUsers(),
      fetchPointTransactions(),
      fetchPointsChart(),
    ]);
  }

  /// Clear all data (for logout)
  void clearData() {
    _userPoints = null;
    _referralInfo = null;
    _referralCount = null;
    _invitedUsers.clear();
    _pointTransactions.clear();
    _pointsChart = null;
    _error = null;
    notifyListeners();
  }
}