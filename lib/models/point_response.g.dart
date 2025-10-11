// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPointsResponse _$UserPointsResponseFromJson(Map<String, dynamic> json) =>
    UserPointsResponse(
      totalPoints: (json['totalPoints'] as num?)?.toInt(),
      availablePoints: (json['availablePoints'] as num?)?.toInt(),
      lockedPoints: (json['lockedPoints'] as num?)?.toInt(),
      withdrawnPoints: (json['withdrawnPoints'] as num?)?.toInt(),
      lastUpdated: json['lastUpdated'] as String?,
    );

Map<String, dynamic> _$UserPointsResponseToJson(UserPointsResponse instance) =>
    <String, dynamic>{
      'totalPoints': instance.totalPoints,
      'availablePoints': instance.availablePoints,
      'lockedPoints': instance.lockedPoints,
      'withdrawnPoints': instance.withdrawnPoints,
      'lastUpdated': instance.lastUpdated,
    };

PointTransactionResponse _$PointTransactionResponseFromJson(
  Map<String, dynamic> json,
) => PointTransactionResponse(
  id: json['id'] as String?,
  type: json['type'] as String?,
  amount: (json['amount'] as num?)?.toInt(),
  description: json['description'] as String?,
  status: json['status'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$PointTransactionResponseToJson(
  PointTransactionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'amount': instance.amount,
  'description': instance.description,
  'status': instance.status,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

ReferralResponse _$ReferralResponseFromJson(Map<String, dynamic> json) =>
    ReferralResponse(
      referralCode: json['referralCode'] as String?,
      totalReferrals: (json['totalReferrals'] as num?)?.toInt(),
      totalEarnings: (json['totalEarnings'] as num?)?.toInt(),
      invitedUsers: (json['invitedUsers'] as List<dynamic>?)
          ?.map((e) => InvitedUserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReferralResponseToJson(ReferralResponse instance) =>
    <String, dynamic>{
      'referralCode': instance.referralCode,
      'totalReferrals': instance.totalReferrals,
      'totalEarnings': instance.totalEarnings,
      'invitedUsers': instance.invitedUsers,
    };

InvitedUserResponse _$InvitedUserResponseFromJson(Map<String, dynamic> json) =>
    InvitedUserResponse(
      id: json['id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      invitedAt: json['invitedAt'] as String?,
      status: json['status'] as String?,
      earnedPoints: (json['earnedPoints'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InvitedUserResponseToJson(
  InvitedUserResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'fullName': instance.fullName,
  'invitedAt': instance.invitedAt,
  'status': instance.status,
  'earnedPoints': instance.earnedPoints,
};

ReferralCountResponse _$ReferralCountResponseFromJson(
  Map<String, dynamic> json,
) => ReferralCountResponse(
  totalInvited: (json['totalInvited'] as num?)?.toInt(),
  totalActive: (json['totalActive'] as num?)?.toInt(),
  totalInactive: (json['totalInactive'] as num?)?.toInt(),
  totalEarnings: (json['totalEarnings'] as num?)?.toInt(),
);

Map<String, dynamic> _$ReferralCountResponseToJson(
  ReferralCountResponse instance,
) => <String, dynamic>{
  'totalInvited': instance.totalInvited,
  'totalActive': instance.totalActive,
  'totalInactive': instance.totalInactive,
  'totalEarnings': instance.totalEarnings,
};

PointChartResponse _$PointChartResponseFromJson(Map<String, dynamic> json) =>
    PointChartResponse(
      dailyPoints: (json['dailyPoints'] as List<dynamic>?)
          ?.map((e) => ChartDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      monthlyPoints: (json['monthlyPoints'] as List<dynamic>?)
          ?.map((e) => ChartDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PointChartResponseToJson(PointChartResponse instance) =>
    <String, dynamic>{
      'dailyPoints': instance.dailyPoints,
      'monthlyPoints': instance.monthlyPoints,
    };

ChartDataPoint _$ChartDataPointFromJson(Map<String, dynamic> json) =>
    ChartDataPoint(
      date: json['date'] as String?,
      points: (json['points'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChartDataPointToJson(ChartDataPoint instance) =>
    <String, dynamic>{'date': instance.date, 'points': instance.points};

WithdrawPointsRequest _$WithdrawPointsRequestFromJson(
  Map<String, dynamic> json,
) => WithdrawPointsRequest(
  amount: (json['amount'] as num).toInt(),
  bankAccount: json['bankAccount'] as String?,
  bankName: json['bankName'] as String?,
);

Map<String, dynamic> _$WithdrawPointsRequestToJson(
  WithdrawPointsRequest instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'bankAccount': instance.bankAccount,
  'bankName': instance.bankName,
};

SetReferralRequest _$SetReferralRequestFromJson(Map<String, dynamic> json) =>
    SetReferralRequest(referralCode: json['referralCode'] as String);

Map<String, dynamic> _$SetReferralRequestToJson(SetReferralRequest instance) =>
    <String, dynamic>{'referralCode': instance.referralCode};
