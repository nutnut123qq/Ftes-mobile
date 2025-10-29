// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => LessonModel(
  id: json['id'] as String,
  title: json['name'] as String,
  description: json['description'] as String?,
  video: json['video'] as String?,
  order: (json['order'] as num?)?.toInt(),
  partOrder: (json['partOrder'] as num?)?.toInt(),
  duration: (json['duration'] as num?)?.toInt(),
      isCompleted: json['isCompleted'] as bool?,
  type: json['type'] as String?,
      exercise: json['exercise'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$LessonModelToJson(LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'description': instance.description,
      'video': instance.video,
      'order': instance.order,
      'partOrder': instance.partOrder,
      'duration': instance.duration,
      'isCompleted': instance.isCompleted,
      'type': instance.type,
      'exercise': instance.exercise,
    };
