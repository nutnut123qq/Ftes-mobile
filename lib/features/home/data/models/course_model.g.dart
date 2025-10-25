// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
  id: json['id'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  image: json['image'] as String?,
  imageHeader: json['imageHeader'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  salePrice: (json['salePrice'] as num?)?.toDouble(),
  slugName: json['slugName'] as String?,
  categoryId: json['categoryId'] as String?,
  categoryName: json['categoryName'] as String?,
  level: json['level'] as String?,
  language: json['language'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  instructorId: json['instructorId'] as String?,
  instructorName: json['instructorName'] as String?,
  instructorAvatar: json['instructorAvatar'] as String?,
  totalStudents: (json['totalStudents'] as num?)?.toInt(),
  rating: (json['rating'] as num?)?.toDouble(),
  totalReviews: (json['totalReviews'] as num?)?.toInt(),
  isFeatured: json['isFeatured'] as bool?,
  isPublished: json['isPublished'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'imageHeader': instance.imageHeader,
      'price': instance.price,
      'salePrice': instance.salePrice,
      'slugName': instance.slugName,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'level': instance.level,
      'language': instance.language,
      'duration': instance.duration,
      'instructorId': instance.instructorId,
      'instructorName': instance.instructorName,
      'instructorAvatar': instance.instructorAvatar,
      'totalStudents': instance.totalStudents,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
      'isFeatured': instance.isFeatured,
      'isPublished': instance.isPublished,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
