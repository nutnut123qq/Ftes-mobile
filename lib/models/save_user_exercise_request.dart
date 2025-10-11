import 'package:json_annotation/json_annotation.dart';

part 'save_user_exercise_request.g.dart';

@JsonSerializable()
class SaveUserExerciseRequest {
  final int userId;
  final int exerciseId;
  final String userAnswer;
  final bool? isCorrect;

  SaveUserExerciseRequest({
    required this.userId,
    required this.exerciseId,
    required this.userAnswer,
    this.isCorrect,
  });

  factory SaveUserExerciseRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveUserExerciseRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveUserExerciseRequestToJson(this);
}
