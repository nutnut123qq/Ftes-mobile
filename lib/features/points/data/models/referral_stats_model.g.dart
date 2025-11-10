// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferralStatsModel _$ReferralStatsModelFromJson(Map<String, dynamic> json) =>
    ReferralStatsModel(
      totalInvited: (json['totalInvited'] as num?)?.toInt(),
      totalActive: (json['totalActive'] as num?)?.toInt(),
      totalInactive: (json['totalInactive'] as num?)?.toInt(),
      totalEarnings: (json['totalEarnings'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReferralStatsModelToJson(ReferralStatsModel instance) =>
    <String, dynamic>{
      'totalInvited': instance.totalInvited,
      'totalActive': instance.totalActive,
      'totalInactive': instance.totalInactive,
      'totalEarnings': instance.totalEarnings,
    };
