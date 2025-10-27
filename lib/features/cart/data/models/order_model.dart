import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/course_order.dart';
import 'order_item_model.dart';
import 'course_order_model.dart';

part 'order_model.g.dart';

/// Order model for data layer
@JsonSerializable()
class OrderModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'orderId')
  final String? orderId;

  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'userName')
  final String? userName;

  @JsonKey(name: 'userEmail')
  final String? userEmail;

  @JsonKey(name: 'subtotal')
  final double? subtotal;

  @JsonKey(name: 'discount')
  final double? discount;

  @JsonKey(name: 'total')
  final double? total;

  @JsonKey(name: 'totalPrice')
  final double? totalPrice;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'couponCode')
  final String? couponCode;

  @JsonKey(name: 'couponName')
  final String? couponName;

  @JsonKey(name: 'qrCodeUrl')
  final String? qrCodeUrl;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  @JsonKey(name: 'items')
  final List<OrderItemModel>? items;

  @JsonKey(name: 'courses')
  final List<CourseOrderModel>? courses;

  const OrderModel({
    this.id,
    this.orderId,
    this.userId,
    this.userName,
    this.userEmail,
    this.subtotal,
    this.discount,
    this.total,
    this.totalPrice,
    this.status,
    this.couponCode,
    this.couponName,
    this.qrCodeUrl,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.items,
    this.courses,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle nested JSON parsing
    final itemsData = json['items'] as List<dynamic>?;
    final items = itemsData?.map((item) => OrderItemModel.fromJson(item)).toList();

    final coursesData = json['courses'] as List<dynamic>?;
    final courses = coursesData?.map((course) => CourseOrderModel.fromJson(course)).toList();

    return OrderModel(
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
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      items: items,
      courses: courses,
    );
  }

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  /// Convert to domain entity
  Order toEntity() {
    return Order(
      id: id,
      orderId: orderId,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      subtotal: subtotal,
      discount: discount,
      total: total,
      totalPrice: totalPrice,
      status: status,
      couponCode: couponCode,
      couponName: couponName,
      qrCodeUrl: qrCodeUrl,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      items: items?.map((item) => item.toEntity()).toList(),
      courses: courses?.map((course) => course.toEntity()).toList(),
    );
  }

  /// Create from domain entity
  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      orderId: order.orderId,
      userId: order.userId,
      userName: order.userName,
      userEmail: order.userEmail,
      subtotal: order.subtotal,
      discount: order.discount,
      total: order.total,
      totalPrice: order.totalPrice,
      status: order.status,
      couponCode: order.couponCode,
      couponName: order.couponName,
      qrCodeUrl: order.qrCodeUrl,
      description: order.description,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
      items: order.items?.map((item) => OrderItemModel.fromEntity(item)).toList(),
      courses: order.courses?.map((course) => CourseOrderModel.fromEntity(course)).toList(),
    );
  }
}
