// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorCourseModel _$InstructorCourseModelFromJson(
  Map<String, dynamic> json,
) => InstructorCourseModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  avgStar: (json['avgStar'] as num).toDouble(),
  totalPrice: (json['totalPrice'] as num).toDouble(),
  salePrice: (json['salePrice'] as num).toDouble(),
  totalUser: (json['totalUser'] as num).toInt(),
  imageHeader: json['imageHeader'] as String,
  slugName: json['slugName'] as String,
  courseCode: json['courseCode'] as String?,
  term: (json['term'] as num?)?.toInt(),
  contentCourse: json['contentCourse'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  instructor: json['instructor'] as String?,
  categoryId: json['categoryId'] as String?,
  categoryName: json['categoryName'] as String?,
);

Map<String, dynamic> _$InstructorCourseModelToJson(
  InstructorCourseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'avgStar': instance.avgStar,
  'totalPrice': instance.totalPrice,
  'salePrice': instance.salePrice,
  'totalUser': instance.totalUser,
  'imageHeader': instance.imageHeader,
  'slugName': instance.slugName,
  'courseCode': instance.courseCode,
  'term': instance.term,
  'contentCourse': instance.contentCourse,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'instructor': instance.instructor,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
};
