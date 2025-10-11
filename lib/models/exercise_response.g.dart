// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseResponse _$ExerciseResponseFromJson(Map<String, dynamic> json) =>
    ExerciseResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      question: json['question'] as String?,
      correctAnswer: json['correctAnswer'] as String?,
      lessonId: (json['lessonId'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ExerciseResponseToJson(ExerciseResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'question': instance.question,
      'correctAnswer': instance.correctAnswer,
      'lessonId': instance.lessonId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
