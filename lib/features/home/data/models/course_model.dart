import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/course.dart';

part 'course_model.g.dart';

/// Course model for data layer
  @JsonSerializable(explicitToJson: true)
class CourseModel extends Course {
  @JsonKey(name: 'avgStar')
  final double? avgStar;
  const CourseModel({
    super.id,
    super.title,
    super.description,
    super.image,
    super.imageHeader,
    super.price,
    super.salePrice,
    super.slugName,
    super.categoryId,
    super.categoryName,
    super.level,
    super.language,
    super.duration,
    super.instructorId,
    super.instructorName,
    super.instructorAvatar,
    super.totalStudents,
    this.avgStar,
    super.totalReviews,
    super.isFeatured,
    super.isPublished,
    super.createdAt,
    super.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  /// Convert to domain entity
  Course toEntity() {
    return Course(
      id: id,
      title: title,
      description: description,
      image: image,
      imageHeader: imageHeader,
      price: price,
      salePrice: salePrice,
      slugName: slugName,
      categoryId: categoryId,
      categoryName: categoryName,
      level: level,
      language: language,
      duration: duration,
      instructorId: instructorId,
      instructorName: instructorName,
      instructorAvatar: instructorAvatar,
      totalStudents: totalStudents,
      rating: avgStar ?? 5.0, // Default 5 stars if no rating
      totalReviews: totalReviews,
      isFeatured: isFeatured,
      isPublished: isPublished,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from domain entity
  factory CourseModel.fromEntity(Course course) {
    return CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      image: course.image,
      imageHeader: course.imageHeader,
      price: course.price,
      salePrice: course.salePrice,
      slugName: course.slugName,
      categoryId: course.categoryId,
      categoryName: course.categoryName,
      level: course.level,
      language: course.language,
      duration: course.duration,
      instructorId: course.instructorId,
      instructorName: course.instructorName,
      instructorAvatar: course.instructorAvatar,
      totalStudents: course.totalStudents,
      avgStar: course.rating,
      totalReviews: course.totalReviews,
      isFeatured: course.isFeatured,
      isPublished: course.isPublished,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
    );
  }
}
