import '../models/invited_user_model.dart';
import '../models/point_transaction_model.dart';
import '../models/points_chart_model.dart';
import '../models/points_summary_model.dart';
import '../models/referral_info_model.dart';
import '../models/referral_stats_model.dart';
import '../models/withdraw_points_request_model.dart';

abstract class PointsRemoteDataSource {
  Future<PointsSummaryModel> getPointsSummary();
  Future<List<PointTransactionModel>> getTransactions({int page, int size});
  Future<ReferralInfoModel> getReferralInfo();
  Future<ReferralStatsModel> getReferralStats();
  Future<List<InvitedUserModel>> getInvitedUsers({int page, int size});
  Future<PointsChartModel> getPointsChart();
  Future<bool> withdrawPoints(WithdrawPointsRequestModel command);
  Future<bool> setReferral(String referralCode);
}
