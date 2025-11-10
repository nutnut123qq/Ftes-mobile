import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import 'package:ftes/core/usecases/usecase.dart';
import '../../domain/constants/points_constants.dart';
import '../../domain/entities/invited_user.dart';
import '../../domain/entities/point_transaction.dart';
import '../../domain/entities/points_chart.dart';
import '../../domain/entities/points_summary.dart';
import '../../domain/entities/referral_info.dart';
import '../../domain/entities/referral_stats.dart';
import '../../domain/entities/set_referral_command.dart';
import '../../domain/entities/withdraw_points_command.dart';
import '../../domain/usecases/points_usecases.dart';

/// ViewModel thay thế PointProvider với API tương thích để hạn chế thay đổi màn hình
class PointsViewModel extends ChangeNotifier {
  final GetPointsSummaryUseCase _getPointsSummaryUseCase;
  final GetReferralInfoUseCase _getReferralInfoUseCase;
  final GetReferralStatsUseCase _getReferralStatsUseCase;
  final GetInvitedUsersUseCase _getInvitedUsersUseCase;
  final GetPointTransactionsUseCase _getPointTransactionsUseCase;
  final GetPointsChartUseCase _getPointsChartUseCase;
  final WithdrawPointsUseCase _withdrawPointsUseCase;
  final SetReferralUseCase _setReferralUseCase;

  PointsViewModel({
    required GetPointsSummaryUseCase getPointsSummaryUseCase,
    required GetReferralInfoUseCase getReferralInfoUseCase,
    required GetReferralStatsUseCase getReferralStatsUseCase,
    required GetInvitedUsersUseCase getInvitedUsersUseCase,
    required GetPointTransactionsUseCase getPointTransactionsUseCase,
    required GetPointsChartUseCase getPointsChartUseCase,
    required WithdrawPointsUseCase withdrawPointsUseCase,
    required SetReferralUseCase setReferralUseCase,
  }) : _getPointsSummaryUseCase = getPointsSummaryUseCase,
       _getReferralInfoUseCase = getReferralInfoUseCase,
       _getReferralStatsUseCase = getReferralStatsUseCase,
       _getInvitedUsersUseCase = getInvitedUsersUseCase,
       _getPointTransactionsUseCase = getPointTransactionsUseCase,
       _getPointsChartUseCase = getPointsChartUseCase,
       _withdrawPointsUseCase = withdrawPointsUseCase,
       _setReferralUseCase = setReferralUseCase;

  // State tương thích với PointProvider
  PointsSummary? _userPoints;
  PointsSummary? get userPoints => _userPoints;

  ReferralInfo? _referralInfo;
  ReferralInfo? get referralInfo => _referralInfo;

  ReferralStats? _referralCount;
  ReferralStats? get referralCount => _referralCount;

  List<InvitedUser> _invitedUsers = [];
  List<InvitedUser> get invitedUsers => _invitedUsers;

  List<PointTransaction> _pointTransactions = [];
  List<PointTransaction> get pointTransactions => _pointTransactions;

  PointsChart? _pointsChart;
  PointsChart? get pointsChart => _pointsChart;

  bool _isLoadingPoints = false;
  bool _isLoadingReferral = false;
  bool _isLoadingInvitedUsers = false;
  bool _isLoadingTransactions = false;
  bool _isLoadingChart = false;
  String? _error;

  bool get isLoadingPoints => _isLoadingPoints;
  bool get isLoadingReferral => _isLoadingReferral;
  bool get isLoadingInvitedUsers => _isLoadingInvitedUsers;
  bool get isLoadingTransactions => _isLoadingTransactions;
  bool get isLoadingChart => _isLoadingChart;
  String? get error => _error;

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  Future<void> fetchUserPoints() async {
    _isLoadingPoints = true;
    _setError(null);
    notifyListeners();
    final result = await _getPointsSummaryUseCase(NoParams());
    result.fold(
      (failure) =>
          _setError(_mapFailure(failure, PointsConstants.errorLoadSummary)),
      (summary) {
        _userPoints = summary;
        notifyListeners();
      },
    );
    _isLoadingPoints = false;
    notifyListeners();
  }

