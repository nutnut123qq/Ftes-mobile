/// Order item entity
class OrderItem {
  final String? id;
  final String? courseId;
  final String? courseTitle;
  final String? courseSlug;
  final String? courseImage;
  final double? price;
  final double? discount;
  final double? finalPrice;
  final String? instructorName;

  const OrderItem({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        other.id == id &&
        other.courseId == courseId &&
        other.courseTitle == courseTitle &&
        other.courseSlug == courseSlug &&
        other.courseImage == courseImage &&
        other.price == price &&
        other.discount == discount &&
        other.finalPrice == finalPrice &&
        other.instructorName == instructorName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        courseId.hashCode ^
        courseTitle.hashCode ^
        courseSlug.hashCode ^
        courseImage.hashCode ^
        price.hashCode ^
        discount.hashCode ^
        finalPrice.hashCode ^
        instructorName.hashCode;
  }
}


