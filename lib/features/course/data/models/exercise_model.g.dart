// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) =>
    ExerciseModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      question: json['question'] as String,
      expectedOutput: json['expectedOutput'] as String,
      criteria: json['criteria'] as String,
      checkLogic: _boolFromString(json['checkLogic']),
      checkPerform: _boolFromString(json['checkPerform']),
      checkEdgeCase: _boolFromString(json['checkEdgeCase']),
      fileExtension: json['fileExtension'] as String,
      order: (json['order'] as num).toInt(),
      partOrder: (json['partOrder'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ExerciseModelToJson(ExerciseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'question': instance.question,
      'expectedOutput': instance.expectedOutput,
      'criteria': instance.criteria,
      'checkLogic': _boolToString(instance.checkLogic),
      'checkPerform': _boolToString(instance.checkPerform),
      'checkEdgeCase': _boolToString(instance.checkEdgeCase),
      'fileExtension': instance.fileExtension,
      'order': instance.order,
      'partOrder': instance.partOrder,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
