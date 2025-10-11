import 'package:json_annotation/json_annotation.dart';

part 'user_exercise_response.g.dart';

@JsonSerializable()
class UserExerciseResponse {
  final int id;
  final int userId;
  final int exerciseId;
  final String userAnswer;
  final bool isCorrect;
  final DateTime submittedAt;

  UserExerciseResponse({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.userAnswer,
    required this.isCorrect,
    required this.submittedAt,
  });

  factory UserExerciseResponse.fromJson(Map<String, dynamic> json) =>
      _$UserExerciseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserExerciseResponseToJson(this);
}
