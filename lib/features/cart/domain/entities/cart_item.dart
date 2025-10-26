import 'package:equatable/equatable.dart';

/// Cart Item entity representing an item in the shopping cart
class CartItem extends Equatable {
  final String cartItemId;
  final String courseId;
  final String courseName;
  final String courseImage;
  final double price;
  final double salePrice;
  final String createdAt;
  final CourseInfo course;

  const CartItem({
    required this.cartItemId,
    required this.courseId,
    required this.courseName,
    required this.courseImage,
    required this.price,
    required this.salePrice,
    required this.createdAt,
    required this.course,
  });

  /// Calculate final price after discount
  double get finalPrice {
    if (salePrice > 0 && salePrice < price) {
      return salePrice;
    }
    return price;
  }

  /// Calculate discount percentage
  double get discountPercentage {
    if (price == 0 || salePrice >= price) {
      return 0.0;
    }
    return ((price - salePrice) / price) * 100;
  }

  @override
  List<Object?> get props => [
        cartItemId,
        courseId,
        courseName,
        courseImage,
        price,
        salePrice,
        createdAt,
        course,
      ];
}

/// Course information within cart item
class CourseInfo extends Equatable {
  final String id;
  final String title;
  final double totalPrice;
  final double salePrice;
  final String imageHeader;
  final String createdBy;
  final String slugName;
  final double avgStar;
  final String description;
  final String level;

  const CourseInfo({
    required this.id,
    required this.title,
    required this.totalPrice,
    required this.salePrice,
    required this.imageHeader,
    required this.createdBy,
    required this.slugName,
    required this.avgStar,
    required this.description,
    required this.level,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        totalPrice,
        salePrice,
        imageHeader,
        createdBy,
        slugName,
        avgStar,
        description,
        level,
      ];
}
