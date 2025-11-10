import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/referral_stats.dart';

part 'referral_stats_model.g.dart';

@JsonSerializable()
class ReferralStatsModel extends ReferralStats {
  const ReferralStatsModel({
    int? totalInvited,
    int? totalActive,
    int? totalInactive,
    int? totalEarnings,
  }) : super(
         totalInvited: totalInvited ?? 0,
         totalActive: totalActive ?? 0,
         totalInactive: totalInactive ?? 0,
         totalEarnings: totalEarnings ?? 0,
       );

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralStatsModelToJson(this);

  ReferralStats toEntity() => ReferralStats(
    totalInvited: totalInvited,
    totalActive: totalActive,
    totalInactive: totalInactive,
    totalEarnings: totalEarnings,
  );
}
