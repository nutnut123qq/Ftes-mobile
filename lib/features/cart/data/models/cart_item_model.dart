import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_summary.dart';

part 'cart_item_model.g.dart';

/// Cart Item model for data layer
@JsonSerializable(explicitToJson: true)
class CartItemModel {
  @JsonKey(name: 'cartItemId')
  final String cartItemId;
  
  @JsonKey(name: 'title')
  final String title;
  
  @JsonKey(name: 'price')
  final double? price;
  
  final CourseInfoModel course;

  const CartItemModel({
    required this.cartItemId,
    required this.title,
    this.price,
    required this.course,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  /// Convert to domain entity
  CartItem toEntity() {
    return CartItem(
      cartItemId: cartItemId,
      courseId: course.id,
      courseName: title, // Use title from API response
      courseImage: course.imageHeader ?? '',
      price: price ?? course.totalPrice ?? 0.0, // Use price from API response
      salePrice: course.salePrice ?? 0.0,
      createdAt: course.createdAt ?? '',
      course: course.toEntity(),
    );
  }

  /// Create from domain entity
  factory CartItemModel.fromEntity(CartItem cartItem) {
    return CartItemModel(
      cartItemId: cartItem.cartItemId,
      title: cartItem.courseName,
      price: cartItem.price,
      course: CourseInfoModel.fromEntity(cartItem.course),
    );
  }
}

/// Course Info model for data layer
@JsonSerializable(explicitToJson: true)
class CourseInfoModel {
  final String id;
  
  final String title;
  
  @JsonKey(name: 'totalPrice')
  final double? totalPrice;
  
  @JsonKey(name: 'salePrice')
  final double? salePrice;
  
  @JsonKey(name: 'imageHeader')
  final String? imageHeader;
  
  @JsonKey(name: 'createdBy')
  final String? createdBy;
  
  @JsonKey(name: 'slugName')
  final String? slugName;
  
  @JsonKey(name: 'avgStar')
  final double? avgStar;
  
  final String? description;
  
  final String? level;
  
  @JsonKey(name: 'createdAt')
  final String? createdAt;

  const CourseInfoModel({
    required this.id,
    required this.title,
    this.totalPrice,
    this.salePrice,
    this.imageHeader,
    this.createdBy,
    this.slugName,
    this.avgStar,
    this.description,
    this.level,
    this.createdAt,
  });

  factory CourseInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CourseInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseInfoModelToJson(this);

  /// Convert to domain entity
  CourseInfo toEntity() {
    return CourseInfo(
      id: id,
      title: title,
      totalPrice: totalPrice ?? 0.0,
      salePrice: salePrice ?? 0.0,
      imageHeader: imageHeader ?? '',
      createdBy: createdBy ?? '',
      slugName: slugName ?? '',
      avgStar: avgStar ?? 0.0,
      description: description ?? '',
      level: level ?? '',
    );
  }

  /// Create from domain entity
  factory CourseInfoModel.fromEntity(CourseInfo courseInfo) {
    return CourseInfoModel(
      id: courseInfo.id,
      title: courseInfo.title,
      totalPrice: courseInfo.totalPrice,
      salePrice: courseInfo.salePrice,
      imageHeader: courseInfo.imageHeader,
      createdBy: courseInfo.createdBy,
      slugName: courseInfo.slugName,
      avgStar: courseInfo.avgStar,
      description: courseInfo.description,
      level: courseInfo.level,
    );
  }
}
