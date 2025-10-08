// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemResponse _$CartItemResponseFromJson(Map<String, dynamic> json) =>
    CartItemResponse(
      id: json['cartItemId'] as String?,
      course: json['course'] == null
          ? null
          : CourseResponse.fromJson(json['course'] as Map<String, dynamic>),
      title: json['title'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CartItemResponseToJson(CartItemResponse instance) =>
    <String, dynamic>{
      'cartItemId': instance.id,
      'course': instance.course,
      'title': instance.title,
      'price': instance.price,
    };

CartTotalResponse _$CartTotalResponseFromJson(Map<String, dynamic> json) =>
    CartTotalResponse(
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      autoDiscount: (json['autoDiscount'] as num?)?.toDouble(),
      couponDiscount: (json['couponDiscount'] as num?)?.toDouble(),
      couponName: json['couponName'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      itemCount: (json['itemCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CartTotalResponseToJson(CartTotalResponse instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'autoDiscount': instance.autoDiscount,
      'couponDiscount': instance.couponDiscount,
      'couponName': instance.couponName,
      'total': instance.total,
      'itemCount': instance.itemCount,
    };

PagingCartItemResponse _$PagingCartItemResponseFromJson(
  Map<String, dynamic> json,
) => PagingCartItemResponse(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CartItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPage: (json['totalPage'] as num?)?.toInt(),
  totalElement: (json['totalElement'] as num?)?.toInt(),
);

Map<String, dynamic> _$PagingCartItemResponseToJson(
  PagingCartItemResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'totalPage': instance.totalPage,
  'totalElement': instance.totalElement,
};

AddToCartRequest _$AddToCartRequestFromJson(Map<String, dynamic> json) =>
    AddToCartRequest(courseId: json['courseId'] as String);

Map<String, dynamic> _$AddToCartRequestToJson(AddToCartRequest instance) =>
    <String, dynamic>{'courseId': instance.courseId};
