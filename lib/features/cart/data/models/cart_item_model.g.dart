// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      cartItemId: json['cartItemId'] as String,
      title: json['title'] as String,
      price: (json['price'] as num?)?.toDouble(),
      course: CourseInfoModel.fromJson(json['course'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'cartItemId': instance.cartItemId,
      'title': instance.title,
      'price': instance.price,
      'course': instance.course.toJson(),
    };

CourseInfoModel _$CourseInfoModelFromJson(Map<String, dynamic> json) =>
    CourseInfoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      imageHeader: json['imageHeader'] as String?,
      createdBy: json['createdBy'] as String?,
      slugName: json['slugName'] as String?,
      avgStar: (json['avgStar'] as num?)?.toDouble(),
      description: json['description'] as String?,
      level: json['level'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$CourseInfoModelToJson(CourseInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'totalPrice': instance.totalPrice,
      'salePrice': instance.salePrice,
      'imageHeader': instance.imageHeader,
      'createdBy': instance.createdBy,
      'slugName': instance.slugName,
      'avgStar': instance.avgStar,
      'description': instance.description,
      'level': instance.level,
      'createdAt': instance.createdAt,
    };
