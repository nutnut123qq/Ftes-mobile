/// Course order entity (simplified version for order display)
class CourseOrder {
  final String? courseId;
  final String? title;
  final double? salePrice;

  const CourseOrder({
    this.courseId,
    this.title,
    this.salePrice,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseOrder &&
        other.courseId == courseId &&
        other.title == title &&
        other.salePrice == salePrice;
  }

  @override
  int get hashCode {
    return courseId.hashCode ^
        title.hashCode ^
        salePrice.hashCode;
  }
}


