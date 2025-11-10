import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/invited_user.dart';
import '../../domain/entities/referral_info.dart';
import 'invited_user_model.dart';

part 'referral_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReferralInfoModel {
  final String? referralCode;
  final int? totalReferrals;
  final int? totalEarnings;
  final List<InvitedUserModel>? invitedUsersJson;

  factory ReferralInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralInfoModelToJson(this);

  ReferralInfoModel({
    this.referralCode,
    this.totalReferrals,
    this.totalEarnings,
    this.invitedUsersJson,
  });

  ReferralInfo toEntity() => ReferralInfo(
    referralCode: referralCode ?? '',
    totalReferrals: totalReferrals ?? 0,
    totalEarnings: totalEarnings ?? 0,
    invitedUsers: (invitedUsersJson ?? const [])
        .map((user) => user.toEntity())
        .toList(),
  );
}
