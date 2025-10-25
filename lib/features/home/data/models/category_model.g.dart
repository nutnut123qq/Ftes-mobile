// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'image': instance.image,
      'active': instance.active,
    };
