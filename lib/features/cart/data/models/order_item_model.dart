import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_item.dart';

part 'order_item_model.g.dart';

/// Order item model for data layer
@JsonSerializable()
class OrderItemModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'courseId')
  final String? courseId;

  @JsonKey(name: 'courseTitle')
  final String? courseTitle;

  @JsonKey(name: 'courseSlug')
  final String? courseSlug;

  @JsonKey(name: 'courseImage')
  final String? courseImage;

  @JsonKey(name: 'price')
  final double? price;

  @JsonKey(name: 'discount')
  final double? discount;

  @JsonKey(name: 'finalPrice')
  final double? finalPrice;

  @JsonKey(name: 'instructorName')
  final String? instructorName;

  const OrderItemModel({
    this.id,
    this.courseId,
    this.courseTitle,
    this.courseSlug,
    this.courseImage,
    this.price,
    this.discount,
    this.finalPrice,
    this.instructorName,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  /// Convert to domain entity
  OrderItem toEntity() {
    return OrderItem(
      id: id,
      courseId: courseId,
      courseTitle: courseTitle,
      courseSlug: courseSlug,
      courseImage: courseImage,
      price: price,
      discount: discount,
      finalPrice: finalPrice,
      instructorName: instructorName,
    );
  }

  /// Create from domain entity
  factory OrderItemModel.fromEntity(OrderItem orderItem) {
    return OrderItemModel(
      id: orderItem.id,
      courseId: orderItem.courseId,
      courseTitle: orderItem.courseTitle,
      courseSlug: orderItem.courseSlug,
      courseImage: orderItem.courseImage,
      price: orderItem.price,
      discount: orderItem.discount,
      finalPrice: orderItem.finalPrice,
      instructorName: orderItem.instructorName,
    );
  }
}