  Future<void> fetchReferralInfo() async {
    _isLoadingReferral = true;
    _setError(null);
    notifyListeners();
    final info = await _getReferralInfoUseCase(NoParams());
    final stats = await _getReferralStatsUseCase(NoParams());
    info.fold(
      (failure) =>
          _setError(_mapFailure(failure, PointsConstants.errorLoadReferral)),
      (data) {
        _referralInfo = data;
      },
    );
    stats.fold(
      (failure) =>
          _setError(_mapFailure(failure, PointsConstants.errorLoadReferral)),
      (data) {
        _referralCount = data;
      },
    );
    _isLoadingReferral = false;
    notifyListeners();
  }

  Future<void> fetchInvitedUsers({int page = 0, int size = 20}) async {
    _isLoadingInvitedUsers = true;
    _setError(null);
    notifyListeners();
    final result = await _getInvitedUsersUseCase(
      GetInvitedUsersParams(page: page, size: size),
    );
    result.fold(
      (failure) => _setError(
        _mapFailure(failure, PointsConstants.errorLoadInvitedUsers),
      ),
      (list) {
        if (page == 0) {
          _invitedUsers = list;
        } else {
          _invitedUsers.addAll(list);
        }
        notifyListeners();
      },
    );
    _isLoadingInvitedUsers = false;
    notifyListeners();
  }

  Future<void> fetchPointTransactions({int page = 0, int size = 20}) async {
    _isLoadingTransactions = true;
    _setError(null);
    notifyListeners();
    final result = await _getPointTransactionsUseCase(
      GetPointTransactionsParams(page: page, size: size),
    );
    result.fold(
      (failure) => _setError(
        _mapFailure(failure, PointsConstants.errorLoadTransactions),
      ),
      (list) {
        if (page == 0) {
          _pointTransactions = list;
        } else {
          _pointTransactions.addAll(list);
        }
        notifyListeners();
      },
    );
    _isLoadingTransactions = false;
    notifyListeners();
  }

  Future<void> fetchPointsChart() async {
    _isLoadingChart = true;
    _setError(null);
    notifyListeners();
    final result = await _getPointsChartUseCase(NoParams());
    result.fold(
      (failure) =>
          _setError(_mapFailure(failure, PointsConstants.errorLoadChart)),
      (chart) {
        _pointsChart = chart;
        notifyListeners();
      },
    );
    _isLoadingChart = false;
    notifyListeners();
  }

  Future<bool> withdrawPoints({
    required int amount,
    String? bankAccount,
    String? bankName,
  }) async {
    final result = await _withdrawPointsUseCase(
      WithdrawPointsCommand(
        amount: amount,
        bankAccount: bankAccount,
        bankName: bankName,
      ),
    );
    return await result.fold(
      (failure) {
        _setError(_mapFailure(failure, PointsConstants.errorWithdraw));
        return Future.value(false);
      },
      (ok) async {
        if (ok) {
          await fetchUserPoints();
          await fetchPointTransactions();
        }
        return ok;
      },
    );
  }

  Future<bool> setReferral(String referralCode) async {
    final result = await _setReferralUseCase(
      SetReferralCommand(referralCode: referralCode),
    );
    return result.fold(
      (failure) {
        _setError(_mapFailure(failure, PointsConstants.errorSetReferral));
        return false;
      },
      (ok) async {
        if (ok) {
          await fetchReferralInfo();
        }
        return ok;
      },
    );
  }

  Future<void> initializeInviteFriendsData() async {
    await Future.wait([
      fetchUserPoints(),
      fetchReferralInfo(),
      fetchInvitedUsers(),
    ]);
  }

  Future<void> refreshAllData() async {
    await Future.wait([
      fetchUserPoints(),
      fetchReferralInfo(),
      fetchInvitedUsers(),
      fetchPointTransactions(),
      fetchPointsChart(),
    ]);
  }

  void clearData() {
    _userPoints = null;
    _referralInfo = null;
    _referralCount = null;
    _invitedUsers.clear();
    _pointTransactions.clear();
    _pointsChart = null;
    _error = null;
    _isLoadingPoints = false;
    _isLoadingReferral = false;
    _isLoadingInvitedUsers = false;
    _isLoadingTransactions = false;
    _isLoadingChart = false;
    notifyListeners();
  }

  String _mapFailure(Failure failure, String fallback) {
    return failure.message.isNotEmpty ? failure.message : fallback;
  }
}
