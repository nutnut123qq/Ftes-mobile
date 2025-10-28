import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/course_order.dart';

part 'course_order_model.g.dart';

/// Course order model for data layer
@JsonSerializable()
class CourseOrderModel {
  @JsonKey(name: 'courseId')
  final String? courseId;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'salePrice')
  final double? salePrice;

  const CourseOrderModel({
    this.courseId,
    this.title,
    this.salePrice,
  });

  factory CourseOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CourseOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseOrderModelToJson(this);

  /// Convert to domain entity
  CourseOrder toEntity() {
    return CourseOrder(
      courseId: courseId,
      title: title,
      salePrice: salePrice,
    );
  }

  /// Create from domain entity
  factory CourseOrderModel.fromEntity(CourseOrder courseOrder) {
    return CourseOrderModel(
      courseId: courseOrder.courseId,
      title: courseOrder.title,
      salePrice: courseOrder.salePrice,
    );
  }
}



