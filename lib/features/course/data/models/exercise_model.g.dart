// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) =>
    ExerciseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: (json['order'] as num?)?.toInt(),
      partOrder: (json['partOrder'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$ExerciseModelToJson(ExerciseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'order': instance.order,
      'partOrder': instance.partOrder,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
