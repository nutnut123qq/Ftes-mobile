// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartModel _$PartModelFromJson(Map<String, dynamic> json) => PartModel(
  id: json['id'] as String,
  name: (json['name'] ?? json['title']) as String,
  description: json['description'] as String,
  order: (json['order'] as num?)?.toInt(),
  lessons: (json['lessons'] as List<dynamic>?)
      ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  exercises: (json['exercises'] as List<dynamic>?)
      ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PartModelToJson(PartModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'order': instance.order,
  'lessons': instance.lessons?.map((e) => e.toJson()).toList(),
  'exercises': instance.exercises?.map((e) => e.toJson()).toList(),
};
