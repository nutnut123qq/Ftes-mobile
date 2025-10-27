// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String?,
  orderId: json['orderId'] as String?,
  userId: json['userId'] as String?,
  userName: json['userName'] as String?,
  userEmail: json['userEmail'] as String?,
  subtotal: (json['subtotal'] as num?)?.toDouble(),
  discount: (json['discount'] as num?)?.toDouble(),
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
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  courses: (json['courses'] as List<dynamic>?)
      ?.map((e) => CourseOrderModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'total': instance.total,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'couponCode': instance.couponCode,
      'couponName': instance.couponName,
      'qrCodeUrl': instance.qrCodeUrl,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
      'courses': instance.courses,
    };
