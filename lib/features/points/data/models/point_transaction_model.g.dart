// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointTransactionModel _$PointTransactionModelFromJson(
  Map<String, dynamic> json,
) => PointTransactionModel(
  id: json['id'] as String?,
  type: json['type'] as String?,
  amount: (json['amount'] as num?)?.toInt(),
  description: json['description'] as String?,
  status: json['status'] as String?,
  createdAtJson: PointTransactionModel._dateTimeFromJson(json['createdAtJson']),
  updatedAtJson: PointTransactionModel._dateTimeFromJson(json['updatedAtJson']),
);

Map<String, dynamic> _$PointTransactionModelToJson(
  PointTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'amount': instance.amount,
  'description': instance.description,
  'status': instance.status,
  'createdAtJson': PointTransactionModel._dateTimeToJson(
    instance.createdAtJson,
  ),
  'updatedAtJson': PointTransactionModel._dateTimeToJson(
    instance.updatedAtJson,
  ),
};
