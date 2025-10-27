import 'order_item.dart';
import 'course_order.dart';

/// Order summary entity (simplified version for list display)
class OrderSummary {
  final String? id;
  final String? orderId;
  final double? total;
  final double? totalPrice;
  final String? status;
  final String? couponCode;
  final String? couponName;
  final String? qrCodeUrl;
  final String? description;
  final DateTime? createdAt;
  final List<OrderItem>? items;
  final List<CourseOrder>? courses;

  const OrderSummary({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderSummary &&
        other.id == id &&
        other.orderId == orderId &&
        other.total == total &&
        other.totalPrice == totalPrice &&
        other.status == status &&
        other.couponCode == couponCode &&
        other.couponName == couponName &&
        other.qrCodeUrl == qrCodeUrl &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderId.hashCode ^
        total.hashCode ^
        totalPrice.hashCode ^
        status.hashCode ^
        couponCode.hashCode ^
        couponName.hashCode ^
        qrCodeUrl.hashCode ^
        description.hashCode ^
        createdAt.hashCode;
  }
}
