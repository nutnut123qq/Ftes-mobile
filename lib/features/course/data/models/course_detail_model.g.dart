// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseDetailModel _$CourseDetailModelFromJson(Map<String, dynamic> json) =>
    CourseDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      avgStar: (json['avgStar'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      salePrice: (json['salePrice'] as num).toDouble(),
      totalUser: (json['totalUser'] as num).toInt(),
      imageHeader: json['imageHeader'] as String,
      slugName: json['slugName'] as String,
      courseCode: json['courseCode'] as String,
      term: (json['term'] as num).toInt(),
      contentCourse: json['contentCourse'] as String?,
      level: json['level'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String?,
      infoCourse: json['infoCourse'] as Map<String, dynamic>?,
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => PartModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      exercises: (json['exercises'] as List<dynamic>?)
          ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseDetailModelToJson(CourseDetailModel instance) =>
    <String, dynamic>{
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
      'level': instance.level,
      'userId': instance.userId,
      'userName': instance.userName,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'infoCourse': instance.infoCourse,
      'parts': instance.parts?.map((e) => e.toJson()).toList(),
      'exercises': instance.exercises?.map((e) => e.toJson()).toList(),
    };
