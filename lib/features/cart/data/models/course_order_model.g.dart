// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseOrderModel _$CourseOrderModelFromJson(Map<String, dynamic> json) =>
    CourseOrderModel(
      courseId: json['courseId'] as String?,
      title: json['title'] as String?,
      salePrice: (json['salePrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CourseOrderModelToJson(CourseOrderModel instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'title': instance.title,
      'salePrice': instance.salePrice,
    };
