import 'package:json_annotation/json_annotation.dart';

part 'order_response.g.dart';

/// Order Item detail
@JsonSerializable()
class OrderItemResponse {
  final String? id;
  final String? courseId;
  final String? courseTitle;
  final String? courseSlug;
  final String? courseImage;
  final double? price;
  final double? discount;
  final double? finalPrice;

  OrderItemResponse({
    this.id,
    this.courseId,
    this.courseTitle,
    this.courseSlug,
    this.courseImage,
    this.price,
    this.discount,
    this.finalPrice,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemResponseToJson(this);
}

/// Order Response sau khi tạo order
@JsonSerializable()
class OrderResponse {
  final String? orderId;
  final String? qrCodeUrl;
  final String? description;
  final String? id;
  final String? userId;
  final double? subtotal;
  final double? discount;
  final double? total;
  final String? status;
  final String? couponCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItemResponse>? items;

  OrderResponse({
    this.orderId,
    this.qrCodeUrl,
    this.description,
    this.id,
    this.userId,
    this.subtotal,
    this.discount,
    this.total,
    this.status,
    this.couponCode,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}

/// Order View Response để hiển thị trong list
@JsonSerializable()
class OrderViewResponse {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final double? subtotal;
  final double? discount;
  final double? total;
  final String? status;
  final String? couponCode;
  final String? qrCode;  // QR code URL from backend
  final String? description;  // Payment description
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItemResponse>? items;

  OrderViewResponse({
    this.id,
    this.userId,
    this.userName,
    this.userEmail,
    this.subtotal,
    this.discount,
    this.total,
    this.status,
    this.couponCode,
    this.qrCode,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory OrderViewResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderViewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderViewResponseToJson(this);
}

/// Request để tạo order mới
@JsonSerializable()
class OrderRequest {
  final List<String> courseIds;
  final String? couponCode;

  OrderRequest({
    required this.courseIds,
    this.couponCode,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRequestToJson(this);
}

/// Response wrapper cho paginated orders
@JsonSerializable()
class PagingOrderResponse {
  final List<OrderViewResponse>? data;
  final int? totalPage;
  final int? totalElement;

  PagingOrderResponse({
    this.data,
    this.totalPage,
    this.totalElement,
  });

  factory PagingOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$PagingOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PagingOrderResponseToJson(this);
}
