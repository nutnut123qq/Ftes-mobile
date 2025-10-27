// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSummaryModel _$OrderSummaryModelFromJson(Map<String, dynamic> json) =>
    OrderSummaryModel(
      id: json['id'] as String?,
      orderId: json['orderId'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      status: json['status'] as String?,
      couponCode: json['couponCode'] as String?,
      couponName: json['couponName'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => CourseOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderSummaryModelToJson(OrderSummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'total': instance.total,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'couponCode': instance.couponCode,
      'couponName': instance.couponName,
      'qrCodeUrl': instance.qrCodeUrl,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'items': instance.items,
      'courses': instance.courses,
    };
