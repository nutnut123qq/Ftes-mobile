// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemResponse _$OrderItemResponseFromJson(Map<String, dynamic> json) =>
    OrderItemResponse(
      id: json['id'] as String?,
      courseId: json['courseId'] as String?,
      courseTitle: json['courseTitle'] as String?,
      courseSlug: json['courseSlug'] as String?,
      courseImage: json['courseImage'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderItemResponseToJson(OrderItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'courseTitle': instance.courseTitle,
      'courseSlug': instance.courseSlug,
      'courseImage': instance.courseImage,
      'price': instance.price,
      'discount': instance.discount,
      'finalPrice': instance.finalPrice,
    };

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      orderId: json['orderId'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      description: json['description'] as String?,
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      status: json['status'] as String?,
      couponCode: json['couponCode'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'qrCodeUrl': instance.qrCodeUrl,
      'description': instance.description,
      'id': instance.id,
      'userId': instance.userId,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'total': instance.total,
      'status': instance.status,
      'couponCode': instance.couponCode,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
    };

OrderViewResponse _$OrderViewResponseFromJson(Map<String, dynamic> json) =>
    OrderViewResponse(
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
      qrCode: json['qrCode'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      createAt: json['createAt'] == null
          ? null
          : DateTime.parse(json['createAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => CourseOrderResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderViewResponseToJson(OrderViewResponse instance) =>
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
      'qrCode': instance.qrCode,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'createAt': instance.createAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
      'courses': instance.courses,
    };

CourseOrderResponse _$CourseOrderResponseFromJson(Map<String, dynamic> json) =>
    CourseOrderResponse(
      courseId: json['courseId'] as String?,
      title: json['title'] as String?,
      salePrice: (json['salePrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CourseOrderResponseToJson(
  CourseOrderResponse instance,
) => <String, dynamic>{
  'courseId': instance.courseId,
  'title': instance.title,
  'salePrice': instance.salePrice,
};

OrderRequest _$OrderRequestFromJson(Map<String, dynamic> json) => OrderRequest(
  courseIds: (json['courseIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  couponCode: json['couponCode'] as String?,
);

Map<String, dynamic> _$OrderRequestToJson(OrderRequest instance) =>
    <String, dynamic>{
      'courseIds': instance.courseIds,
      'couponCode': instance.couponCode,
    };

PagingOrderResponse _$PagingOrderResponseFromJson(Map<String, dynamic> json) =>
    PagingOrderResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderViewResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPage: (json['totalPage'] as num?)?.toInt(),
      totalElement: (json['totalElement'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PagingOrderResponseToJson(
  PagingOrderResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'totalPage': instance.totalPage,
  'totalElement': instance.totalElement,
};
