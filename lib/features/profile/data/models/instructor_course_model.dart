import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/instructor_course.dart';

part 'instructor_course_model.g.dart';

/// Instructor Course model for JSON serialization
@JsonSerializable()
class InstructorCourseModel {
  final String id;
  final String title;
  final String description;
  final double avgStar;
  final double totalPrice;
  final double salePrice;
  final int totalUser;
  final String imageHeader;
  final String slugName;
  final String? courseCode;
  final int? term;
  final String? contentCourse;
  final String? createdAt;
  final String? updatedAt;
  final String? instructor;
  final String? categoryId;
  final String? categoryName;

  const InstructorCourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.avgStar,
    required this.totalPrice,
    required this.salePrice,
    required this.totalUser,
    required this.imageHeader,
    required this.slugName,
    this.courseCode,
    this.term,
    this.contentCourse,
    this.createdAt,
    this.updatedAt,
    this.instructor,
    this.categoryId,
    this.categoryName,
  });

  factory InstructorCourseModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorCourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorCourseModelToJson(this);

  /// Convert to domain entity
  InstructorCourse toEntity() {
    return InstructorCourse(
      id: id,
      title: title,
      description: description,
      avgStar: avgStar,
      totalPrice: totalPrice,
      salePrice: salePrice,
      totalUser: totalUser,
      imageHeader: imageHeader,
      slugName: slugName,
      courseCode: courseCode ?? '',
      term: term ?? 0,
      contentCourse: contentCourse ?? '',
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : DateTime.now(),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : DateTime.now(),
      instructor: instructor ?? '',
      categoryId: categoryId ?? '',
      categoryName: categoryName ?? '',
    );
  }
}
