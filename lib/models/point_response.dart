import 'package:json_annotation/json_annotation.dart';

part 'point_response.g.dart';

@JsonSerializable()
class UserPointsResponse {
  final int? totalPoints;
  final int? availablePoints;
  final int? lockedPoints;
  final int? withdrawnPoints;
  final String? lastUpdated;

  UserPointsResponse({
    this.totalPoints,
    this.availablePoints,
    this.lockedPoints,
    this.withdrawnPoints,
    this.lastUpdated,
  });

  factory UserPointsResponse.fromJson(Map<String, dynamic> json) =>
      _$UserPointsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserPointsResponseToJson(this);
}

@JsonSerializable()
class PointTransactionResponse {
  final String? id;
  final String? type;
  final int? amount;
  final String? description;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  PointTransactionResponse({
    this.id,
    this.type,
    this.amount,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PointTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$PointTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PointTransactionResponseToJson(this);
}

@JsonSerializable()
class ReferralResponse {
  final String? referralCode;
  final int? totalReferrals;
  final int? totalEarnings;
  final List<InvitedUserResponse>? invitedUsers;

  ReferralResponse({
    this.referralCode,
    this.totalReferrals,
    this.totalEarnings,
    this.invitedUsers,
  });

  factory ReferralResponse.fromJson(Map<String, dynamic> json) =>
      _$ReferralResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralResponseToJson(this);
}

@JsonSerializable()
class InvitedUserResponse {
  final String? id;
  final String? username;
  final String? email;
  final String? fullName;
  final String? invitedAt;
  final String? status;
  final int? earnedPoints;

  InvitedUserResponse({
    this.id,
    this.username,
    this.email,
    this.fullName,
    this.invitedAt,
    this.status,
    this.earnedPoints,
  });

  factory InvitedUserResponse.fromJson(Map<String, dynamic> json) =>
      _$InvitedUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvitedUserResponseToJson(this);
}

@JsonSerializable()
class ReferralCountResponse {
  final int? totalInvited;
  final int? totalActive;
  final int? totalInactive;
  final int? totalEarnings;

  ReferralCountResponse({
    this.totalInvited,
    this.totalActive,
    this.totalInactive,
    this.totalEarnings,
  });

  factory ReferralCountResponse.fromJson(Map<String, dynamic> json) =>
      _$ReferralCountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralCountResponseToJson(this);
}

@JsonSerializable()
class PointChartResponse {
  final List<ChartDataPoint>? dailyPoints;
  final List<ChartDataPoint>? monthlyPoints;

  PointChartResponse({
    this.dailyPoints,
    this.monthlyPoints,
  });

  factory PointChartResponse.fromJson(Map<String, dynamic> json) =>
      _$PointChartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PointChartResponseToJson(this);
}

@JsonSerializable()
class ChartDataPoint {
  final String? date;
  final int? points;

  ChartDataPoint({
    this.date,
    this.points,
  });

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) =>
      _$ChartDataPointFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDataPointToJson(this);
}

// Request models
@JsonSerializable()
class WithdrawPointsRequest {
  final int amount;
  final String? bankAccount;
  final String? bankName;

  WithdrawPointsRequest({
    required this.amount,
    this.bankAccount,
    this.bankName,
  });

  factory WithdrawPointsRequest.fromJson(Map<String, dynamic> json) =>
      _$WithdrawPointsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawPointsRequestToJson(this);
}

@JsonSerializable()
class SetReferralRequest {
  final String referralCode;

  SetReferralRequest({
    required this.referralCode,
  });

  factory SetReferralRequest.fromJson(Map<String, dynamic> json) =>
      _$SetReferralRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SetReferralRequestToJson(this);
}