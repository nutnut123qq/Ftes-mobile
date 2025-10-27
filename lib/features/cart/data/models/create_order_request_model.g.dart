// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequestModel _$CreateOrderRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateOrderRequestModel(
  courseIds: (json['courseIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  couponName: json['couponName'] as String?,
  usePoint: json['usePoint'] as bool? ?? false,
);

Map<String, dynamic> _$CreateOrderRequestModelToJson(
  CreateOrderRequestModel instance,
) => <String, dynamic>{
  'courseIds': instance.courseIds,
  'couponName': instance.couponName,
  'usePoint': instance.usePoint,
};
