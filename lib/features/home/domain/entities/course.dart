/// Course entity for domain layer
class Course {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final String? imageHeader;
  final double? price;
  final double? salePrice;
  final String? slugName;
  final String? categoryId;
  final String? categoryName;
  final String? level;
  final String? language;
  final int? duration;
  final String? instructorId;
  final String? instructorName;
  final String? instructorAvatar;
  final int? totalStudents;
  final double? rating;
  final int? totalReviews;
  final bool? isFeatured;
  final bool? isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Course({
    this.id,
    this.title,
    this.description,
    this.image,
    this.imageHeader,
    this.price,
    this.salePrice,
    this.slugName,
    this.categoryId,
    this.categoryName,
    this.level,
    this.language,
    this.duration,
    this.instructorId,
    this.instructorName,
    this.instructorAvatar,
    this.totalStudents,
    this.rating,
    this.totalReviews,
    this.isFeatured,
    this.isPublished,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
