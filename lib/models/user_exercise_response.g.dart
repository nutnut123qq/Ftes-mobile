// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_exercise_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserExerciseResponse _$UserExerciseResponseFromJson(
  Map<String, dynamic> json,
) => UserExerciseResponse(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  exerciseId: (json['exerciseId'] as num).toInt(),
  userAnswer: json['userAnswer'] as String,
  isCorrect: json['isCorrect'] as bool,
  submittedAt: DateTime.parse(json['submittedAt'] as String),
);

Map<String, dynamic> _$UserExerciseResponseToJson(
  UserExerciseResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'exerciseId': instance.exerciseId,
  'userAnswer': instance.userAnswer,
  'isCorrect': instance.isCorrect,
  'submittedAt': instance.submittedAt.toIso8601String(),
};
