// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_user_exercise_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveUserExerciseRequest _$SaveUserExerciseRequestFromJson(
  Map<String, dynamic> json,
) => SaveUserExerciseRequest(
  userId: (json['userId'] as num).toInt(),
  exerciseId: (json['exerciseId'] as num).toInt(),
  userAnswer: json['userAnswer'] as String,
  isCorrect: json['isCorrect'] as bool?,
);

Map<String, dynamic> _$SaveUserExerciseRequestToJson(
  SaveUserExerciseRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'exerciseId': instance.exerciseId,
  'userAnswer': instance.userAnswer,
  'isCorrect': instance.isCorrect,
};
