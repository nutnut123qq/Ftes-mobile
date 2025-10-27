// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      id: json['id'] as String?,
      courseId: json['courseId'] as String?,
      courseTitle: json['courseTitle'] as String?,
      courseSlug: json['courseSlug'] as String?,
      courseImage: json['courseImage'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      instructorName: json['instructorName'] as String?,
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'courseTitle': instance.courseTitle,
      'courseSlug': instance.courseSlug,
      'courseImage': instance.courseImage,
      'price': instance.price,
      'discount': instance.discount,
      'finalPrice': instance.finalPrice,
      'instructorName': instance.instructorName,
    };
