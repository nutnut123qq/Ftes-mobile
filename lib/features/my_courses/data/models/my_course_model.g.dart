// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyCourseModel _$MyCourseModelFromJson(Map<String, dynamic> json) =>
    MyCourseModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageHeader: json['imageHeader'] as String?,
      slugName: json['slugName'] as String?,
      instructor: json['instructor'] as String?,
      purchaseDate: json['purchaseDate'] as String?,
      courseModels: (json['courses'] as List<dynamic>?)
          ?.map((e) => CourseReferenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyCourseModelToJson(MyCourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageHeader': instance.imageHeader,
      'slugName': instance.slugName,
      'instructor': instance.instructor,
      'purchaseDate': instance.purchaseDate,
      'courses': instance.courseModels?.map((e) => e.toJson()).toList(),
    };

CourseReferenceModel _$CourseReferenceModelFromJson(
  Map<String, dynamic> json,
) => CourseReferenceModel(courseId: json['courseId'] as String?);

Map<String, dynamic> _$CourseReferenceModelToJson(
  CourseReferenceModel instance,
) => <String, dynamic>{'courseId': instance.courseId};
