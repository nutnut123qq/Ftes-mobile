// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferralInfoModel _$ReferralInfoModelFromJson(Map<String, dynamic> json) =>
    ReferralInfoModel(
      referralCode: json['referralCode'] as String?,
      totalReferrals: (json['totalReferrals'] as num?)?.toInt(),
      totalEarnings: (json['totalEarnings'] as num?)?.toInt(),
      invitedUsersJson: (json['invitedUsersJson'] as List<dynamic>?)
          ?.map((e) => InvitedUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReferralInfoModelToJson(ReferralInfoModel instance) =>
    <String, dynamic>{
      'referralCode': instance.referralCode,
      'totalReferrals': instance.totalReferrals,
      'totalEarnings': instance.totalEarnings,
      'invitedUsersJson': instance.invitedUsersJson
          ?.map((e) => e.toJson())
          .toList(),
    };
