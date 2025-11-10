// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_points_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawPointsRequestModel _$WithdrawPointsRequestModelFromJson(
  Map<String, dynamic> json,
) => WithdrawPointsRequestModel(
  amount: (json['amount'] as num).toInt(),
  bankAccount: json['bankAccount'] as String?,
  bankName: json['bankName'] as String?,
);

Map<String, dynamic> _$WithdrawPointsRequestModelToJson(
  WithdrawPointsRequestModel instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'bankAccount': instance.bankAccount,
  'bankName': instance.bankName,
};
