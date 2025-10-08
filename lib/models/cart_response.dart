import 'package:json_annotation/json_annotation.dart';
import 'course_response.dart';

part 'cart_response.g.dart';

/// Response model cho Cart Item
@JsonSerializable()
class CartItemResponse {
  @JsonKey(name: 'cartItemId')
  final String? id;
  
  final CourseResponse? course;
  final String? title;
  final double? price;

  CartItemResponse({
    this.id,
    this.course,
    this.title,
    this.price,
  });

  factory CartItemResponse.fromJson(Map<String, dynamic> json) =>
      _$CartItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemResponseToJson(this);

  // Convenience getters to access course properties
  String? get courseId => course?.id;
  String? get courseTitle => course?.title ?? title;
  String? get courseSlug => course?.slugName;
  String? get courseImage => course?.image;
  double? get coursePrice => course?.price ?? price;
  double? get courseSalePrice => course?.salePrice;
  String? get instructorName => course?.instructorName;
  double? get rating => course?.rating;
  int? get totalStudents => course?.totalStudents;
  
  /// Calculate final price after discount
  double get finalPrice {
    // Use salePrice if available, otherwise use regular price
    final salePrice = courseSalePrice;
    final basePrice = coursePrice ?? price ?? 0.0;
    
    if (salePrice != null && salePrice > 0) {
      return salePrice;
    }
    
    return basePrice;
  }
  
  /// Calculate discount percentage
  double get discountPercentage {
    final basePrice = coursePrice ?? price ?? 0.0;
    final salePrice = courseSalePrice;
    
    if (basePrice == 0 || salePrice == null || salePrice >= basePrice) {
      return 0.0;
    }
    
    return ((basePrice - salePrice) / basePrice) * 100;
  }
}

/// Response model cho Cart Total calculation
@JsonSerializable()
class CartTotalResponse {
  final double? subtotal;
  final double? autoDiscount;
  final double? couponDiscount;
  final String? couponName;
  final double? total;
  final int? itemCount;

  CartTotalResponse({
    this.subtotal,
    this.autoDiscount,
    this.couponDiscount,
    this.couponName,
    this.total,
    this.itemCount,
  });

  factory CartTotalResponse.fromJson(Map<String, dynamic> json) =>
      _$CartTotalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CartTotalResponseToJson(this);
}

/// Response wrapper cho paginated cart items
@JsonSerializable()
class PagingCartItemResponse {
  final List<CartItemResponse>? data;
  final int? totalPage;
  final int? totalElement;

  PagingCartItemResponse({
    this.data,
    this.totalPage,
    this.totalElement,
  });

  factory PagingCartItemResponse.fromJson(Map<String, dynamic> json) =>
      _$PagingCartItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PagingCartItemResponseToJson(this);
}

/// Request model để thêm item vào cart
@JsonSerializable()
class AddToCartRequest {
  final String courseId;

  AddToCartRequest({required this.courseId});

  factory AddToCartRequest.fromJson(Map<String, dynamic> json) =>
      _$AddToCartRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddToCartRequestToJson(this);
}
