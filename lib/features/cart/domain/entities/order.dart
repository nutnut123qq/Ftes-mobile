import 'order_item.dart';
import 'course_order.dart';

/// Order entity
class Order {
  final String? id;
  final String? orderId;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final double? subtotal;
  final double? discount;
  final double? total;
  final double? totalPrice;
  final String? status;
  final String? couponCode;
  final String? couponName;
  final String? qrCodeUrl;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem>? items;
  final List<CourseOrder>? courses;

  const Order({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.id == id &&
        other.orderId == orderId &&
        other.userId == userId &&
        other.userName == userName &&
        other.userEmail == userEmail &&
        other.subtotal == subtotal &&
        other.discount == discount &&
        other.total == total &&
        other.totalPrice == totalPrice &&
        other.status == status &&
        other.couponCode == couponCode &&
        other.couponName == couponName &&
        other.qrCodeUrl == qrCodeUrl &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderId.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        userEmail.hashCode ^
        subtotal.hashCode ^
        discount.hashCode ^
        total.hashCode ^
        totalPrice.hashCode ^
        status.hashCode ^
        couponCode.hashCode ^
        couponName.hashCode ^
        qrCodeUrl.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
