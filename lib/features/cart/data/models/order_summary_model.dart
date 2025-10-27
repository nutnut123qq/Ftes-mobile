import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_summary.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/course_order.dart';
import 'order_item_model.dart';
import 'course_order_model.dart';

part 'order_summary_model.g.dart';

/// Order summary model for data layer
@JsonSerializable()
class OrderSummaryModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'orderId')
  final String? orderId;

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

  @JsonKey(name: 'items')
  final List<OrderItemModel>? items;

  @JsonKey(name: 'courses')
  final List<CourseOrderModel>? courses;

  const OrderSummaryModel({
    this.id,
    this.orderId,
    this.total,
    this.totalPrice,
    this.status,
    this.couponCode,
    this.couponName,
    this.qrCodeUrl,
    this.description,
    this.createdAt,
    this.items,
    this.courses,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    // Handle nested JSON parsing
    final itemsData = json['items'] as List<dynamic>?;
    final items = itemsData?.map((item) => OrderItemModel.fromJson(item)).toList();

    final coursesData = json['courses'] as List<dynamic>?;
    final courses = coursesData?.map((course) => CourseOrderModel.fromJson(course)).toList();

    return OrderSummaryModel(
      id: json['id'] as String?,
      orderId: json['orderId'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      status: json['status'] as String?,
      couponCode: json['couponCode'] as String?,
      couponName: json['couponName'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      items: items,
      courses: courses,
    );
  }

  Map<String, dynamic> toJson() => _$OrderSummaryModelToJson(this);

  /// Convert to domain entity
  OrderSummary toEntity() {
    return OrderSummary(
      id: id,
      orderId: orderId,
      total: total,
      totalPrice: totalPrice,
      status: status,
      couponCode: couponCode,
      couponName: couponName,
      qrCodeUrl: qrCodeUrl,
      description: description,
      createdAt: createdAt,
      items: items?.map((item) => item.toEntity()).toList(),
      courses: courses?.map((course) => course.toEntity()).toList(),
    );
  }

  /// Create from domain entity
  factory OrderSummaryModel.fromEntity(OrderSummary orderSummary) {
    return OrderSummaryModel(
      id: orderSummary.id,
      orderId: orderSummary.orderId,
      total: orderSummary.total,
      totalPrice: orderSummary.totalPrice,
      status: orderSummary.status,
      couponCode: orderSummary.couponCode,
      couponName: orderSummary.couponName,
      qrCodeUrl: orderSummary.qrCodeUrl,
      description: orderSummary.description,
      createdAt: orderSummary.createdAt,
      items: orderSummary.items?.map((item) => OrderItemModel.fromEntity(item)).toList(),
      courses: orderSummary.courses?.map((course) => CourseOrderModel.fromEntity(course)).toList(),
    );
  }
}
